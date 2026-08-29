---
name: link-html-clipper
description: Create polished standalone HTML+CSS clipping files from source URLs, social posts, article excerpts, threads, or user-pasted text. Use when Codex should turn a link or pasted thread into a clean Obsidian-ready HTML file, preserve source URL/author/datetime metadata, support dark and light modes, query the source directly when available, and ask the user for pasted content when the source cannot be fetched reliably.
---

# Link HTML Clipper

## Overview

Create a self-contained HTML document that preserves a source link and its visible metadata while making the content pleasant to read in Obsidian or a browser. Prefer HTML+CSS only; do not add JavaScript unless the user explicitly asks for behavior that requires it.

Use `assets/obsidian-source-clip-template.html` as the starting point when a styled standalone page is requested.

The default visual language should follow Obsidian Minimal with the Flexoki palette: warm paper/ink neutrals, restrained borders, low shadow, no decorative gradients, and cyan links/active accents. Use Flexoki base values for text, backgrounds, and interface lines; use `cyan-600` in light mode and `cyan-400` in dark mode for links and active markers.

## Workflow

1. Gather source material.
   - If the user provides a URL, try to query or fetch the source first using available browsing, search, connector, or local fetch tools.
   - If the source page is inaccessible, requires authentication, is mostly client-rendered, is rate-limited, or cannot be trusted from the fetched result, ask the user to paste the content.
   - Do not invent missing post bodies, author names, timestamps, or reply order. Mark uncertain metadata as unknown or ask for it.
   - If the user already pasted the content, use it as the authoritative body text unless they ask for verification.

2. Preserve metadata.
   - Show the source URL visibly near the top and keep it as an `href`.
   - Show author display name and handle/user ID when known.
   - Use a semantic `<time datetime="...">visible time</time>` element when datetime is known.
   - For HTML+CSS-only output, render datetime as static text. HTML and CSS cannot locale-format timestamps.
   - Use the user's requested timezone for visible datetime. If unspecified, prefer the user's environment timezone when known; otherwise use the source timezone or UTC.
   - Keep machine-readable datetime in ISO 8601. For visible `+0900` timestamps, use a display such as `2026-03-16 13:22:56.375 +0900` and a `datetime` value such as `2026-03-16T13:22:56.375+09:00`.

3. Handle X/Twitter links.
   - If an X/Twitter status ID is available, derive the post creation timestamp from the Snowflake ID when the exact page metadata is unavailable:
        - `timestamp_ms = (status_id >> 22) + 1288834974657`
        - UTC datetime is `new Date(timestamp_ms).toISOString()`.
   - This derives creation time only. It does not provide post text, author display name, or reply contents.

4. Shape the document.
   - Keep the source text faithful. Lightly segment, title, and label sections, but do not summarize away details unless the user asks for a summary.
   - For threads, treat the first post as primary and subsequent posts as replies in sequence. If the user says replies are siblings, avoid implying nested reply hierarchy.
   - Add a short subtitle and 2-4 key-point cards only when they improve scanning.
   - Put reference links in a final section when the source text contains them.

5. Write the output file.
   - Create one standalone `.html` file in the current working directory unless the user specifies a path.
   - Name the file from the source's written or published date, title, and author using `YYYYMMDD Title — Author.html` (for example, `20260516 Example Title — Jane Doe.html`).
   - Use the source creation/publication date for `YYYYMMDD`, not the clipping date. If the written date cannot be established from the source or user-provided content, ask the user for it before writing the file; do not invent or substitute today's date.
   - If the title or author is unknown, ask the user when practical. If the user asks to proceed anyway, use `Untitled` or `Unknown Author` for the missing segment.
   - Sanitize filename segments only as needed for filesystem safety: remove path separators and control characters, collapse whitespace, and trim surrounding spaces. Keep the title and author readable; do not force lowercase.
   - Scope styles under a root class such as `.source-clip` to make clipping safer.
   - Include embedded CSS only. Avoid external fonts, libraries, images, and scripts by default.
   - Support dark/light mode with both `@media (prefers-color-scheme: dark)` and Obsidian-style `.theme-dark` / `.theme-light` selectors.

6. Verify before finishing.
   - Search the file for the source URL, author metadata, datetime, and absence of `<script>` when HTML+CSS-only was requested.
   - Check that the file is self-contained and that links are preserved.
   - Mention any metadata that could not be queried and had to come from the user.

## Template Notes

Use the template placeholders directly or rewrite the markup to better fit the content:

- `{{TITLE}}`
- `{{SUBTITLE}}`
- `{{SOURCE_BADGE}}`
- `{{AUTHOR}}`
- `{{DATETIME_ISO}}`
- `{{DATETIME_DISPLAY}}`
- `{{SOURCE_URL}}`
- `{{KEY_POINTS}}`
- `{{CONTENT_BLOCKS}}`
- `{{FOOTER_NOTE}}`

Delete unused sections rather than leaving empty placeholders.
