if hs == nil then
  hs = {}
end

-- https://www.hammerspoon.org/docs/hs.keycodes.html

local imeGroups = {
  {
    name = "Colemak Mod-DH - 세벌식",
    latin ="io.github.colemakmods.keyboardlayout.colemakdh.colemakdhansi",
    nonLatin = "com.apple.inputmethod.Korean.3SetKorean"
  },
  {
    name = "Colemak Mod-DH - Japanese",
    latin = "io.github.colemakmods.keyboardlayout.colemakdh.colemakdhansi",
    nonLatin = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
  },
  {
    name = "QWERTY - 두벌식",
    latin = "com.apple.keylayout.ABC",
    nonLatin = "com.apple.inputmethod.Korean.2SetKorean"
  },
}

local currentGroupId = 1
hs.keycodes.currentSourceID(imeGroups[1].latin)

local toggleIME = function()
  local current = hs.keycodes.currentSourceID()
  local nextInput = nil

  if current == imeGroups[currentGroupId].latin then
    nextInput = imeGroups[currentGroupId].nonLatin
  else
    nextInput = imeGroups[currentGroupId].latin
  end

  hs.keycodes.currentSourceID(nextInput)
end

local iterIMEGroups = function()
  currentGroupId = currentGroupId % #imeGroups + 1
  hs.alert.show(imeGroups[currentGroupId].name)
  hs.keycodes.currentSourceID(imeGroups[currentGroupId].latin)
end

hs.hotkey.bind({}, 'F18', toggleIME)
hs.hotkey.bind({ 'control' }, 'F18', iterIMEGroups)
