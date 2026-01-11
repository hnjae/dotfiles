config.colors = {
  tab_bar = {
    -- 탭 바 배경색
    background = "#333333",

    -- 활성 탭
    active_tab = {
      bg_color = "#000000",
      fg_color = "#c0c0c0",
      intensity = "Normal",
      underline = "None",
      italic = false,
      strikethrough = false,
    },

    -- 비활성 탭
    inactive_tab = {
      bg_color = "#333333",
      fg_color = "#808080",
    },

    -- 비활성 탭 (마우스 호버)
    inactive_tab_hover = {
      bg_color = "#1f1f1f",
      fg_color = "#909090",
      italic = true,
    },

    -- 새 탭 버튼 (inactive_tab과 동일)
    new_tab = {
      bg_color = "#333333",
      fg_color = "#808080",
    },

    -- 새 탭 버튼 (마우스 호버, inactive_tab_hover와 동일)
    new_tab_hover = {
      bg_color = "#1f1f1f",
      fg_color = "#909090",
      italic = true,
    },

    -- 비활성 탭 테두리
    inactive_tab_edge = "#575757",

    -- 비활성 탭 테두리 (마우스 호버)
    inactive_tab_edge_hover = "#363636",
  },
}
