if hs == nil then
  hs = {}
end

-- https://www.hammerspoon.org/docs/hs.keycodes.html

local M = {}

local imeGroups = {
  {
    name = "Colemak Mod-DH - 세벌식",
    latin ="io.github.colemakmods.keyboardlayout.colemakdh.colemakdhansi",
    nonLatin = "com.apple.inputmethod.Korean.3SetKorean",
    layout = "Colemak DH ANSI",
  },
  {
    name = "Colemak Mod-DH - Japanese",
    latin = "io.github.colemakmods.keyboardlayout.colemakdh.colemakdhansi",
    nonLatin = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese",
    layout = "Colemak DH ANSI",
  },
  {
    name = "QWERTY - 두벌식",
    latin = "com.apple.keylayout.ABC",
    nonLatin = "com.apple.inputmethod.Korean.2SetKorean",
    layout = "ABC",
  },
}

local currentGroupId = 1
hs.keycodes.currentSourceID(imeGroups[1].latin)
local isVimCurrentLatin = true

-------------------

M.toggleIME = function()
  local current = hs.keycodes.currentSourceID()
  local nextInput = nil

  if current == imeGroups[currentGroupId].latin then
    nextInput = imeGroups[currentGroupId].nonLatin
  else
    nextInput = imeGroups[currentGroupId].latin
  end

  hs.keycodes.currentSourceID(nextInput)
end

M.iterIMEGroups = function()
  currentGroupId = currentGroupId % #imeGroups + 1
  hs.alert.closeAll()
  hs.alert.show(imeGroups[currentGroupId].name)
  -- hs.notify.new({title="hammerspoon", informativeText=imeGroups[currentGroupId].name}):send()
  hs.keycodes.currentSourceID(imeGroups[currentGroupId].latin)
  -- hs.keycodes.setLayout(imeGroups[currentGroupId].layout)
end

M.vimEscape = function()
  --- vim 에서 escape 될때 실행될 커맨드
  local current = hs.keycodes.currentSourceID()
  if current == imeGroups[currentGroupId].latin then
    isVimCurrentLatin = true
    return
  end

  isVimCurrentLatin = false
  hs.keycodes.currentSourceID(imeGroups[currentGroupId].latin)
end

M.vimInput = function()
  -- vim에서 Input 모드로 변할때 실행될 커맨드
  local current = hs.keycodes.currentSourceID()

  if isVimCurrentLatin and current ~= imeGroups[currentGroupId].latin then
    hs.keycodes.currentSourceID(imeGroups[currentGroupId].latin)
  elseif not isVimCurrentLatin and current == imeGroups[currentGroupId].latin then
    hs.keycodes.currentSourceID(imeGroups[currentGroupId].nonLatin)
  end
end

M.setup = function()
  hs.hotkey.bind({}, 'F18', M.toggleIME)
  hs.hotkey.bind({ 'control' }, 'F18', M.iterIMEGroups)
  hs.hotkey.bind({}, 'F19', M.vimEscape)
  hs.hotkey.bind({}, 'F20', M.vimInput)
end

return M
