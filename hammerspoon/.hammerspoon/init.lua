hs.alert.show('Hello, world! Hammerspoon')
hs.hotkey.bind({ 'option', 'cmd' }, 'r', hs.reload)

-------------------------------------------------------------------------------
-- shift - space 는 백스페이스
-- hs.hotkey.bind({ 'shift' }, 'space', function()
--   hs.eventtap.keyStroke({}, 'delete')
-- end)

-------------------------------------------------------------------------------

-- require('modules.inputsource_aurora')
-- require('modules.inputsource_direct')
require('modules.appluncher')
require('modules.windows_man')
require('modules.clipboard')
require('modules.ime2abc')
require('modules.hangul')


-------------------------------------------------------------------------------

-- 선택기 (demo app)
-- TODO: 나중에 이걸로 alt-tab alternative 만들기
local chooser = hs.chooser.new(function(choice)
  hs.alert.show(choice.text)
end)

hs.hotkey.bind({ 'option' }, 'l', function()
  local list = {}
  table.insert(list, {
    text = 'alert1',
    subText = '화면에 첫 번째 알림을 띄웁니다',
    -- image = hs.image.imageFromPath( 이미지 주소 .. '.jpg'),
  })
  table.insert(list, {
    text = 'alert2',
    subText = '화면에 두 번째 알림을 띄웁니다',
    -- image = hs.image.imageFromPath( 이미지 주소 .. '.jpg'),
  })
  chooser:choices(list)
  chooser:show()
end)

hs.hotkey.bind({'cmd'}, 'i', function()
    local input_source = hs.keycodes.currentSourceID()
    print(input_source)
end)
