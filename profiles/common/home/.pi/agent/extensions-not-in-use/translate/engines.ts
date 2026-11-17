// Talks to a translator: masked unit texts in, masked translations out.
//
// The protocol is one JSON array per call. Long prompts are split into batches
// by count and size, and a reply whose length does not match its batch is
// retried once as two halves, so one bad batch costs only the units in it.
// Nothing here knows about pi: `Io` is the whole host surface, which keeps the
// protocol testable with a fake.

export const MAX_UNITS = 40;
export const MAX_CHARS = 6000;

/** What the translator needs from its host; index.ts adapts a pi model to it. */
export type Io = {
  complete(req: {
    system: string;
    prompt: string;
    maxTokens: number;
  }): Promise<string>;
};

export type Translated = {
  /** Masked translations, null for a unit that failed. */
  out: (string | null)[];
  /** Why something failed, when anything did. */
  error?: string;
};

export function languageName(code: string): string {
  try {
    const names = new Intl.DisplayNames(["en"], { type: "language" });
    return names.of(code) ?? code;
  } catch {
    return code;
  }
}

export function systemPrompt(from: string, to: string): string {
  const source = languageName(from);
  const target = languageName(to);
  return [
    `You are a translation engine for a software developer's conversation with a coding assistant.`,
    `Translate each string of the JSON array from ${source} to ${target}.`,
    `Reply with ONLY a JSON array of strings: the same length and order as the input, one translation per input string. No prose, no code fence.`,
    `Rules:`,
    `- Tokens like ⟦0⟧, ⟦1⟧ stand for code, paths or links. Copy every token exactly once, unchanged, where it belongs in the translated sentence.`,
    `- Keep Markdown markers (**, *, _, ~~, [ ]) around the words they wrap.`,
    `- Keep technical terms, product names and identifiers that ${target}-speaking developers normally leave in English.`,
    `- Keep the tone: terse stays terse. Do not add, explain or omit anything.`,
    `- A string already in ${target} is returned unchanged.`,
  ].join("\n");
}

/** Reads a JSON array of strings out of a model's reply. */
export function parseArray(reply: string): string[] | null {
  let text = reply.trim();
  const fence = text.match(/^```(?:json)?\s*\n([\s\S]*?)\n?```$/);
  if (fence) text = fence[1] ?? text;
  const start = text.indexOf("[");
  const end = text.lastIndexOf("]");
  if (start === -1 || end <= start) return null;
  try {
    const value: unknown = JSON.parse(text.slice(start, end + 1));
    if (!Array.isArray(value)) return null;
    if (!value.every((v) => typeof v === "string")) return null;
    return value as string[];
  } catch {
    return null;
  }
}

/** Splits units into batches by count and size. */
export function batches(texts: string[]): number[][] {
  const out: number[][] = [];
  let cur: number[] = [];
  let size = 0;
  texts.forEach((t, i) => {
    if (
      cur.length > 0 &&
      (cur.length >= MAX_UNITS || size + t.length > MAX_CHARS)
    ) {
      out.push(cur);
      cur = [];
      size = 0;
    }
    cur.push(i);
    size += t.length;
  });
  if (cur.length > 0) out.push(cur);
  return out;
}

async function ask(io: Io, system: string, texts: string[]): Promise<string[]> {
  const prompt = JSON.stringify(texts);
  const reply = await io.complete({
    system,
    prompt,
    maxTokens: Math.min(16_000, 512 + prompt.length * 2),
  });
  const arr = parseArray(reply);
  if (!arr) throw new Error("the reply was not a JSON array");
  return arr;
}

type Batch = { out: (string | null)[]; error?: string };

/**
 * One batch, split in half once when the reply does not line up or the call
 * fails: one line spoils a batch more often than a whole prompt does, so the
 * halves that do answer are kept.
 */
async function runBatch(
  io: Io,
  system: string,
  texts: string[],
  depth = 0,
): Promise<Batch> {
  const nothing: Batch = { out: texts.map(() => null) };
  try {
    const arr = await ask(io, system, texts);
    if (arr.length === texts.length) return { out: arr };
    if (depth > 0 || texts.length < 2)
      return { ...nothing, error: "the reply had the wrong length" };
  } catch (e) {
    if (depth > 0 || texts.length < 2)
      return { ...nothing, error: e instanceof Error ? e.message : String(e) };
  }
  const mid = Math.ceil(texts.length / 2);
  const [a, b] = await Promise.all([
    runBatch(io, system, texts.slice(0, mid), 1),
    runBatch(io, system, texts.slice(mid), 1),
  ]);
  const merged: Batch = { out: [...a.out, ...b.out] };
  const first = a.error ?? b.error;
  if (first !== undefined) merged.error = first;
  return merged;
}

/** Translates masked unit texts from `from` to `to`; null marks a failed unit. */
export async function translateTexts(
  io: Io,
  texts: string[],
  from: string,
  to: string,
): Promise<Translated> {
  const out: (string | null)[] = texts.map(() => null);
  const system = systemPrompt(from, to);
  let error: string | undefined;

  for (const batch of batches(texts)) {
    const got = await runBatch(
      io,
      system,
      batch.map((i) => texts[i] ?? ""),
    );
    batch.forEach((unitIndex, k) => {
      out[unitIndex] = got.out[k] ?? null;
    });
    if (got.error !== undefined && error === undefined) error = got.error;
  }
  if (!error && out.some((t) => t === null))
    error = "some lines came back incomplete";
  const translated: Translated = { out };
  if (error !== undefined) translated.error = error;
  return translated;
}
