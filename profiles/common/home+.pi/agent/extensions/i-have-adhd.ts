// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 KIM Hyunjae

/**
 * Keep the `i-have-adhd` skill in the system prompt of every terminal run.
 *
 * The skill sets `disable-model-invocation`, because its rules apply to the rest
 * of the session rather than to one task, so pi neither advertises it to the
 * model nor loads it on its own. Injecting the body as a prompt section is the
 * only way to have it shape the first reply without a paid warm-up turn.
 *
 * The body is read from the skill pool on every run instead of copied here, so
 * the pinned skill stays the single source: an edit or a `restore` takes effect
 * on the next run. Only terminal runs get the section, because `"rpc"`,
 * `"json"` and `"print"` runs write output a program consumes, not a reply a
 * person reads.
 */
import { readFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const SKILL_PATH = join(
  homedir(),
  ".agents",
  "skills",
  "i-have-adhd",
  "SKILL.md",
);
const SECTION = "i_have_adhd";

/** One warning per process; a missing skill would otherwise notify on every run. */
let warned = false;

/** Drop the YAML frontmatter so only the instructions reach the prompt. */
function stripFrontmatter(text: string): string {
  const match = /^---\r?\n[\s\S]*?\r?\n---[ \t]*\r?\n/.exec(text);
  return match ? text.slice(match[0].length) : text;
}

function warn(ctx: ExtensionContext, message: string): void {
  if (warned) return;
  warned = true;
  ctx.ui.notify(`i-have-adhd hint skipped: ${message}`, "warning");
}

async function readSkillBody(
  ctx: ExtensionContext,
): Promise<string | undefined> {
  try {
    const body = stripFrontmatter(await readFile(SKILL_PATH, "utf8")).trim();
    if (body) return body;
    warn(ctx, `${SKILL_PATH} has an empty body`);
  } catch (error) {
    warn(ctx, `cannot read ${SKILL_PATH}: ${String(error)}`);
  }
  return undefined;
}

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event, ctx) => {
    const sections = event.systemPromptOptions.sections;
    if (ctx.mode !== "tui") {
      delete sections[SECTION];
      return;
    }
    const body = await readSkillBody(ctx);
    if (body) sections[SECTION] = body;
    else delete sections[SECTION];
  });
}
