-------------------------------------------------------------------------------
-- clipboard?

-- do  -- clipboard history
--     local f16_mode = hs.hotkey.modal.new()
--     hs.hotkey.bind({'option'}, 'p', function() f16_mode:enter() end, function() f16_mode:exit() end)
-- 
--     local clipboard = require('modules.clipboard')
--     clipboard.setSize(10)
--     f16_mode:bind({}, 'c', clipboard.showList)
--     hs.hotkey.bind({'cmd', 'shift'}, 'c', clipboard.clear)
-- end



--------------
local pasteboard = require("hs.pasteboard")
local save = {}

-- cmd + shift + index 입력을 받으면 cmd + c 키 이벤트를 발생시킨다
-- 그리고 0.1 초 후에 클립보드로 들어간 내용을 save[index]에 보관한다
for index = 0, 9 do
    hs.hotkey.bind({'cmd', 'shift'}, tostring(index), function()
        hs.eventtap.keyStroke({'cmd'}, 'c')
        hs.timer.doAfter(0.1, function()
            save[index] = pasteboard.getContents()
        end)
    end)

    hs.hotkey.bind({'cmd'}, tostring(index), function()
        if save[index] then
            pasteboard.setContents(save[index])
            hs.eventtap.keyStroke({'cmd'}, 'v')
        end
    end)
end

local history = {}
local historySize = 10
local lastChange = pasteboard.changeCount()
local register = {}

local util = {}

function util.focusLastFocused()
    local filter = hs.window.filter
    local lastFocused = filter.defaultCurrentSpace:getWindows(filter.sortByFocusedLast)
    if #lastFocused > 0 then
        lastFocused[1]:focus()
    end
end

local function shiftHistory(text)
    for key, value in pairs(history) do
        if value.text == text then
            local item = table.remove(history, key)
            return table.insert(history, 1, item)
        end
    end
end

local chooser = hs.chooser.new(function (choice)
    if not choice then
        util.focusLastFocused()
    end
    shiftHistory(choice.text)
    pasteboard.setContents(choice.text)
    util.focusLastFocused()
    hs.eventtap.keyStroke({"cmd"}, "v")
end)

function clearSizeOver()
    while (#history >= historySize) do
        table.remove(history, #history)
    end
end

function storeCopy()

    clearSizeOver()

    local content = pasteboard.getContents()

    if #history < 1 or not (history[1].text == content) then
        table.insert(history, 1, {text = content, subText = 'size: ' .. utf8.len(content)})
    end
end

copy = hs.hotkey.bind({"cmd"}, "c", function()
    copy:disable()
    hs.eventtap.keyStroke({"cmd"}, "c")
    copy:enable()
    hs.timer.doAfter(0.1, storeCopy)
end)

local obj = {}

function obj.showList()
    local content = pasteboard.getContents()
    if #history < 1 or not (history[1].text == content) then
        table.insert(history, 1, {text = content})
    end
    chooser:choices(history)
    chooser:show()
end

function obj.clear()
    history = {}
    chooser:cancel()
    util.focusLastFocused()
end

function obj.setSize(num)
    historySize = num
end

return obj

