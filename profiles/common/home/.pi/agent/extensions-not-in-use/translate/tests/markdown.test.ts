import assert from "node:assert/strict";
import { test } from "node:test";

import {
  buildBlock,
  buildDocument,
  maskText,
  planMarkdown,
  restoreUnit,
  unmask,
} from "../markdown.ts";
import { scriptOf, scriptShare } from "../detect.ts";

// The corpus arrived from vitest-shaped tests; these are the matchers it uses.
function expect(actual: unknown) {
  return {
    toBe: (want: unknown) => assert.strictEqual(actual, want),
    toEqual: (want: unknown) => assert.deepStrictEqual(actual, want),
    toContain: (want: unknown) => {
      const has =
        typeof actual === "string"
          ? actual.includes(String(want))
          : Array.isArray(actual) && actual.includes(want);
      assert.ok(
        has,
        `${JSON.stringify(actual)} does not contain ${JSON.stringify(want)}`,
      );
    },
    toHaveLength: (want: number) => {
      const length = (actual as { length?: number } | null)?.length;
      assert.strictEqual(length, want);
    },
    toBeGreaterThan: (want: number) => {
      assert.ok(
        typeof actual === "number" && actual > want,
        `${String(actual)} is not greater than ${want}`,
      );
    },
  };
}

const CORPUS = [
  "",
  "Hello world",
  "The loop calls `fetchUser()` on every iteration.\n\nMove it out:",
  "```ts\nconst x = 1 // comment with words\n```",
  "```\nunclosed fence\nstill code",
  '~~~python\nprint("hi")\n~~~\nAfter the fence.',
  "# Title\n## Sub title ##\nText under it.",
  "- first item\n- second item with `code`\n  continuation line\n\n1. numbered\n2) other",
  "- [ ] todo item\n- [x] done item",
  "> quoted line\n> - quoted list item\n> ## quoted heading",
  "| Name | Value |\n| --- | :-: |\n| alpha `a|b` | beta |\n| x \\| y | `z` |",
  "Line with hard break  \nnext line",
  "Windows line\r\nending\r\n",
  "---\n***\n___",
  "<!-- a comment\nspanning lines -->\nText.",
  "<details>\n<summary>More</summary>\nInside text.\n</details>",
  'See [the docs](https://example.com/a_(b)) and ![logo](img/logo.png "Logo").',
  "Edit `hooks/register.tsx:12` and ~/repo-mid/cc-trans/README.md then run --dry-run.",
  "Set $HOME and ${PATH} for snake_case_name and camelCase and GitHub.",
  "Visit https://example.com/path?q=1, then <https://x.y>.",
  "Mail me at a.b@example.com.",
  "Indented code:\n\n    const a = 1\n    const b = 2\n\nBack to prose.",
  "- item\n\n    indented continuation inside list",
  "```js\n```\n```js\n```",
  "Odd ⟦0⟧ text in source.",
  "12345 !!! ---- ...",
  "1. Run `npm test`:\n   ```bash\n   npm test\n   ```\n2. Then read the output.",
  "Trailing spaces   ",
  "[ref]: https://example.com\nUse [ref][ref] here.",
];

test("round trip: unmasked units rebuild every document exactly", () => {
  for (const md of CORPUS) {
    const plan = planMarkdown(md);
    expect(buildDocument(plan, plan.units.map(unmask))).toBe(md);
    expect(plan.blocks.map((b) => b.original).join("\n")).toBe(md);
    for (const block of plan.blocks) {
      expect(buildBlock(plan, block, plan.units.map(unmask))).toBe(
        block.original,
      );
    }
  }
});

test("fenced code is never in a unit", () => {
  const plan = planMarkdown(
    'Intro words.\n```ts\nconst greeting = "hello world"\n```\nOutro words.',
  );
  expect(plan.units.map(unmask)).toEqual(["Intro words.", "Outro words."]);
  expect(plan.blocks.map((b) => b.kind)).toEqual(["prose", "code", "prose"]);
});

test("a fence inside a list item stays code", () => {
  const plan = planMarkdown(
    "1. Run `npm test`:\n   ```bash\n   npm test\n   ```\n2. Then read the output.",
  );
  const texts = plan.units.map(unmask);
  expect(texts).toEqual(["Run `npm test`:", "Then read the output."]);
  expect(plan.blocks.map((b) => b.kind)).toEqual(["list", "code", "list"]);
});

test("markers stay outside units", () => {
  const plan = planMarkdown(
    "# Title ##\n- [ ] todo item\n> quoted words\n  - nested item",
  );
  expect(plan.units.map((u) => u.text)).toEqual([
    "Title",
    "todo item",
    "quoted words",
    "nested item",
  ]);
});

test("table cells are units, pipes and delimiter row are kept", () => {
  const plan = planMarkdown(
    "| Name | Value |\n| --- | --- |\n| alpha `a|b` | beta |",
  );
  expect(plan.units.map(unmask)).toEqual([
    "Name",
    "Value",
    "alpha `a|b`",
    "beta",
  ]);
  expect(plan.blocks).toHaveLength(1);
  expect(plan.blocks[0]!.kind).toBe("table");
});

test("protected spans are masked; link text is not", () => {
  const u = maskText(
    "See [the docs](https://e.com/x) and `a.b()` in src/app/main.ts:3 or ~/x.",
  )!;
  expect(u.text).toBe("See [the docs⟦0⟧ and ⟦1⟧ in ⟦2⟧ or ⟦3⟧.");
  expect(u.spans).toEqual([
    "](https://e.com/x)",
    "`a.b()`",
    "src/app/main.ts:3",
    "~/x",
  ]);
});

