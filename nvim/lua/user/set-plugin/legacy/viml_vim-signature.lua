-- help signature.txt
-- https://github.com/kshenoy/vim-signature

--[[
  이유는 모르지만 vim-commentary 와 gc 에서 mapping 이 충돌.
  vim-surrounded
--]]

if _IS_PLUGIN('vim-signature') then
  vim.g.SignatureMap = {
    -- ['Leader']            = "m",
    -- ['PlaceNextMark']     = "m,",
    -- ['ToggleMarkAtLine']  = "m.",
    -- ['PurgeMarksAtLine']  = "m-",
    -- ['PurgeMarks']        = "m<Space>",
    ['Leader']            = "m",
    ['PlaceNextMark']     = "",
    ['ToggleMarkAtLine']  = "",
    ['PurgeMarksAtLine']  = "",
    ['PurgeMarks']        = "",
    --
    ['PurgeMarkers']      = "",
    ['ListBufferMarks']   = "",
    ['ListBufferMarkers'] = "",
    ------
    ['DeleteMark']        = "",
    ------
    -- ['GotoNextLineAlpha']  =  "']",
    -- ['GotoPrevLineAlpha']  =  "'[",
    ['GotoNextLineAlpha'] = "", -- 기본 맵핑이 있음
    ['GotoPrevLineAlpha'] = "", -- 기본 맵핑이 있음
    ['GotoNextSpotAlpha'] = "", -- 기본 맵핑이 있음
    ['GotoPrevSpotAlpha'] = "", -- 기본 맵핑이 있음
    ------
    ['GotoNextLineByPos'] = "",
    ['GotoPrevLineByPos'] = "",
    ['GotoNextSpotByPos'] = "",
    ['GotoPrevSpotByPos'] = "",
    ['GotoNextMarker']    = "",
    ['GotoPrevMarker']    = "",
    ['GotoNextMarkerAny'] = "",
    ['GotoPrevMarkerAny'] = "",
  }

  local status_wk, wk = pcall(require, "which-key")
  if status_wk then
    wk.register({
      -- ["m,"] = { "place-next-mark" },
      -- ["m."] = { "toggle-mark-at-line" },
      -- ["m-"] = { "purge-marks-at-line" },
      -- ["m "] = { "purge-marks-at-buffer" },
      -- ["m/"] = { "list-buffer-marks" },
      -- ["m?"] = { "list-buffer-markers" },
      ----
      ["dm"] = { "delete-mark" },
      ----
      -- ["'["] = { "goto-prev-line-alpha" },
      -- ["']"] = { "goto-next-line-alpha" },
      -- ["`["] = { "goto-prev-spot-alpha" },
      -- ["`]"] = { "goto-next-spot-alpha" },
      ----
      -- ["]`"] = { "signature-spot-by-pos" },
      -- ["[`"] = { "signature-spot-by-pos" },
      -- ["['"] = { "signature-line-by-pos" },
      -- ["]'"] = { "signature-line-by-pos" },
      -- ["]-"] = { "signature-marker" },
      -- ["[-"] = { "signature-marker" },
      -- ["[="] = { "signature-marker-any" },
      -- ["]="] = { "signature-marker-any" },
    })
  end
end
