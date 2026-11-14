/**
 * Korean draft in, English to the model.
 *
 * The rewrite happens inside the `input` handler, so everything downstream —
 * the transcript, the context, the next request — sees English only. The draft
 * itself stays visible as a dim entry that is not part of LLM context. There is
 * no reply-translation path: whatever the model writes comes back untouched.
 *
 * Translation runs on masked Markdown (`markdown.ts`), so code, paths, links
 * and identifiers are copied from the original bytes and a translator cannot
 * damage them. A prompt whose translation fails is sent as typed rather than
 * half-translated: a mixed-language prompt is worse than a Korean one.
 *
 * `MODEL` is a constant on purpose; that is where a setting goes later.
 */
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { Box, Text } from "@earendil-works/pi-tui";

import { scriptOf, scriptShare } from "./detect.ts";
import { type Io, translateTexts } from "./engines.ts";
import {
  buildDocument,
  planMarkdown,
  type Plan,
  restoreUnit,
  type Unit,
} from "./markdown.ts";

const MODEL = { provider: "opencode-go", id: "deepseek-v4.1-flash" };
const SOURCE = "ko";
const TARGET = "en";
const SCRIPT = scriptOf(SOURCE);

/** Below this share of Hangul letters a draft is left alone. */
const MIN_SHARE = 0.2;
/**
 * How long Enter waits for an answer before the draft is sent as typed. The
 * provider is a thinking model whose thinking cannot be turned off (see the
 * note on `complete` below), and a three-line prompt measured 2.5-10s.
 */
const BUDGET_MS = 20_000;
const STATUS_KEY = "translate";
const ENTRY_TYPE = "translate-source";

/** Restored translations, keyed by the unit they belong to (text and spans). */
const unitCache = new Map<string, string>();
/** Finished prompts, so a retyped or recalled draft costs nothing. */
const promptCache = new Map<string, string>();

let enabled = true;
let warnedMissingModel = false;

type TranslatorModel = NonNullable<
  ReturnType<ExtensionContext["modelRegistry"]["find"]>
>;
type Outcome = { english: string } | { error: string };

export default function translate(pi: ExtensionAPI) {
  pi.on("input", async (event, ctx) => {
    if (!enabled) return { action: "continue" };
    // Extension- and template-sourced prompts are already what the user meant.
    if (event.source === "extension") return { action: "continue" };
    if (!needsTranslation(event.text)) return { action: "continue" };

    const model = ctx.modelRegistry.find(MODEL.provider, MODEL.id);
    if (!model) {
      if (ctx.hasUI && !warnedMissingModel) {
        warnedMissingModel = true;
        ctx.ui.notify(
          `translate: ${MODEL.provider}/${MODEL.id} is not configured; prompts go as typed`,
          "warning",
        );
      }
      return { action: "continue" };
    }

    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), BUDGET_MS);
    setStatus(ctx, "translating ko→en…");
    try {
      const result = await toEnglish(event.text, ctx, model, controller.signal);
      if ("error" in result) {
        if (ctx.hasUI)
          ctx.ui.notify(
            `translate: ${result.error}; the prompt went as typed`,
            "warning",
          );
        return { action: "continue" };
      }
      pi.appendEntry(ENTRY_TYPE, { text: event.text });
      return { action: "transform", text: result.english };
    } finally {
      clearTimeout(timer);
      showState(ctx);
    }
  });

  // The footer carries the switch, so "off" is visible rather than assumed.
  pi.on("session_start", (_event, ctx) => showState(ctx));

  pi.registerEntryRenderer(ENTRY_TYPE, (entry, { expanded }, theme) => {
    const data = entry.data as { text?: string } | null;
    const text = data?.text ?? "";
    const box = new Box(1, 0, (line) => theme.bg("customMessageBg", line));
    box.addChild(
      new Text(
        theme.fg("dim", `${SOURCE} ▸ ${expanded ? text : shorten(text)}`),
        0,
        0,
      ),
    );
    return box;
  });

  pi.registerCommand("translate", {
    description: "Translate Korean prompts to English before they are sent",
    handler: async (args, ctx) => {
      const arg = args.trim().toLowerCase();
      if (arg === "status") {
        const model = ctx.modelRegistry.find(MODEL.provider, MODEL.id)
          ? "configured"
          : "MISSING";
        ctx.ui.notify(
          `translate ${enabled ? "on" : "off"} · ${SOURCE}→${TARGET} · ` +
            `${MODEL.provider}/${MODEL.id} (${model}) · ${unitCache.size} lines, ` +
            `${promptCache.size} prompts cached`,
          "info",
        );
        return;
      }
      if (arg && arg !== "on" && arg !== "off") {
        ctx.ui.notify("usage: /translate [on|off|status]", "warning");
        return;
      }
      enabled = arg ? arg === "on" : !enabled;
      showState(ctx);
      ctx.ui.notify(`translate ${enabled ? "on" : "off"}`, "info");
    },
  });
}