test("identifiers, flags, env vars, URLs, emails are masked", () => {
  const cases: [string, string[]][] = [
    ["call fetchUser() now", ["fetchUser()"]],
    ["use --dry-run flag", ["--dry-run"]],
    ["set $HOME please", ["$HOME"]],
    ["the snake_case name", ["snake_case"]],
    ["the camelCase name", ["camelCase"]],
    ["open register.tsx now", ["register.tsx"]],
    ["go to https://example.com/a.", ["https://example.com/a"]],
    ["mail a.b@example.com today", ["a.b@example.com"]],
    ["the obj.method chain", ["obj.method"]],
  ];
  for (const [text, spans] of cases)
    expect(maskText(text)!.spans).toEqual(spans);
});

test("ordinary words with slashes or dots are not masked", () => {
  for (const text of [
    "and/or input/output",
    "e.g. this, i.e. that",
    "It ends here. Next one.",
  ]) {
    expect(maskText(text)!.spans).toEqual([]);
  }
});

test("a line with no letters outside spans is not a unit", () => {
  expect(maskText("`npm test`")).toBe(null);
  expect(maskText("12345 !!!")).toBe(null);
  expect(planMarkdown("`npm test`\n\nWords here.").units.map(unmask)).toEqual([
    "Words here.",
  ]);
});

test("restoreUnit puts back original bytes and rejects broken placeholders", () => {
  const u = maskText("Call `foo()` with --force now")!;
  expect(restoreUnit(u, "⟦0⟧를 ⟦1⟧ 옵션으로 지금 호출")).toBe(
    "`foo()`를 --force 옵션으로 지금 호출",
  );
  expect(restoreUnit(u, "⟦ 0 ⟧ 와 ⟦1 ⟧")).toBe("`foo()` 와 --force");
  expect(restoreUnit(u, "⟦0⟧만 호출")).toBe(null);
  expect(restoreUnit(u, "⟦0⟧ ⟦0⟧ ⟦1⟧")).toBe(null);
  expect(restoreUnit(u, "⟦0⟧ ⟦1⟧ ⟦2⟧")).toBe(null);
});

test("an engine that rewrites words never touches code", () => {
  const md = [
    "## Fix the loop",
    "",
    "The loop calls `fetchUser(id)` on every pass in src/users/load.ts:42.",
    "",
    "```ts",
    "for (const id of ids) await fetchUser(id)",
    "```",
    "",
    "| Step | Command |",
    "| --- | --- |",
    "| install | `npm ci` |",
  ].join("\n");
  const plan = planMarkdown(md);
  const shout = plan.units.map((u) =>
    restoreUnit(
      u,
      u.text.replace(/[a-z]+/g, (w) => w.toUpperCase()),
    ),
  );
  const out = buildDocument(plan, shout);
  expect(out).toContain("for (const id of ids) await fetchUser(id)");
  expect(out).toContain("`fetchUser(id)`");
  expect(out).toContain("src/users/load.ts:42");
  expect(out).toContain("`npm ci`");
  expect(out).toContain("## FIX THE LOOP");
  expect(out).toContain("| STEP | COMMAND |");
  expect(out).toContain("| --- | --- |");
});

test("a missing unit makes its block null and falls back in the document", () => {
  const plan = planMarkdown("First line.\n\nSecond line.");
  const out = ["첫 줄.", null];
  expect(buildBlock(plan, plan.blocks[0]!, out)).toBe("첫 줄.");
  expect(buildBlock(plan, plan.blocks[2]!, out)).toBe(null);
  expect(buildDocument(plan, out)).toBe("첫 줄.\n\nSecond line.");
});

test("script detection ignores code", () => {
  expect(scriptOf("ko")).toBe("Hangul");
  expect(scriptOf("ja-JP")).toBe("Japanese");
  expect(scriptOf("zh-Hant")).toBe("Han");
  expect(scriptOf("es")).toBe("Latin");
  expect(scriptShare("이 함수 왜 느린지 봐줘", "Hangul")).toBe(1);
  expect(scriptShare("`fetchUserFromDatabase()` 고쳐줘", "Hangul")).toBe(1);
  expect(
    scriptShare("```ts\nconst longEnglishIdentifier = 1\n```\n왜?", "Hangul"),
  ).toBe(1);
  expect(scriptShare("Fix this bug", "Hangul")).toBe(0);
  expect(scriptShare("漢字だけ", "Japanese")).toBeGreaterThan(0.9);
  expect(scriptShare("汉字", "Japanese")).toBe(0);
  expect(scriptShare("", "Hangul")).toBe(0);
});

test("a sentence period after Hangul is not masked; dotted members are one span", () => {
  const u = maskText(
    "Promise.all과 Promise.allSettled 차이를 알려줘. 코드와 파일은 빼고",
  );
  expect(u?.spans).toEqual(["Promise.all", "Promise.allSettled"]);
  expect(u?.text).toBe("⟦0⟧과 ⟦1⟧ 차이를 알려줘. 코드와 파일은 빼고");
  expect(maskText("see ./src and ~/x, then . and .. alone")?.spans).toEqual([
    "./src",
    "~/x",
  ]);
});
