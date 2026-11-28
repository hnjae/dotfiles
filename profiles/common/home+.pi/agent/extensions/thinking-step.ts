// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

/**
 * Step the thinking level with Shift+Up and Shift+Down.
 *
 * pi exposes only `app.thinking.cycle` (Shift+Tab), which wraps around at the
 * ends, and `keybindings.json` binds keys to existing action ids, so a
 * non-wrapping step has to be two registered shortcuts.
 *
 * The step walks the levels the active model offers, computed with the rule the
 * built-in picker uses (see `thinkingLevelMap` in models.md): a `null` mapping
 * hides a level, `xhigh` and `max` exist only when the model maps them to a
 * provider value, and a non-reasoning model has nothing but `off`. Because a
 * hidden level is never requested, the last press at either end clamps instead
 * of landing on a level pi would have to move back up from.
 */
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const LEVELS = [
  "off",
  "minimal",
  "low",
  "medium",
  "high",
  "xhigh",
  "max",
] as const;
type Level = (typeof LEVELS)[number];

/** The parts of the active model the level list depends on. */
type ModelFacts = ExtensionContext["model"];

type Shortcut = Parameters<ExtensionAPI["registerShortcut"]>[0];

function availableLevels(model: ModelFacts): Level[] {
  if (!model?.reasoning) return ["off"];
  return LEVELS.filter((level) => {
    const mapped = model.thinkingLevelMap?.[level];
    if (mapped === null) return false;
    if (level === "xhigh" || level === "max") return mapped !== undefined;
    return true;
  });
}

function step(model: ModelFacts, current: Level, delta: 1 | -1): Level {
  const levels = availableLevels(model);
  const index = levels.indexOf(current);
  if (index === -1) return levels[0] ?? "off";
  const target = Math.min(Math.max(index + delta, 0), levels.length - 1);
  return levels[target] ?? "off";
}

export default function (pi: ExtensionAPI) {
  const register = (
    key: Shortcut,
    delta: 1 | -1,
    description: string,
    end: string,
  ) => {
    pi.registerShortcut(key, {
      description,
      handler: async (ctx) => {
        const current = pi.getThinkingLevel();
        const target = step(ctx.model, current, delta);
        if (target !== current) {
          pi.setThinkingLevel(target);
          return;
        }
        ctx.ui.notify(`Thinking level is already ${current} (${end})`, "info");
      },
    });
  };

  register("shift+up", 1, "Raise thinking level", "highest");
  register("shift+down", -1, "Lower thinking level", "lowest");
}
