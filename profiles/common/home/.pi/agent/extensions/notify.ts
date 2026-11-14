/**
 * Tell the user, away from the screen, when a run needs them.
 *
 * Three moments: the run settled, pi is blocked on a UI prompt, or the run
 * ended on a provider error. Everything else (aborts, mid-run turns, retries)
 * stays silent — pi is either still working or the user just pressed Escape.
 *
 * A host that renders its own status while pi runs gets nothing at all:
 * `T3_MCP_URL`/`T3_PI_RUNTIME_MODE` (t3code) and `HERDR_ENV`/`HC_TERMINAL_ID`
 * (herdr, legacy and app) already show the run, so a second desktop popup is
 * noise from a window the user is not in.
 *
 * Channel, per the original requirement plus the OSC 777 case:
 * 1. Desktop session → `org.freedesktop.Notifications` on the session bus.
 * 2. That binding is unusable → `notify-send`, which is the same call behind a
 *    CLI. Both are D-Bus clients; this is a fallback for the binding, not for
 *    the bus. A machine with no session bus simply reports failure twice.
 * 3. No desktop, but an interactive TUI → OSC 777, which the terminal emulator
 *    turns into its own notification. Nothing is written in print/JSON/RPC
 *    mode: no terminal to write to, or a host already reading the stream.
 */
import { execFile } from "node:child_process";
import type { ClientInterface } from "dbus-next";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const APP_NAME = "Pi";
const BUS_NAME = "org.freedesktop.Notifications";
const BUS_PATH = "/org/freedesktop/Notifications";
const BUS_INTERFACE = "org.freedesktop.Notifications";

/** A stuck daemon must not hold the settle handler, which runs once per run. */
const SEND_TIMEOUT_MS = 3_000;

/** `normal`/`critical` as the spec's urgency hint byte. */
const URGENCY_NORMAL = 1;
const URGENCY_CRITICAL = 2;

/** `expireTimeout` in ms; 0 means the daemon keeps it until dismissed. */
const DONE_TIMEOUT_MS = 4_000;
/** 0, because the outcome notification replaces this one by id. */
const WAITING_TIMEOUT_MS = 0;
const ERROR_TIMEOUT_MS = -1;

type Channel = "dbus" | "cli" | "osc777" | null;

type Outcome = {
	readonly summary: string;
	readonly body: string;
	readonly urgency: number;
	readonly expireTimeoutMs: number;
	readonly icon: string;
};

/** The parts of dbus-next's shape this extension calls, with real types. */
type DbusModule = typeof import("dbus-next");

/**
 * A D-Bus client interface is typed as `Function` per member, so the one method
 * we call gets its own signature. The process sits outside a bus connection.
 */
type Notifications = ClientInterface & {
	Notify(
		appName: string,
		replacesId: number,
		appIcon: string,
		summary: string,
		body: string,
		actions: string[],
		hints: Record<string, unknown>,
		expireTimeout: number,
	): Promise<number>;
};

type Env = Record<string, string | undefined>;

function isHostedElsewhere(env: Env): boolean {
	return Boolean(
		env.T3_MCP_URL ||
			env.T3_PI_RUNTIME_MODE ||
			env.HERDR_ENV ||
			env.HC_TERMINAL_ID,
	);
}

/**
 * Same test `wakelock.ts` uses: a session type plus a session bus address. Over
 * ssh neither is set, even when the machine has a running desktop.
 */
function isDesktopSession(env: Env): boolean {
	return Boolean(env.XDG_SESSION_TYPE) && Boolean(env.DBUS_SESSION_BUS_ADDRESS);
}

function pickChannel(env: Env, mode: string, hasTty: boolean): Channel {
	if (isHostedElsewhere(env)) return null;
	if (isDesktopSession(env)) return "dbus";
	if (mode === "tui" && hasTty) return "osc777";
	return null;
}

function withTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
	return Promise.race([
		promise,
		new Promise<never>((_resolve, reject) => {
			// unref: a stuck daemon must not hold the event loop open.
			setTimeout(() => reject(new Error(`no answer in ${ms} ms`)), ms).unref();
		}),
	]);
}

/** A summary that says which session and where, for a user with several open. */
function titleFor(ctx: {
	cwd: string;
	sessionManager: { getSessionName(): string | null | undefined };
}): string {
	const name = ctx.sessionManager.getSessionName()?.trim();
	const dir = ctx.cwd.split("/").filter(Boolean).pop() ?? "/";
	return `${APP_NAME} · ${name || dir}`;
}

function shorten(text: string, limit = 180): string {
	const flat = text.replace(/\s+/g, " ").trim();
	return flat.length > limit ? `${flat.slice(0, limit - 1)}…` : flat;
}

function formatDuration(ms: number): string {
	const seconds = Math.max(1, Math.round(ms / 1000));
	if (seconds < 60) return `${seconds}s`;
	const minutes = Math.floor(seconds / 60);
	const rest = seconds % 60;
	return rest === 0 ? `${minutes}m` : `${minutes}m ${rest}s`;
}

/**
 * The last assistant message decides the run: pi's own retry loop starts a new
 * run, and `agent_start` clears this, so a recovered run settles as a success.
 */
function findRunError(messages: readonly unknown[]): string | null {
	for (let index = messages.length - 1; index >= 0; index -= 1) {
		const message = messages[index] as {
			role?: string;
			stopReason?: string;
			errorMessage?: string;
		};
		if (message?.role !== "assistant") continue;
		if (message.stopReason !== "error") return null;
		return shorten(message.errorMessage || "provider error");
	}
	return null;
}

async function sendThroughDbus(
	outcome: Outcome,
	replacesId: number,
): Promise<number | null> {
	try {
		// Static import so the module is only loaded when a desktop session
		// actually notifies. `default` is the CJS namespace under bun.
		const loaded = (await import("dbus-next")) as DbusModule & {
			default?: DbusModule;
		};
		const dbus = loaded.default ?? loaded;
		if (typeof dbus.sessionBus !== "function") return null;

		const bus = dbus.sessionBus();
		try {
			// Introspection is a second round trip, and a bus without a notification
			// daemon is the common case on a headless box: bound it too.
			const proxy = await withTimeout(
				bus.getProxyObject(BUS_NAME, BUS_PATH),
				SEND_TIMEOUT_MS,
			);
			const notifications = proxy.getInterface<Notifications>(BUS_INTERFACE);
			if (typeof notifications.Notify !== "function") return null;

			// `y` is the wire signature for a byte. dbus-next keeps an unknown
			// name like "byte" in the Variant but marshals it as a boolean, so the
			// long name would silently change the hint's type on the wire.
			const hints = { urgency: new dbus.Variant("y", outcome.urgency) };

			const id = await withTimeout(
				notifications.Notify(
					APP_NAME,
					replacesId,
					outcome.icon,
					outcome.summary,
					outcome.body,
					[],
					hints,
					outcome.expireTimeoutMs,
				),
				SEND_TIMEOUT_MS,
			);
			return typeof id === "number" ? id : 0;
		} finally {
			bus.disconnect();
		}
	} catch {
		return null;
	}
}

/**
 * `-r` only replaces a notification this app created, and only when we know its
 * id, which is why the id from the D-Bus path is carried over.
 */
function sendThroughCli(outcome: Outcome, replacesId: number): Promise<void> {
	const args = [
		`--app-name=${APP_NAME}`,
		`--urgency=${outcome.urgency === URGENCY_CRITICAL ? "critical" : "normal"}`,
	];
	// `-1` is the server default; `notify-send` has no way to spell it, so omit
	// the flag rather than turn it into `0`, which means "never expire".
	if (outcome.expireTimeoutMs >= 0) {
		args.push(`--expire-time=${outcome.expireTimeoutMs}`);
	}
	if (outcome.icon) args.push(`--icon=${outcome.icon}`);
	if (replacesId > 0) args.push(`--replace-id=${replacesId}`);
	args.push(outcome.summary, outcome.body);

	return new Promise((resolve) => {
		execFile("notify-send", args, { timeout: SEND_TIMEOUT_MS }, () =>
			resolve(),
		);
	});
}

