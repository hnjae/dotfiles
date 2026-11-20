// Call cc-safety-net's command API for maki.
//
// Usage: node check.mjs <api.js> <json>
// json: { "commands": [{ "command": "...", "cwd": "/abs/path" }] }
//
// Prints one JSON decision and exits 0: the first deny, or {kind:"allow"}.
// The Lua plugin treats an error decision according to its fail mode.

import { pathToFileURL } from "node:url";

const apiPath = process.argv[2];

try {
	const payload = JSON.parse(process.argv[3]);
	const { checkCommand } = await import(pathToFileURL(apiPath).href);
	let decision = { kind: "allow" };
	for (const item of payload.commands) {
		const result = checkCommand({ command: item.command, cwd: item.cwd });
		if (result.kind === "deny") {
			decision = result;
			break;
		}
	}
	process.stdout.write(JSON.stringify(decision));
} catch (error) {
	process.stdout.write(
		JSON.stringify({ kind: "error", reason: String(error) }),
	);
}