/** True when the draft is prose in the source script and not a command. */
function needsTranslation(text: string): boolean {
  const body = text.trim();
  if (body.length < 2) return false;
  if (body.startsWith("/") || body.startsWith("!")) return false;
  return scriptShare(body, SCRIPT) >= MIN_SHARE;
}

async function toEnglish(
  text: string,
  ctx: ExtensionContext,
  model: TranslatorModel,
  signal: AbortSignal,
): Promise<Outcome> {
  const cached = promptCache.get(text);
  if (cached !== undefined) return { english: cached };

  const plan = planMarkdown(text);
  if (plan.units.length === 0) return { english: text };

  const out: (string | null)[] = plan.units.map(
    (unit) => unitCache.get(unitKey(unit)) ?? null,
  );
  const io = modelIo(ctx, model, signal);

  let missing = missingUnits(out);
  if (missing.length > 0) await fill(out, plan, io, missing);
  missing = missingUnits(out);
  // A unit that failed once is often the batch's fault, not the line's.
  if (missing.length > 0 && !signal.aborted) await fill(out, plan, io, missing);

  if (signal.aborted) return { error: `no answer within ${BUDGET_MS / 1000}s` };
  if (missingUnits(out).length > 0)
    return { error: "the translator lost a line" };

  const english = buildDocument(plan, out);
  promptCache.set(text, english);
  return { english };
}

/** Translates the units at `indexes` and restores their protected spans. */
async function fill(
  out: (string | null)[],
  plan: Plan,
  io: Io,
  indexes: number[],
): Promise<void> {
  const units = indexes.flatMap((index) => {
    const unit = plan.units[index];
    return unit ? [unit] : [];
  });
  if (units.length === 0) return;

  const result = await translateTexts(
    io,
    units.map((unit) => unit.text),
    SOURCE,
    TARGET,
  );
  units.forEach((unit, k) => {
    const translated = result.out[k];
    const index = indexes[k];
    if (translated == null || index === undefined) return;
    // A lost or duplicated placeholder means this line cannot be trusted.
    const restored = restoreUnit(unit, translated);
    if (restored === null) return;
    out[index] = restored;
    unitCache.set(unitKey(unit), restored);
  });
}

/** One pi model call per batch, answered as plain text. */
function modelIo(
  ctx: ExtensionContext,
  model: TranslatorModel,
  signal: AbortSignal,
): Io {
  return {
    async complete({ system, prompt, maxTokens }) {
      const reply = await ctx.modelRegistry.complete(
        model,
        {
          systemPrompt: system,
          messages: [
            {
              role: "user",
              content: [{ type: "text", text: prompt }],
              timestamp: Date.now(),
            },
          ],
        },
        // No reasoning option on purpose. This model's `off` level is null in
        // its catalog entry, so pi cannot send `thinking: {type: "disabled"}`
        // and the provider thinks by default. Measured on three lines: absent
        // 341 thinking characters, `low` 973, `high` 863 — nothing beats
        // absent, and "none" does not exist for this model.
        {
          maxTokens,
          signal,
          cacheRetention: "none",
          sessionId: ctx.sessionManager.getSessionId(),
        },
      );
      // A failed request comes back as a message with no content, not a throw.
      if (reply.stopReason === "error")
        throw new Error(reply.errorMessage ?? "the model call failed");
      return reply.content
        .flatMap((part) => (part.type === "text" ? [part.text] : []))
        .join("\n");
    },
  };
}

function unitKey(unit: Unit): string {
  return JSON.stringify([unit.text, unit.spans]);
}

function missingUnits(out: (string | null)[]): number[] {
  return out.flatMap((translated, index) =>
    translated === null ? [index] : [],
  );
}

/** "on" or "off" in the footer; a running translation replaces it for a while. */
function showState(ctx: ExtensionContext): void {
  setStatus(ctx, `translate ${enabled ? "on" : "off"}`);
}

function setStatus(ctx: ExtensionContext, text: string | undefined): void {
  if (ctx.hasUI) ctx.ui.setStatus(STATUS_KEY, text);
}

/** The first few lines, for the collapsed entry. */
function shorten(text: string): string {
  const lines = text.split("\n");
  const head = lines.slice(0, 3).join("\n");
  return lines.length > 3 ? `${head}\n…` : head;
}
