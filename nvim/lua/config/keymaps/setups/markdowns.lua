-- WIP

local A = {}

A.adjust = function()
  local bufid = vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufid, "markdown", {})
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()

  if node == nil then
    vim.notify("No Treesitter node found at cursor.", "warn")
    return
  end

  -- local a = parser:parse(range)
  -- vim.notify(vim.inspect(a))
end
-- Place this function definition in your Neovim configuration
-- e.g., in init.lua or a separate lua file that gets required.

local M = {} -- Create a module table (good practice)

--- Adjusts the level of the Markdown ATX heading the cursor is currently within.
---
---@param delta integer The change in heading level (+1 to increase, -1 to decrease).
function M.adjust_markdown_heading(delta)
  -- Ensure Treesitter is available and the markdown parser is active for the buffer
  local ts_utils = require("nvim-treesitter.ts_utils")
  local parser = vim.treesitter.get_parser(0, "markdown") -- 0 for current buffer
  if not parser then
    print("Treesitter markdown parser not active for this buffer.")
    return
  end

  -- 1. Get current cursor position (1-based row, 0-based column)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1] -- 1-based
  local original_col = cursor_pos[2] -- 0-based

  -- NOTE: 이걸로 찾으면 안되는디. <2025-04-25>
  -- 2. Find the Treesitter node at the cursor (using 0-based row)
  -- We look slightly around the cursor column too, as it might land between nodes sometimes
  local current_node = ts_utils.get_node_at_cursor() -- More robust way

  if not current_node then
    vim.notify("No Treesitter node found at cursor.", "warn")
    return
  end

  -- 3. Traverse up to find the containing ATX heading node
  local heading_node = nil
  local node_iter = current_node
  while node_iter do
    -- The specific node type for '# Heading' is usually 'atx_heading'.
    -- Check your specific treesitter parser if this differs.
    if node_iter:type() == "atx_heading" then
      heading_node = node_iter
      break
    end
    node_iter = node_iter:parent()
  end

  if not heading_node then
    print("Cursor is not inside an ATX heading (# Heading).")
    return
  end

  -- 4. Get heading line information
  -- ATX headings are single-line. range() gives 0-based indices.
  local start_row, _, end_row, _ = heading_node:range()
  -- Ensure the node we found actually contains the cursor's line
  -- (start_row is 0-based, row is 1-based)
  if row - 1 < start_row or row - 1 > end_row then
    print("Cursor line does not match heading node line.")
    return
  end

  local line_idx = start_row -- 0-based line index
  local lines = vim.api.nvim_buf_get_lines(0, line_idx, line_idx + 1, false)
  if not lines or #lines == 0 then
    print("Could not retrieve heading line text.")
    return
  end
  local line_text = lines[1]

  -- 5. Calculate current level and extract content
  -- Match pattern: ^(#+)%s+(.*) captures hashes and content after space
  -- Match pattern: ^(#+)%s*(.*) captures hashes and content after optional space
  local match = { string.match(line_text, "^(#+)%s*(.*)") }
  if not match or #match < 1 then
    print("Line does not look like a standard ATX heading.")
    return
  end

  local hashes = match[1] or ""
  local content = match[2] or "" -- Content might be empty
  local current_level = #hashes
  local old_prefix_len = #hashes + (string.match(line_text, "^#+%s") and 1 or 0) -- Length of '#'* + optional space

  -- 6. Calculate new level (clamped between 1 and 6)
  local new_level = math.max(1, math.min(6, current_level + delta))

  -- If level doesn't change, do nothing
  if new_level == current_level then
    -- print("Heading level already at limit (" .. new_level .. ").")
    return
  end

  -- 7. Construct the new line
  local new_hashes = string.rep("#", new_level)
  -- Preserve space only if content exists or if original had space after hashes
  local separator = (#content > 0 or string.match(line_text, "^#+%s")) and " " or ""
  local new_line_text = new_hashes .. separator .. content
  local new_prefix_len = #new_hashes + #separator

  -- 8. Replace the line in the buffer
  vim.api.nvim_buf_set_lines(0, line_idx, line_idx + 1, false, { new_line_text })

  -- 9. Restore cursor position
  -- Try to maintain the relative position within the content
  local new_col
  local col_change = new_prefix_len - old_prefix_len

  if original_col >= old_prefix_len then
    -- Cursor was in or after the content
    new_col = original_col + col_change
  else
    -- Cursor was within the prefix (# or space), place it at the start of the content
    new_col = new_prefix_len
  end
  -- Ensure column is not negative (although unlikely here)
  new_col = math.max(0, new_col)

  -- Set cursor (API uses 1-based row, 0-based column)
  vim.api.nvim_win_set_cursor(0, { row, new_col })

  -- Optional: print("Heading level changed to " .. new_level)
end

local B = {}

B.setup = function()
  -- Key Mappings

  -- Increase Heading level
  vim.keymap.set("n", "gru", function()
    M.adjust_markdown_heading(1)
  end, { noremap = true, silent = true, desc = "Markdown: Increase Heading Level" })

  -- Decrease Heading level
  vim.keymap.set("n", "grd", function()
    M.adjust_markdown_heading(-1)
  end, { noremap = true, silent = true, desc = "Markdown: Decrease Heading Level" })

  -- Example of requiring if you put the function in lua/utils/markdown.lua
  -- local markdown_utils = require("utils.markdown")
  -- vim.keymap.set('n', 'gih', function() markdown_utils.adjust_markdown_heading(1) end, { noremap = true, silent = true, desc = "Markdown: Increase Heading Level" })
  -- vim.keymap.set('n', 'gdh', function() markdown_utils.adjust_markdown_heading(-1) end, { noremap = true, silent = true, desc = "Markdown: Decrease Heading Level" })
end

return B
