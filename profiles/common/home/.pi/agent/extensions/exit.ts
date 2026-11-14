/**
 * Add `/exit` as an alias of the built-in `/quit`.
 *
 * The built-in command is not renameable, so this registers a second name that
 * runs the same graceful shutdown: it waits for the agent to idle, then emits
 * `session_shutdown` before pi exits.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerCommand("exit", {
		description: "Quit Pi (same as /quit)",
		handler: async (_args, ctx) => {
			ctx.shutdown();
		},
	});
}
