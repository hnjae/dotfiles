-------------------------------------------------------------------------------
-- esc or C-[ 로 영문자판 바꾸는 esc 기능 설정.
-- esc 를 f20 으로 맵핑 해주는 작업 필요. -- krabinder 에서 가능
local caps_mode = hs.hotkey.modal.new()
local inputEnglish = "com.apple.keylayout.ABC"

local on_caps_mode = function()
	caps_mode:enter()
end

local off_caps_mode = function()
	caps_mode:exit()
	local input_source = hs.keycodes.currentSourceID()

	if not (input_source == inputEnglish) then
		hs.eventtap.keyStroke({}, 'right')
		hs.keycodes.currentSourceID(inputEnglish)
	end
	hs.eventtap.keyStroke({}, 'escape')
end

hs.hotkey.bind({}, 'f20', on_caps_mode, off_caps_mode)
-- hs.hotkey.bind({'control'}, '[', on_caps_mode, off_caps_mode)
