// omp-only hook: discovered through ~/.omp/agent/hooks/pre, which links to
// this directory. Other harnesses ignore hooks/omp.
import { existsSync } from "node:fs";
import { dirname, join } from "node:path";
import type { HookAPI } from "@oh-my-pi/pi-coding-agent/extensibility/hooks";

const HINT_TYPE = "omp.git-commit-hint";

function isGitWorkTree(dir: string): boolean {
	for (let current = dir; ; current = dirname(current)) {
		// Works for both a .git directory and a worktree/submodule .git file.
		if (existsSync(join(current, ".git"))) return true;
		if (current === dirname(current)) return false;
	}
}

export default function (pi: HookAPI): void {
	pi.on("session_start", async (_event, ctx) => {
		if (ctx.agent?.kind !== "main") return;
		if (!isGitWorkTree(ctx.cwd)) return;

		const alreadyInjected = ctx.sessionManager
			.getBranch()
			.some(
				(entry) =>
					entry.type === "custom_message" && entry.customType === HINT_TYPE,
			);
		if (alreadyInjected) return;

		pi.sendMessage({
			customType: HINT_TYPE,
			content:
				"This is a Git repository. Use the `git-commit` skill (read skill://git-commit) whenever you create a commit.",
			display: false,
		});
	});
}
