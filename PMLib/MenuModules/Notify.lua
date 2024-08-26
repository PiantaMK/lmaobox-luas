--[[
modelled after the original valve 'developer 1' debug console
https://github.com/LestaD/SourceEngine2007/blob/master/se2007/engine/console.cpp

pasted from:
https://github.com/OneshotGH/supremacy/blob/master/notify.h
]]

local font = draw.CreateFont("Lucida Console", 10, 500, FONTFLAG_DROPSHADOW)
Notify = {
    notify_texts = {},
    max_notifications = 6
}

---@param text string
---@param time number
---@param color table
---@param print_to_console boolean
function Notify:Add(text, time, color, print_to_console)
    time = time or 8.0 -- default: 8 sec
    color = color or {255, 255, 255, 255}
    print_to_console = print_to_console or false -- if enabled any notification will be also printed in the console

    if self.max_notifications then
        if #self.notify_texts >= self.max_notifications then
            table.remove(self.notify_texts, 1) -- remove the oldest notification
        end
    end

    table.insert(self.notify_texts, {text = text, color = color, time = time})
    if print_to_console then
        printc(color[1], color[2], color[3], color[4], text)
    end
end

function Notify:Think()
    draw.SetFont(font)
    local x, y = 8, 5
    local _, size = draw.GetTextSize(" ") -- LOL
    size = size + 1
    local frameTime = globals.FrameTime()
    for i = #self.notify_texts, 1, -1 do
        local notify = self.notify_texts[i]
        notify.time = notify.time - frameTime
        if notify.time <= 0 then
            table.remove(self.notify_texts, i)
        end
    end
    if #self.notify_texts == 0 then
        return
    end
    for i, notify in ipairs(self.notify_texts) do
        local color = notify.color
        if notify.time < 0.5 then
            local f = notify.time / 0.5
            color[4] = math.floor(f * 255)
            if i == 1 and f < 0.2 then
                y = y - size * (1 - f / 0.2)
            end
        else
            color[4] = 255
        end
        if color[4] and color[4] > 1 then
            if engine.IsTakingScreenshot() then
                return
            end
            draw.Color(table.unpack(color))
            draw.Text(x, math.floor(y), notify.text)
        end
        y = y + size
    end
end

return Notify