/**
 * OSC 777 is `notify;title;body`, so a `;` in either field would shift the
 * body into the title, and a stray BEL or ESC would end the sequence early.
 */
function oscField(text: string): string {
	return Array.from(text, (char) => {
		const code = char.codePointAt(0) ?? 0;
		if (code < 0x20 || code === 0x7f) return " ";
		return char === ";" ? ":" : char;
	}).join("");
}

function sendThroughTerminal(outcome: Outcome): void {
	// OSC 777: Ghostty, WezTerm, iTerm2, rxvt-unicode. The terminal consumes it,
	// so it never lands in the rendered frame. A closed stdout (piped, or a
	// terminal that went away) must not fail the settle handler.
	try {
		process.stdout.write(
			`\x1b]777;notify;${oscField(outcome.summary)};${oscField(outcome.body)}\x07`,
		);
	} catch {
		// Nothing to notify on any more.
	}
}

export default function (pi: ExtensionAPI) {
	// Resolved per notification: `process.env` is static, the TTY answer too.
	const channelFor = (mode: string) =>
		pickChannel(process.env, mode, Boolean(process.stdout.isTTY));

	// A host that owns the notification surface gets nothing, desktop or not:
	// t3code and herdr already show the run to the user.
	if (isHostedElsewhere(process.env)) return;

	let startedAt: number | null = null;
	let runError: string | null = null;
	/** Id of the last notification, so "waiting" is replaced by its outcome. */
	let replacesId = 0;

	async function send(outcome: Outcome, mode: string): Promise<void> {
		const target = channelFor(mode);
		if (!target) return;

		if (target === "osc777") {
			sendThroughTerminal(outcome);
			return;
		}

		const id = await sendThroughDbus(outcome, replacesId);
		if (id !== null) {
			replacesId = id;
			return;
		}
		await sendThroughCli(outcome, replacesId);
		// `notify-send` does not report the id, so the next notification cannot
		// replace this one.
		replacesId = 0;
	}

	pi.on("agent_start", async () => {
		if (startedAt === null) startedAt = Date.now();
		runError = null;
	});

	pi.on("agent_end", async (event) => {
		runError = findRunError(event.messages as readonly unknown[]);
	});

	pi.on("agent_settled", async (event, ctx) => {
		const elapsed =
			startedAt === null ? null : formatDuration(Date.now() - startedAt);
		startedAt = null;

		if (event.aborted) {
			// Escape means the user is looking at the screen; no popup.
			runError = null;
			return;
		}

		const summary = titleFor(ctx);
		if (runError) {
			await send(
				{
					summary,
					body: `Error: ${runError}`,
					urgency: URGENCY_CRITICAL,
					expireTimeoutMs: ERROR_TIMEOUT_MS,
					icon: "dialog-error",
				},
				ctx.mode,
			);
			runError = null;
			return;
		}

		await send(
			{
				summary,
				body: elapsed ? `Finished in ${elapsed}` : "Finished",
				urgency: URGENCY_NORMAL,
				expireTimeoutMs: DONE_TIMEOUT_MS,
				icon: "",
			},
			ctx.mode,
		);
	});

	pi.on("ui_prompt_start", async (event, ctx) => {
		// Prompt spans are coalesced, so one notification per outer span.
		if (channelFor(ctx.mode) === null) return;
		const detail = event.title ? ` — ${shorten(event.title, 120)}` : "";
		await send(
			{
				summary: titleFor(ctx),
				body: `Waiting for input (${event.kind})${detail}`,
				urgency: URGENCY_NORMAL,
				expireTimeoutMs: WAITING_TIMEOUT_MS,
				icon: "dialog-question",
			},
			ctx.mode,
		);
	});
}
