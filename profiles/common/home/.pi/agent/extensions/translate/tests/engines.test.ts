import assert from "node:assert/strict";
import { test } from "node:test";

import {
  batches,
  type Io,
  MAX_UNITS,
  parseArray,
  translateTexts,
} from "../engines.ts";
import { buildDocument, planMarkdown, restoreUnit } from "../markdown.ts";

/** A translator that answers with whatever `reply` returns for one call. */
function fake(
  reply: (texts: string[]) => string | Promise<string>,
): Io & { calls: string[][] } {
  const calls: string[][] = [];
  return {
    calls,
    async complete({ prompt }) {
      const texts = JSON.parse(prompt) as string[];
      calls.push(texts);
      return await reply(texts);
    },
  };
}

test("parseArray reads a bare array, a fenced one, and prose around it", () => {
  assert.deepEqual(parseArray('["a","b"]'), ["a", "b"]);
  assert.deepEqual(parseArray('```json\n["a"]\n```'), ["a"]);
  assert.deepEqual(parseArray('Here you go:\n["a"]\nDone.'), ["a"]);
  assert.equal(parseArray("no array here"), null);
  assert.equal(parseArray("[1,2]"), null);
  assert.equal(parseArray('{"a":1}'), null);
});

test("batches split by count and by size", () => {
  const many = Array.from({ length: MAX_UNITS + 1 }, (_, i) => `line ${i}`);
  assert.deepEqual(
    batches(many).map((b) => b.length),
    [MAX_UNITS, 1],
  );
  const long = ["x".repeat(4000), "y".repeat(4000)];
  assert.deepEqual(batches(long), [[0], [1]]);
  assert.deepEqual(batches([]), []);
});

test("a translator that answers in order is used as is", async () => {
  const io = fake((texts) => JSON.stringify(texts.map((t) => t.toUpperCase())));
  const r = await translateTexts(io, ["one", "two"], "ko", "en");
  assert.deepEqual(r.out, ["ONE", "TWO"]);
  assert.equal(r.error, undefined);
});

test("a reply of the wrong length is retried as two halves", async () => {
  const io = fake((texts) => {
    // Answer short once at the top level; each half answers correctly.
    if (texts.length === 4) return JSON.stringify(["only one"]);
    return JSON.stringify(texts.map((t) => t.toUpperCase()));
  });
  const r = await translateTexts(io, ["a", "b", "c", "d"], "ko", "en");
  assert.deepEqual(r.out, ["A", "B", "C", "D"]);
  assert.deepEqual(
    io.calls.map((c) => c.length),
    [4, 2, 2],
  );
});

test("one failing half leaves the other half usable", async () => {
  const io = fake((texts) => {
    if (texts.includes("c")) throw new Error("HTTP 500");
    return JSON.stringify(texts.map((t) => t.toUpperCase()));
  });
  const r = await translateTexts(io, ["a", "b", "c", "d"], "ko", "en");
  assert.deepEqual(r.out, ["A", "B", null, null]);
  assert.equal(r.error, "HTTP 500");
});

test("a batch that fails throughout reports why and gives up on its units", async () => {
  const io = fake(() => {
    throw new Error("HTTP 500");
  });
  const r = await translateTexts(io, ["a", "b"], "ko", "en");
  assert.deepEqual(r.out, [null, null]);
  assert.equal(r.error, "HTTP 500");
});

test("a single unit that cannot be answered is null, not a guessing game", async () => {
  const io = fake(() => "sorry, I cannot do that");
  const r = await translateTexts(io, ["하나"], "ko", "en");
  assert.deepEqual(r.out, [null]);
  assert.equal(r.error, "the reply was not a JSON array");
});

test("masked code survives a round trip through a translator", async () => {
  const source = "`hooks/register.tsx:12` 의 `Promise.all` 을 왜 기다려야 해?";
  const plan = planMarkdown(source);
  const io = fake((texts) =>
    JSON.stringify(
      texts.map((t) => t.replace("왜", "why do we have to").replace("을", "")),
    ),
  );

  const r = await translateTexts(
    io,
    plan.units.map((u) => u.text),
    "ko",
    "en",
  );
  const out = plan.units.map((unit, i) => {
    const translated = r.out[i];
    return translated == null ? null : restoreUnit(unit, translated);
  });
  assert.ok(
    out.every((t) => t !== null),
    "every unit survived",
  );
  const english = buildDocument(plan, out);
  assert.ok(english.includes("`hooks/register.tsx:12`"), english);
  assert.ok(english.includes("`Promise.all`"), english);
});

test("a translator that drops a placeholder fails that unit", () => {
  const plan = planMarkdown("`a.ts` 를 봐줘");
  const unit = plan.units[0];
  assert.ok(unit !== undefined);
  assert.equal(restoreUnit(unit, "look at it"), null);
});
