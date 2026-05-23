-- Resolve upstream LazyVim v15 which-key health false positives without changing key behavior.
-- The filtered mappings are still active in Neovim; they are only hidden from which-key's tree.
-- • 여기서 filtered mappings는 “실제 Neovim keymap을 삭제하거나 비활성화한 것”이 아니라, which-key가 자기 목록/tree에 넣지 않도록 걸러낸 keymap이라는 뜻입니다. <gpt 5.5; 2026-05-23>

---@type LazySpec
return {
  [1] = "which-key.nvim",
  optional = true,
  opts = function(_, opts)
    local previous_filter = opts.filter

    opts.filter = function(mapping)
      if previous_filter and not previous_filter(mapping) then
        return false
      end

      local lhs = mapping.lhs
      local mode = mapping.mode
      local desc = type(mapping.desc) == "string" and mapping.desc or nil

      if not lhs or not mode then
        return true
      end

      local key = table.concat(require("which-key.util").keys(lhs, { norm = true }))

      -- Snacks dashboard buffer-local actions intentionally use short single keys.
      if desc == "Dashboard action" then
        return false
      end

      -- LazyVim v15 adds <leader>gd for Snacks git diff, while this config uses
      -- <leader>gd* for Diffview. Keep both mappings, but let Diffview own the
      -- which-key group to avoid the overlap warning.
      if mode == "n" and key == "<Space>gd" and desc == "Git Diff (hunks)" then
        return false
      end

      -- Operator/textobject prefixes below are valid mappings, but which-key
      -- health reports them as overlaps when child mappings exist.
      if mode == "n" then
        if desc == "Yank Text" then
          return false
        end
        if key == "ys" or key == "yS" or key == "gc" then
          return false
        end
      elseif mode == "x" or mode == "o" then
        if
          (key == "a" and (desc == "around" or desc == "Around textobject"))
          or (key == "i" and (desc == "inside" or desc == "Inside textobject"))
        then
          return false
        end
      end

      return true
    end
  end,
}
