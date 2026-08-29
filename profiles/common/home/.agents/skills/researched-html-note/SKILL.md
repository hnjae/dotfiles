---
name: researched-html-note
description: Create polished Korean standalone HTML notes from researched material for Obsidian. Use when Codex should investigate a topic, compare sources, summarize conventions or technical guidance, preserve source links, and write a self-contained .html file with embedded CSS for reading in a browser or Obsidian.
---

# Researched HTML Note

## Overview

Produce a Korean, source-backed standalone HTML note from research. This skill is for explanatory notes, technical convention summaries, decision memos, and compact reference pages that need both readable prose and visible source attribution in an Obsidian-friendly HTML file.

Use `assets/researched-note-template.html` as the starting point unless the target repository already has a stronger local template.

## Workflow

1. Define the note scope.
   - Infer a concise title from the user request.
   - If the request is too broad for one useful note, choose the narrowest practical scope and state that assumption while working.
   - Write the output file in the current working directory unless the user specifies a path.
   - Name the file in readable kebab-case or the exact filename requested by the user.
   - Default the note language to Korean for research-note requests unless the user explicitly asks for another language.

2. Research before writing.
   - Use web browsing when the topic depends on current facts, official rules, product behavior, recent ecosystem convention, or precise source attribution.
   - Prefer primary sources: official docs, source repositories, standards, manuals, release notes, and project-maintained guides.
   - Use secondary sources only to clarify ecosystem practice, and label inference as inference.
   - Do not invent missing facts. If sources disagree, describe the disagreement and favor the more authoritative or more recent source.

3. Preserve source attribution.
   - Include a visible source row or references section with links to every material source used.
   - Prefer a dedicated `참고 자료` section when there is more than one source; the header's primary-source link is not enough by itself.
   - Include access or writing date when useful for time-sensitive topics.
   - Do not quote long passages. Use short excerpts only when the exact wording matters; otherwise paraphrase.
   - Keep claims close to their source in prose when the claim is specific or potentially contentious.

4. Shape the document.
   - Start with the answer or practical conclusion.
   - Add 3-5 key-point cards when they improve scanning.
   - Organize body sections around decisions a reader needs to make, not around the order sources were found.
   - Include code blocks, examples, tables, or decision matrices when they make the note more actionable.
   - For coding conventions, distinguish language syntax, project convention, ecosystem habit, and external-system names.

5. Style and implementation.
   - Create one standalone `.html` file with embedded CSS only.
   - Support light and dark mode through both `@media (prefers-color-scheme: dark)` and `.theme-dark` / `.theme-light` selectors.
   - Use restrained Obsidian/Flexoki-like styling: warm paper/ink neutrals, thin borders, low shadow, cyan links.
   - Do not add external fonts, external CSS, images, or scripts unless the user explicitly asks.
   - Scope page styles under `.source-clip` or another root class.

6. Verify before finishing.
   - Search the file for leftover template placeholders such as `{{`.
   - Confirm the requested output filename exists.
   - Confirm important source URLs are present.
   - Confirm there is no `<script>` tag unless JavaScript was requested.
   - Mention if any requested research could not be verified.

## Output Conventions

- Use Korean by default for researched HTML notes, unless the requested artifact should be in another language.
- Keep generated prose concise and direct. The HTML should read as a polished note, not a marketing page.
- If the user asks to disclose model or tool provenance, place it in the header metadata or footer rather than inside the technical argument.
- If the user asks for an answer first and a file second, answer briefly in chat and still create the HTML file.

## Template Use

When using `assets/researched-note-template.html`:

- Replace `{{TITLE}}`, `{{SUBTITLE}}`, `{{AUTHOR}}`, `{{DATETIME_ISO}}`, `{{DATETIME_DISPLAY}}`, `{{SOURCE_URL}}`, `{{KEY_POINTS}}`, `{{CONTENT_BLOCKS}}`, and `{{FOOTER_NOTE}}`.
- Delete unused sections instead of leaving empty placeholders.
- Add or remove section blocks freely, but keep the embedded CSS self-contained.
