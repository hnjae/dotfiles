-- Edited from:
-- https://github.com/johngrib/hammerspoon-config/blob/master/modules/inputsource_aurora.lua
-- MIT License (2022-06-24)

local boxes = {}
local box_height = 24
local box_alpha = 0.28
local GREEN = hs.drawing.color.osx_green

local latinIMEs = {
    ["io.github.colemakmods.keyboardlayout.colemakdh.colemakdhansi"] = true,
    ["com.apple.keylayout.ABC"] = true,
    ["com.apple.keylayout.US"] = true,
}


local newBox = function()
    return hs.drawing.rectangle(hs.geometry.rect(0,0,0,0))
end

local resetBoxes = function()
    boxes = {}
end

local drawRectangle = function(target_draw, x, y, width, height, fill_color)
  -- 그릴 영역 크기를 잡는다
  target_draw:setSize(hs.geometry.rect(x, y, width, height))
  -- 그릴 영역의 위치를 잡는다
  target_draw:setTopLeft(hs.geometry.point(x, y))

  target_draw:setFillColor(fill_color)
  target_draw:setFill(true)
  target_draw:setAlpha(box_alpha)
  target_draw:setLevel(hs.drawing.windowLevels.overlay)
  target_draw:setStroke(false)
  target_draw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
  target_draw:show()
end


local enableShow = function()
    resetBoxes()
    hs.fnutils.each(hs.screen.allScreens(), function(scr)
        local frame = scr:fullFrame()

        local box = newBox()
        drawRectangle(box, frame.x, frame.y, frame.w, box_height, GREEN)
        table.insert(boxes, box)

        -- local box2 = newBox()
        -- drawRectangle(box2, frame.x, frame.y + frame.h - 10, frame.w, box_height, GREEN)
        -- table.insert(boxes, box2)
    end)
end

local disableShow = function()
    hs.fnutils.each(boxes, function(box)
        if box ~= nil then
            box:delete()
        end
    end)
    resetBoxes()
end

-- 입력소스 변경 이벤트에 이벤트 리스너를 달아준다
hs.keycodes.inputSourceChanged(function()
    disableShow()
    if not latinIMEs[hs.keycodes.currentSourceID()] then
        enableShow()
    end
end)
