-- Shortcuts
-- hs.hotkey.bind({'command'}, 'space' , function()
--	 hs.application.launchOrFocus('Alfred 4')
-- end)


-- Alt-Tab 윈도우 선택기
hs.hints.hintChars = {'1', '2', '3', '4', 'Q', 'W', 'E', 'R'}
hs.hotkey.bind({'option'}, 'Tab', hs.hints.windowHints)

--------------------------------------------------------------------------------
-- 앱 숏컷Shortcuts

hs.hotkey.bind({'option'}, '1', function()
	hs.application.launchOrFocus('Skim')
end)
hs.hotkey.bind({'option'}, '2', function()
	hs.application.launchOrFocus('Firefox')
end)
hs.hotkey.bind({'option'}, '3', function()
	hs.application.launchOrFocus('iTerm')
end)
hs.hotkey.bind({'option'}, '4', function()
	hs.application.launchOrFocus('PDF Expert')
end)

-- 알파펫 지정
hs.hotkey.bind({'option'}, 'N', function()
	hs.application.launchOrFocus('Notes')
end)
hs.hotkey.bind({'option'}, 'F', function()
	hs.application.launchOrFocus('Firefox')
end)
hs.hotkey.bind({'option'}, 'I', function()
	hs.application.launchOrFocus('iTerm')
end)
hs.hotkey.bind({'option'}, 'T', function()
	hs.application.launchOrFocus('Things3')
end)
hs.hotkey.bind({'option'}, 'S', function()
	hs.application.launchOrFocus('Spark')
end)
hs.hotkey.bind({'option'}, 'P', function()
	hs.application.launchOrFocus('PDF Expert')
end)
hs.hotkey.bind({'option'}, 'V', function()
	hs.application.launchOrFocus('Visual Studio Code')
end)

-- 시작 알파펫이 아닌 애들
hs.hotkey.bind({'option'}, 'K', function()
	hs.application.launchOrFocus('Skim')
end)
hs.hotkey.bind({'option'}, 'C', function()
	hs.application.launchOrFocus('Fantastical 2')
end)
hs.hotkey.bind({'option'}, 'A', function()
	hs.application.launchOrFocus('Safari')
end)
