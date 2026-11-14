/**
 * Hold a logind sleep inhibitor while a pi run is working.
 *
 * Two ways to take the lock:
 *
 * 1. A D-Bus binding, when one is loadable. `org.freedesktop.login1.Manager.Inhibit`
 *    answers with a file descriptor that holds the lock until it is closed, so the
 *    binding must be able to receive a unix fd. The probe is a real Inhibit call:
 *    a binding that cannot pass fds loads fine and then never answers.
 * 2. Otherwise a `systemd-inhibit` child process, which is that same call behind a
 *    CLI. It runs `cat` against a pipe this process keeps open, so the lock also
 *    drops when pi dies without running its release path.
 *
 * (1) is UNVERIFIED against a real fd-capable binding: none was available where this
 * was written. dbus-next 0.10.2 under Bun never answers `Inhibit`, because receiving
 * the fd needs its `usocket` native addon, which Bun blocks and does not build. The
 * branch was exercised with a stub module only, so the path that runs in practice is
 * (2). Drop this note once a real binding confirms it.
 *
 * `--what=sleep` and not `idle`: idle inhibition would also stop the screen from
 * blanking, and a blanking screen is fine while a run works.
 *
 * The lock follows `agent_start` … `agent_settled`, not one turn: retries, queued
 * follow-ups and in-process subagents keep pi busy across a settle, and
 * `ctx.isIdle()` is what tells those cases apart.
 */
import { closeSync } from "node:fs";
import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const WHO = "pi";
const WHY = "pi is working";
const WHAT = "sleep";
const MODE = "block";
const BUS_NAME = "org.freedesktop.login1";
const BUS_PATH = "/org/freedesktop/login1";
const BUS_INTERFACE = "org.freedesktop.login1.Manager";
const PROBE_TIMEOUT_MS = 2_000;

/** A held lock. `release` must be safe to call more than once. */
type Inhibitor = { release(): void };

/** The part of dbus-next this extension uses. */
type DbusBus = {
	getProxyObject(
		name: string,
		path: string,
	): Promise<{ getInterface(name: string): unknown }>;
	disconnect(): void;
};

type Login1Manager = {
	Inhibit(
		what: string,
		who: string,
		why: string,
		mode: string,
	): Promise<unknown>;
};

type DbusBinding = { bus: DbusBus; manager: Login1Manager };

function isDesktopSession(): boolean {
	if (!process.env.XDG_SESSION_TYPE) return false;
	return Boolean(process.env.DBUS_SESSION_BUS_ADDRESS);
}

function withTimeout<T>(promise: Promise<T>, ms: number): Promise<T> {
	return Promise.race([
		promise,
		new Promise<never>((_resolve, reject) => {
			// unref: a stuck binding must not hold the event loop open.
			setTimeout(() => reject(new Error(`no answer in ${ms} ms`)), ms).unref();
		}),
	]);
}

/** Close whatever the binding handed back for the `h` return value. */
function releaseHandle(handle: unknown): void {
	const closeFd = (fd: number) => {
		try {
			closeSync(fd);
		} catch {
			// Already closed; the lock it held is gone either way.
		}
	};

	if (typeof handle === "number") {
		closeFd(handle);
		return;
	}
	if (handle && typeof handle === "object") {
		const { fd, destroy, close } = handle as {
			fd?: unknown;
			destroy?: () => void;
			close?: () => void;
		};
		if (typeof fd === "number") closeFd(fd);
		else if (typeof destroy === "function") destroy();
		else if (typeof close === "function") close();
	}
}

/**
 * Load a D-Bus binding and prove it can hold the lock, or report that none is
 * usable. Runs once per extension instance: the failed probe is the answer.
 *
 * UNVERIFIED end to end: see the note in the file header. A stub `dbus-next`
 * module proved the wiring — probe, per-run `Inhibit`, release, `disconnect` —
 * but no real binding has answered with an fd here.
 */
async function openDbusBinding(): Promise<DbusBinding | null> {
	try {
		const loaded = (await import("dbus-next")) as {
			default?: { systemBus?: () => DbusBus };
			systemBus?: () => DbusBus;
		};
		const dbus = loaded.default ?? loaded;
		if (typeof dbus.systemBus !== "function") return null;

		const bus = dbus.systemBus();
		const proxy = await bus.getProxyObject(BUS_NAME, BUS_PATH);
		const manager = proxy.getInterface(BUS_INTERFACE) as Login1Manager;
		if (typeof manager.Inhibit !== "function") {
			bus.disconnect();
			return null;
		}

		releaseHandle(
			await withTimeout(
				manager.Inhibit(WHAT, WHO, WHY, MODE),
				PROBE_TIMEOUT_MS,
			),
		);
		return { bus, manager };
	} catch {
		return null;
	}
}

async function acquireThrough(binding: DbusBinding): Promise<Inhibitor | null> {
	try {
		const handle = await withTimeout(
			binding.manager.Inhibit(WHAT, WHO, WHY, MODE),
			PROBE_TIMEOUT_MS,
		);
		let released = false;
		return {
			release() {
				if (released) return;
				released = true;
				releaseHandle(handle);
			},
		};
	} catch {
		return null;
	}
}

/**
 * `detached` puts the child in its own process group, so releasing can kill
 * `systemd-inhibit` and the `cat` it runs in one signal. The open stdin is the
 * guard for a pi that dies without releasing: EOF ends `cat`, and the lock drops.
 */
function acquireThroughChild(): Inhibitor | null {
	const child = spawn(
		"systemd-inhibit",
		[`--what=${WHAT}`, `--who=${WHO}`, `--why=${WHY}`, `--mode=${MODE}`, "cat"],
		{ detached: true, stdio: ["pipe", "ignore", "ignore"] },
	);

	let released = false;
	return {
		release() {
			if (released) return;
			released = true;
			child.stdin?.end();
			if (child.pid === undefined) return;
			try {
				process.kill(-child.pid, "SIGTERM");
			} catch {
				// Already gone; the EOF above covered the lock.
			}
		},
	};
}

export default function (pi: ExtensionAPI) {
	if (!isDesktopSession()) return;

	let held: Inhibitor | null = null;
	let binding: DbusBinding | null | undefined;
	let unavailable = false;

	async function acquire(): Promise<void> {
		if (held || unavailable) return;

		if (binding === undefined) binding = await openDbusBinding();
		held =
			(binding && (await acquireThrough(binding))) ?? acquireThroughChild();

		if (!held) {
			// No path works on this machine; one report per session, not per run.
			unavailable = true;
			console.warn(`wakelock: no usable sleep inhibitor (${WHY})`);
		}
	}

	function release(): void {
		held?.release();
		held = null;
	}

	pi.on("agent_start", async () => {
		await acquire();
	});

	pi.on("agent_settled", async (_event, ctx) => {
		if (ctx.isIdle()) release();
	});

	pi.on("session_shutdown", async () => {
		release();
		binding?.bus.disconnect();
		binding = undefined;
	});
}
