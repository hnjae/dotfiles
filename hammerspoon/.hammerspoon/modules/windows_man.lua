-- font: InconsolataLGC Nerd Font Medium 14 / iterm / 너비 87칸 -- 너비 793px
local term_width_px = 793

-- 윈도우 스냅 & 풀스크린
local windowSnap = function(position)
	local win = hs.window.focusedWindow()   -- 현재 활성화된 앱의 윈도우
	local frame = win:frame()
	local screen = win:screen():frame()	 -- 현재 화면

        if position == "left" then
          frame.x = screen.x
          frame.y = screen.y
          frame.w = screen.w / 2
          frame.h = screen.h
        elseif position == "right" then
          frame.x = screen.x + (screen.w /2)
          frame.y = screen.y
          frame.w = screen.w / 2
          frame.h = screen.h
        elseif position == "up" then
          frame.y = screen.y
          frame.h = screen.h /2
        elseif position == "down" then
          frame.y = screen.y + screen.h / 2
          frame.h = screen.h / 2
        elseif position == "full" then
          frame.x = screen.x
          frame.y = screen.y
          frame.w = screen.w
          frame.h = screen.h
        end

	win:setFrame(frame)
end



hs.hotkey.bind({'option', 'command'}, 'left', function() windowSnap("left") end)
hs.hotkey.bind({'option', 'command'}, 'right', function() windowSnap("right") end)
hs.hotkey.bind({'option', 'command'}, 'up', function() windowSnap("full") end)
hs.hotkey.bind({'option', 'command'}, 'down', function() windowSnap("down") end)
-- hs.hotkey.bind({'option', 'command'}, 'f', function() windowSnap("full") end)

-- hs.hotkey.bind({'F16'}, 'left', function() windowSnap("left") end)
-- hs.hotkey.bind({'F16'}, 'right', function() windowSnap("right") end)
-- hs.hotkey.bind({'F16'}, 'up', function() windowSnap("up") end)
-- hs.hotkey.bind({'F16'}, 'down', function() windowSnap("down") end)
-- hs.hotkey.bind({'F16'}, 'F', function() windowSnap("full") end)

-- hs.hotkey.bind({'option', 'command'}, 'right', move_win_to_right)
-- hs.hotkey.bind({'option', 'command'}, 'up', window_fullscreen)

-- hs.hotkey.bind({'option', 'command'}, 'h', move_win_to_left)
-- hs.hotkey.bind({'option', 'command'}, 'l', move_win_to_right)
-- hs.hotkey.bind({'option', 'command'}, 'k', window_fullscreen)

------
-- 십자키 배치
local function move_win(xx, yy, ww, hh)
	return function()
		local win = hs.window.focusedWindow()
		local f = win:frame()
		local max = win:screen():frame()
		f.x = max.w * xx
		f.y = max.h * yy
		f.w = max.w * ww
		f.h = max.h * hh
		win:setFrame(f)
	end
end

-- local mod = {'option', 'command'}
-- hs.hotkey.bind(mod, 'up',   'left',  move_win(0,   1/2, 1/2, 1/2))
-- hs.hotkey.bind(mod, 'up',   'right', move_win(1/2, 1/2, 1/2, 1/2))
-- hs.hotkey.bind(mod, 'down', 'left',  move_win(0,     0, 1/2, 1/2))
-- hs.hotkey.bind(mod, 'down', 'right', move_win(1/2,   0, 1/2, 1/2))


--    -- COMMAND - TAB
--    -- set up your windowfilter
--    switcher = hs.window.switcher.new()
--    	-- default windowfilter: only visible windows, all Spaces
--    switcher_space = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}) -- include minimized/hidden windows, current Space only
--
--    -- switcher_browsers = hs.window.switcher.new{'Safari','Google Chrome'} -- specialized switcher for your dozens of browser windows :)
--
--
--
--    -- bind to hotkeys; WARNING: at least one modifier key is required!
--    -- hs.hotkey.bind('command','`',function()switcher:next()end)
--    -- hs.hotkey.bind('command-shift','`',function()switcher:previous()end)
--
--    -- alternatively, call .nextWindow() or .previousWindow() directly (same as hs.window.switcher.new():next())
--    hs.hotkey.bind('command','`',switcher_space.nextWindow)
--    -- you can also bind to `repeatFn` for faster traversing
--    hs.hotkey.bind('command-shift','`',switcher_space.previousWindow,nil,switcher_space.previousWindow)
