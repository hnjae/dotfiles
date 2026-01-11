local wezterm = require("wezterm")
local M = {}

M.apply_to_config = function(config)
  config.window_padding = {
    left = "0.5cell",
    right = "0.5cell",
    top = "0.25cell",
    bottom = "0.25cell",
  }

  -- tabline 설정을 반환
  -- 기본 탭바 설정
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.show_new_tab_button_in_tab_bar = true
  config.tab_max_width = 32 -- default: 16 <2026-01-11>

  -- color retro tabbar
  config.colors = config.colors or {}
  config.colors.tab_bar = {}
  config.colors.tab_bar.background = "#333333"
  config.colors.tab_bar.active_tab = {
    bg_color = "#16161D",
    fg_color = "#F2ECBC",
    -- fg_color = "#E6C384",
    --     -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
    --     -- label shown for this tab.
    --     -- The default is "Normal"
    -- intensity = "Half",
    --
    --     -- Specify whether you want "None", "Single" or "Double" underline for
    --     -- label shown for this tab.
    --     -- The default is "None"
    --     underline = "None",
    --
    --     -- Specify whether you want the text to be italic (true) or not (false)
    --     -- for this tab.  The default is false.
    --     italic = false,
    --
    --     -- Specify whether you want the text to be rendered with strikethrough (true)
    --     -- or not for this tab.  The default is false.
    --     strikethrough = false,
  }
  -- config.colors.tab_bar.new_tab = config.colors.tab_bar.inactive_tab
  -- config.colors.tab_bar.new_tab_hover = config.colors.tab_bar.inactive_tab_hover

  -- update-status 이벤트: 좌우 상태바 설정
  wezterm.on("update-status", function(window, pane)
    -- if pane:pane_id() == 0 then
    --   return
    -- end

    -- if pane:is_alt_screen_active() then
    --   wezterm.log_info("Alt screen is active (vim, less, etc.)")
    -- end

    -- 현재 모드 가져오기
    -- local mode = window:active_key_table() or "normal_mode"
    -- local mode_color = colors.normal
    --
    -- -- 모드별 색상 변경
    -- if mode == "copy_mode" then
    --   mode_color = colors.copy
    -- elseif mode == "search_mode" then
    --   mode_color = colors.search
    -- end

    -- 왼쪽: workspace
    local workspace = wezterm.mux.get_active_workspace()
    -- 경로에서 마지막 부분만 추출
    -- workspace = string.match(workspace, "[^/\\]+$") or workspace

    window:set_left_status(wezterm.format({
      { Text = " " .. workspace .. " " },
    }))

    -- 오른쪽: domain

    local domain = pane:get_domain_name()
    window:set_right_status(wezterm.format({
      {
        Background = {
          Color = (domain ~= "local" and "#76946A" or config.colors.tab_bar.background),
        },
      },
      {
        Foreground = {
          Color = (domain ~= "local" and "#1F1F28" or "#dcd7ba"),
        },
      },
      { Text = " " .. domain .. " " },
    }))
  end)
end

return M
