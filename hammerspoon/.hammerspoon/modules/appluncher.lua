local M = {}
-- Shortcuts
-- hs.hotkey.bind({'command'}, 'space' , function()
--	 hs.application.launchOrFocus('Alfred 4')
-- end)


-- Alt-Tab 윈도우 선택기
-- hs.hints.hintChars = {'1', '2', '3', '4', 'Q', 'W', 'E', 'R'}
-- hs.hotkey.bind({'option'}, 'Tab', hs.hints.windowHints)
-- hs.hotkey.bind({'F17'}, 'Tab', hs.hints.windowHints)

function M:init()
  local chooser = hs.chooser.new(function(choice)
    hs.application.launchOrFocus(choice.app)
  end)
  -- hs.hotkey.bind({'option'}, 'R', chooser)
  -- hs.hotkey.bind({ 'option' }, 'Tab', function()
  --   local list = {}
  --   table.insert(list, {
  --     text = 'Vivaldi',
  --     subText = 'launchOrFocus',
  --     app = "Vivaldi"
  --     -- image = hs.image.imageFromPath( 이미지 주소 .. '.jpg'),
  --   })
  --   table.insert(list, {
  --     text = 'alert2',
  --     subText = '화면에 두 번째 알림을 띄웁니다',
  --     -- image = hs.image.imageFromPath( 이미지 주소 .. '.jpg'),
  --   })
  --   chooser:choices(list)
  --   chooser:show()
  -- end)

  local mode = hs.hotkey.modal.new({}, "F16")
  -- local mode = hs.hotkey.modal.new()
  -- mode:entered = function()
  --   hs.alert.show("srtrst")
  -- end
  -- hs.hotkey.bind({}, 'F17', function()
  --   mode:enter()
  -- end
  -- )
  function mode:entered()
    -- hs.dialog.blockAlert("blabla", "blabla2", "1")
    hs.alert.closeAll()
    hs.alert.show("F16: Appmenu", hs.alert.defaultStyle, hs.screen.mainScreen(), "1")
  end
  -- mode:bind({}, "1", function()
  --   local a = hs.application.runningApplications()
  --   hs.alert.show(a[1])
  --   hs.alert.closeAll()
  --   mode:exit()Vivaldi
  -- end)
  mode:bind({}, "f", function()
    hs.application.launchOrFocus('Firefox')
    hs.alert.closeAll()
    mode:exit()
  end)
  mode:bind({}, "t", function()
    hs.application.launchOrFocus('iTerm')
    hs.alert.closeAll()
    mode:exit()
  end)
  mode:bind({}, "k", function()
    hs.application.launchOrFocus('KakaoTalk')
    hs.alert.closeAll()
    mode:exit()
  end)
  mode:bind({}, "Escape", function()
    hs.alert.closeAll()
    mode:exit()
  end)

  hs.hotkey.bind({'command'}, 'p', function()
    hs.application.launchOrFocus('1Password')
  end)
  -- self.mode = mode
end

--------------------------------------------------------------------------------
-- 앱 숏컷Shortcuts

-- hs.hotkey.bind({'option'}, '1', function()
-- 	hs.application.launchOrFocus('Skim')
-- end)
-- hs.hotkey.bind({'option'}, '2', function()
-- 	hs.application.launchOrFocus('Firefox')
-- end)
-- -- hs.hotkey.bind({'command'}, 'Enter', function()
-- -- 	hs.application.launchOrFocus('iTerm')
-- -- end)
-- -- hs.hotkey.bind({'option'}, '4', function()
-- -- 	hs.application.launchOrFocus('PDF Expert')
-- -- end)

-- -- 알파펫 지정
-- hs.hotkey.bind({'option'}, 'N', function()
-- 	hs.application.launchOrFocus('Notes')
-- end)
-- hs.hotkey.bind({'option'}, 'F', function()
-- 	hs.application.launchOrFocus('Firefox')
-- end)
-- hs.hotkey.bind({'option'}, 'I', function()
-- 	hs.application.launchOrFocus('iTerm')
-- end)
-- hs.hotkey.bind({'option'}, 'V', function()
-- 	hs.application.launchOrFocus('Visual Studio Code')
-- end)

-- -- 시작 알파펫이 아닌 애들
-- hs.hotkey.bind({'option'}, 'K', function()
-- 	hs.application.launchOrFocus('Skim')
-- end)
return M
