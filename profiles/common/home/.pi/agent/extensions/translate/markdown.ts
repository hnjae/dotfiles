// Splits Markdown into what a translator may touch and what it must not.
//
// A document becomes blocks (what the display groups by) made of parts: a
// verbatim string, or a unit. A unit is one line's prose with every protected
// span (code, paths, links, identifiers...) replaced by a placeholder ⟦i⟧.
// Nothing outside a unit is ever sent to a translator, and a unit's spans are
// put back from the original bytes, so an engine cannot change code.

export type BlockKind =
  | "prose"
  | "heading"
  | "list"
  | "quote"
  | "table"
  | "code"
  | "blank"
  | "rule"
  | "html";
export type Part = string | { unit: number };
export type Block = { kind: BlockKind; original: string; parts: Part[] };
export type Unit = { text: string; spans: string[] };
export type Plan = { blocks: Block[]; units: Unit[] };

type Line = {
  kind: BlockKind;
  text: string;
  parts: Part[];
  alone?: boolean | undefined;
};

const LETTER = /\p{L}/u;
const PLACEHOLDER = /⟦(\d+)⟧/g;

// ---------------------------------------------------------------------------
// Inline masking

type Range = [number, number];

const INLINE_PATTERNS: RegExp[] = [
  // a literal placeholder-looking run in the source, so restore stays exact
  /⟦[^⟧\n]*⟧/gu,
  // images, whole
  /!\[[^\]\n]*\]\((?:[^()\s]|\([^()\s]*\))*(?:\s+"[^"\n]*")?\)/g,
  // link destinations: the text before stays translatable
  /\]\((?:[^()\s]|\([^()\s]*\))*(?:\s+"[^"\n]*")?\)/g,
  /\]\[[^\]\n]*\]/g,
  // autolinks and bare URLs
  /<(?:https?|mailto|file|ftp):[^>\s]+>/g,
  /\b(?:https?|file|ftp):\/\/[^\s<>`]+/g,
  // inline HTML tags
  /<\/?[A-Za-z][\w-]*(?:\s[^<>\n]*)?\/?>/g,
  // emails
  /[\w.+-]+@[\w-]+(?:\.[\w-]+)+/g,
  // paths: rooted, home, relative, or with two or more slashes
  /(?<![\w/.~-])(?:~|\.{1,2})?\/[\w.@+-]+(?:\/[\w.@+-]*)*(?::\d+(?::\d+)?)?/g,
  /(?<![\w/.~-])(?:~|\.{1,2})\/(?:[\w.@+-]+\/?)*(?::\d+(?::\d+)?)?(?=[\s,;:!?)\]]|$)/g,
  /(?<![\w/.-])[\w.@+-]+\/[\w.@+-]+\/[\w.@+/-]*(?::\d+(?::\d+)?)?/g,
  /(?<![\w/.-])[\w@+-]+(?:\/[\w@+-]+)*\/[\w@+-]+\.[A-Za-z0-9]{1,8}(?::\d+(?::\d+)?)?(?![\w])/g,
  // bare file names with a known extension
  /(?<![\w./-])[\w-]+(?:\.[\w-]+)*\.(?:d\.ts|tsx?|jsx?|mjs|cjs|mts|cts|json|jsonc|md|mdx|py|go|rs|swift|kt|kts|java|rb|sh|zsh|bash|fish|ya?ml|toml|lock|css|scss|less|html?|sql|txt|c|h|cc|cpp|hpp|cs|php|vue|svelte|xml|ini|env|log|csv|tsv|proto|gradle|plist|dart|lua|ex|exs|zig|nix|tf|dockerfile)(?::\d+(?::\d+)?)?(?![\w])/gi,
  // command-line flags
  /(?<![\w-])--[A-Za-z][\w-]*(?:=[^\s`]+)?/g,
  // environment variables
  /\$\{[^}\s]+\}|\$[A-Za-z_][A-Za-z0-9_]*/g,
  // calls: name(), obj.method(arg)
  /(?<![\w$.])[A-Za-z_$][\w$]*(?:\.[A-Za-z_$][\w$]*)*\([\w$.,'"]*\)/g,
  // dotted members whose parts are each at least two characters,
  // before the case rules so `Promise.allSettled` is one span
  /(?<![\w$.])[A-Za-z_$][\w$]+(?:\.[A-Za-z_$][\w$]+)+(?![\w$(])/g,
  // snake_case and SCREAMING_CASE
  /(?<![\w$])[A-Za-z0-9]+(?:_[A-Za-z0-9]+)+(?![\w$])/g,
  // camelCase and PascalCase with an inner capital
  /(?<![\w$])[a-z]+[A-Z][A-Za-z0-9]*(?![\w$])/g,
  /(?<![\w$])[A-Z][a-z0-9]+[A-Z][A-Za-z0-9]*(?![\w$])/g,
];

const TRAILING_PUNCT = /[.,;:!?'"]$/;

function trimUrl(text: string, start: number, end: number): number {
  while (end > start) {
    const s = text.slice(start, end);
    if (TRAILING_PUNCT.test(s)) {
      end--;
      continue;
    }
    if (s.endsWith(")")) {
      const open = (s.match(/\(/g) ?? []).length;
      const close = (s.match(/\)/g) ?? []).length;
      if (close > open) {
        end--;
        continue;
      }
    }
    break;
  }
  return end;
}

function inlineCodeRanges(text: string): Range[] {
  const out: Range[] = [];
  let i = 0;
  while (i < text.length) {
    if (text[i] !== "`") {
      i++;
      continue;
    }
    let n = 0;
    while (text[i + n] === "`") n++;
    // find a closing run of exactly n backticks
    let j = i + n;
    let found = -1;
    while (j < text.length) {
      if (text[j] !== "`") {
        j++;
        continue;
      }
      let m = 0;
      while (text[j + m] === "`") m++;
      if (m === n) {
        found = j;
        break;
      }
      j += m;
    }
    if (found === -1) {
      i += n;
      continue;
    }
    out.push([i, found + n]);
    i = found + n;
  }
  return out;
}

function overlaps(ranges: Range[], s: number, e: number): boolean {
  return ranges.some(([a, b]) => s < b && a < e);
}

function protectedRanges(text: string): Range[] {
  const ranges: Range[] = inlineCodeRanges(text);
  for (const pattern of INLINE_PATTERNS) {
    pattern.lastIndex = 0;
    for (const m of text.matchAll(pattern)) {
      const start = m.index ?? 0;
      let end = start + m[0].length;
      if (/^(?:https?|file|ftp):\/\//.test(m[0]) || /\//.test(m[0]))
        end = trimUrl(text, start, end);
      if (end <= start) continue;
      if (overlaps(ranges, start, end)) continue;
      ranges.push([start, end]);
    }
  }
  return ranges.sort((a, b) => a[0] - b[0]);
}

/** Masks a line's prose. Answers null when nothing is left to translate. */
export function maskText(text: string): Unit | null {
  const ranges = protectedRanges(text);
  const spans: string[] = [];
  let masked = "";
  let at = 0;
  for (const [s, e] of ranges) {
    masked += text.slice(at, s) + `⟦${spans.length}⟧`;
    spans.push(text.slice(s, e));
    at = e;
  }
  masked += text.slice(at);
  if (!LETTER.test(masked.replace(PLACEHOLDER, ""))) return null;
  return { text: masked, spans };
}

export function unmaskAt(plan: Plan, i: number): string {
  const unit = plan.units[i];
  return unit ? unmask(unit) : "";
}

export function unmask(unit: Unit): string {
  return unit.text.replace(
    PLACEHOLDER,
    (_, i: string) => unit.spans[Number(i)] ?? "",
  );
}

/**
 * Puts the protected spans back into a translation. Answers null when the
 * translation lost, repeated or invented a placeholder.
 */
export function restoreUnit(unit: Unit, translated: string): string | null {
  const loose = /⟦\s*(\d+)\s*⟧/g;
  const seen = new Array<number>(unit.spans.length).fill(0);
  for (const m of translated.matchAll(loose)) {
    const i = Number(m[1]);
    if (i >= unit.spans.length) return null;
    seen[i] = (seen[i] ?? 0) + 1;
  }
  if (seen.some((n) => n !== 1)) return null;
  return translated.replace(
    loose,
    (_, i: string) => unit.spans[Number(i)] ?? "",
  );
}

// ---------------------------------------------------------------------------
// Lines

const FENCE_OPEN =
  /^(\s*(?:>\s?)*\s*(?:(?:[-*+]|\d{1,9}[.)])\s+)*)\s{0,3}(`{3,}|~{3,})(.*)$/;
const QUOTE_PREFIX = /^(?:\s*>\s?)+/;
const HEADING = /^(\s{0,3}#{1,6})(\s+|$)/;
const HEADING_CLOSE = /(\s+#+)?(\s*)$/;
const LIST_ITEM = /^(\s*)([-*+]|\d{1,9}[.)])(\s+|$)(\[[ xX]\]\s+)?/;
const RULE = /^\s{0,3}([-*_])(?:[ \t]*\1){2,}[ \t]*\r?$/;
const HTML_LINE =
  /^\s*(?:<!--.*-->|<\/?[A-Za-z][\w-]*(?:\s[^<>]*)?\/?>)\s*\r?$/;
const HTML_COMMENT_OPEN = /^\s*<!--/;
const REF_DEFINITION = /^\s{0,3}\[[^\]\n]+\]:\s*\S/;
const TABLE_DELIMITER = /^\s*\|?\s*:?-+:?\s*(?:\|\s*:?-+:?\s*)*\|?\s*\r?$/;
const INDENTED = /^(?: {4}|\t)/;
const TRAILING_SPACE = /\s*$/;

type Ctx = { units: Unit[] };

function unitParts(ctx: Ctx, content: string): Part[] {
  if (content === "") return [];
  const unit = maskText(content);
  if (!unit) return [content];
  ctx.units.push(unit);
  return [{ unit: ctx.units.length - 1 }];
}

/** Prefix kept, prose as a unit, trailing whitespace kept. */
function proseParts(
  ctx: Ctx,
  prefix: string,
  body: string,
  close = "",
): Part[] {
  const trail = body.match(TRAILING_SPACE)?.[0] ?? "";
  const content = body.slice(0, body.length - trail.length);
  const parts: Part[] = [];
  if (prefix) parts.push(prefix);
  parts.push(...unitParts(ctx, content));
  if (trail || close) parts.push(trail + close);
  return parts;
}

/** Splits a line after its container prefix: heading, list item, or prose. */
function contentLine(
  ctx: Ctx,
  line: string,
  inList: boolean,
): {
  kind: BlockKind;
  parts: Part[];
  isItem: boolean;
  alone?: boolean | undefined;
} {
  const quote = line.match(QUOTE_PREFIX)?.[0];
  if (quote) {
    const rest = contentLine(ctx, line.slice(quote.length), false);
    return { kind: "quote", parts: [quote, ...rest.parts], isItem: false };
  }
  const heading = line.match(HEADING);
  if (heading) {
    const prefix = heading[0];
    let body = line.slice(prefix.length);
    // closing hashes stay with the marker
    const close = body.match(HEADING_CLOSE);
    let tail = "";
    if (close && close[1]) {
      tail = close[0];
      body = body.slice(0, body.length - tail.length);
    }
    return {
      kind: "heading",
      parts: proseParts(ctx, prefix, body, tail),
      isItem: false,
      alone: true,
    };
  }
  const item = line.match(LIST_ITEM);
  if (item && !RULE.test(line)) {
    const prefix = item[0];
    return {
      kind: "list",
      parts: proseParts(ctx, prefix, line.slice(prefix.length)),
      isItem: true,
    };
  }
  const lead = line.match(/^\s*/)?.[0] ?? "";
  const kind: BlockKind = inList && lead.length > 0 ? "list" : "prose";
  return {
    kind,
    parts: proseParts(ctx, lead, line.slice(lead.length)),
    isItem: false,
  };
}

/** Splits a table row on unescaped pipes outside inline code. */
function tableRow(ctx: Ctx, line: string): Part[] {
  const code = inlineCodeRanges(line);
  const pipes: number[] = [];
  for (let i = 0; i < line.length; i++) {
    if (line[i] !== "|") continue;
    if (i > 0 && line[i - 1] === "\\") continue;
    if (overlaps(code, i, i + 1)) continue;
    pipes.push(i);
  }
  const parts: Part[] = [];
  let at = 0;
  const cut = [...pipes, line.length];
  for (const p of cut) {
    const cell = line.slice(at, p);
    const lead = cell.match(/^\s*/)?.[0] ?? "";
    const trail = cell.slice(lead.length).match(TRAILING_SPACE)?.[0] ?? "";
    const content = cell.slice(lead.length, cell.length - trail.length);
    if (lead) parts.push(lead);
    parts.push(...unitParts(ctx, content));
    if (trail) parts.push(trail);
    if (p < line.length) parts.push("|");
    at = p + 1;
  }
  return parts;
}

function fenceCloses(line: string, char: string, len: number): boolean {
  const stripped = line.replace(QUOTE_PREFIX, "").trim();
  if (stripped.length < len) return false;
  for (const c of stripped) if (c !== char) return false;
  return true;
}

function planLines(md: string, ctx: Ctx): Line[] {
  const lines = md.split("\n");
  const out: Line[] = [];
  let fence: { char: string; len: number } | null = null;
  let comment = false;
  let inList = false;
  let table = false;
  let indented = false;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i] ?? "";
    const prev = out[out.length - 1];

    if (fence) {
      out.push({ kind: "code", text: line, parts: [line] });
      if (fenceCloses(line, fence.char, fence.len)) fence = null;
      continue;
    }
    if (comment) {
      out.push({ kind: "html", text: line, parts: [line] });
      if (line.includes("-->")) comment = false;
      continue;
    }

    const open = line.match(FENCE_OPEN);
    const run = open?.[2] ?? "";
    if (open && run && !(run[0] === "`" && (open[3] ?? "").includes("`"))) {
      fence = { char: run[0] ?? "`", len: run.length };
      indented = false;
      out.push({ kind: "code", text: line, parts: [line], alone: true });
      continue;
    }

    if (line.trim() === "") {
      out.push({ kind: "blank", text: line, parts: [line] });
      table = false;
      continue;
    }

    if (table) {
      if (line.includes("|")) {
        out.push({
          kind: "table",
          text: line,
          parts: TABLE_DELIMITER.test(line) ? [line] : tableRow(ctx, line),
        });
        continue;
      }
      table = false;
    }
    if (
      line.includes("|") &&
      i + 1 < lines.length &&
      TABLE_DELIMITER.test(lines[i + 1] ?? "") &&
      (lines[i + 1] ?? "").includes("-")
    ) {
      table = true;
      inList = false;
      out.push({
        kind: "table",
        text: line,
        parts: tableRow(ctx, line),
        alone: true,
      });
      continue;
    }

    if (INDENTED.test(line) && !inList) {
      if (indented && prev?.kind === "code") {
        out.push({ kind: "code", text: line, parts: [line] });
        continue;
      }
      if (!prev || prev.kind === "blank") {
        indented = true;
        out.push({ kind: "code", text: line, parts: [line], alone: true });
        continue;
      }
    }
    indented = false;

    if (RULE.test(line)) {
      out.push({ kind: "rule", text: line, parts: [line], alone: true });
      inList = false;
      continue;
    }
    if (HTML_COMMENT_OPEN.test(line) && !line.includes("-->")) {
      comment = true;
      out.push({ kind: "html", text: line, parts: [line], alone: true });
      continue;
    }
    if (HTML_LINE.test(line)) {
      out.push({ kind: "html", text: line, parts: [line] });
      continue;
    }
    if (REF_DEFINITION.test(line)) {
      out.push({ kind: "prose", text: line, parts: [line] });
      continue;
    }

    const c = contentLine(ctx, line, inList);
    if (c.isItem) inList = true;
    else if (c.kind === "prose" || c.kind === "heading" || c.kind === "quote")
      inList = false;
    out.push({ kind: c.kind, text: line, parts: c.parts, alone: c.alone });
  }
  return out;
}

// ---------------------------------------------------------------------------
// Blocks

export function planMarkdown(md: string): Plan {
  const ctx: Ctx = { units: [] };
  const lines = planLines(md, ctx);
  const blocks: Block[] = [];
  for (const line of lines) {
    const last = blocks[blocks.length - 1];
    const joins = last && last.kind === line.kind && !line.alone;
    if (joins) {
      last.original += "\n" + line.text;
      last.parts.push("\n", ...line.parts);
    } else {
      blocks.push({
        kind: line.kind,
        original: line.text,
        parts: [...line.parts],
      });
    }
  }
  return { blocks, units: ctx.units };
}

/** The block with each unit replaced by `out[unit]`; null when one is missing. */
export function buildBlock(
  _plan: Plan,
  block: Block,
  out: readonly (string | null | undefined)[],
): string | null {
  let text = "";
  for (const part of block.parts) {
    if (typeof part === "string") {
      text += part;
      continue;
    }
    const t = out[part.unit];
    if (t == null) return null;
    text += t;
  }
  return text;
}

/** The whole document; a unit with no translation keeps its original text. */
export function buildDocument(
  plan: Plan,
  out: readonly (string | null | undefined)[],
): string {
  return plan.blocks
    .map((block) =>
      block.parts
        .map((part) =>
          typeof part === "string"
            ? part
            : (out[part.unit] ?? unmaskAt(plan, part.unit)),
        )
        .join(""),
    )
    .join("\n");
}

/** The units a block holds, in order. */
export function blockUnits(block: Block): number[] {
  return block.parts.flatMap((p) => (typeof p === "string" ? [] : [p.unit]));
}
