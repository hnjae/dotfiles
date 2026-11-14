/**
 * Redact known secret values from every tool result before the model sees them.
 *
 * Values are captured once, when the extension loads, from Pi's own environment.
 * Start Pi with the variables set; do not change them mid-session.
 *
 * Skips values shorter than MIN_LENGTH to avoid masking ordinary text, and
 * allowlists names that match the pattern but carry no secret.
 *
 * Limits: encoded output (base64, hex) is not covered, and values created after
 * startup are unknown to this extension.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const SECRET_NAME =
  /(?:^|_)(?:KEY|KEYS|TOKEN|TOKENS|SECRET|SECRETS|PASSWORD|PASSWD|CREDENTIAL|CREDENTIALS)(?:_|$)/i;

const ALLOW = new Set(["LESSKEYIN_SYSTEM", "XDG_ACTIVATION_TOKEN"]);

const MIN_LENGTH = 8;

type Secret = { readonly name: string; readonly value: string };

function collectSecrets(env: Record<string, string | undefined>): Secret[] {
  return Object.entries(env)
    .filter(
      (entry): entry is [string, string] =>
        typeof entry[1] === "string" &&
        entry[1].length >= MIN_LENGTH &&
        SECRET_NAME.test(entry[0]) &&
        !ALLOW.has(entry[0]),
    )
    .map(([name, value]) => ({ name, value }))
    .sort((a, b) => b.value.length - a.value.length);
}

function redact(text: string, secrets: readonly Secret[]): string {
  let result = text;
  for (const secret of secrets) {
    if (result.includes(secret.value)) {
      result = result.replaceAll(secret.value, `[REDACTED:${secret.name}]`);
    }
  }
  return result;
}

export default function (pi: ExtensionAPI) {
  const secrets = collectSecrets(process.env);
  if (secrets.length === 0) return;

  pi.on("tool_result", async (event) => {
    let changed = false;
    const content = event.content.map((item) => {
      if (item.type !== "text" || typeof item.text !== "string") return item;
      const text = redact(item.text, secrets);
      if (text === item.text) return item;
      changed = true;
      return { ...item, text };
    });
    return changed ? { content } : undefined;
  });
}
