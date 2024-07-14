local function FilledRectGradient(x1, y1, x2, y2, color1, color2, horizontal)
    local width = x2 - x1
    local height = y2 - y1
    local steps = horizontal and width or height
    local r1, g1, b1, a1 = color1[1], color1[2], color1[3], color1[4]
    local r2, g2, b2, a2 = color2[1], color2[2], color2[3], color2[4]

    for i = 0, steps do
        local t = i / steps
        local r = math.floor(r1 + (r2 - r1) * t)
        local g = math.floor(g1 + (g2 - g1) * t)
        local b = math.floor(b1 + (b2 - b1) * t)
        local a = math.floor(a1 + (a2 - a1) * t)
        draw.Color(r, g, b, a)

        if horizontal then
            draw.FilledRect(x1 + i, y1, x1 + i + 1, y2)
        else
            draw.FilledRect(x1, y1 + i, x2, y1 + i + 1)
        end
    end
end

local font = draw.CreateFont("Small Fonts", 12, 0, FONTFLAG_CUSTOM | FONTFLAG_DROPSHADOW)
local box_padding = 5
local accentlinewidth = 2

local function DrawDTInd()
    local ticks = warp.GetChargedTicks()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end
    draw.SetFont(font)

    local draw_bg_box = false
    local rect_length = 150
    local rect_width = 10

    local w, h = draw.GetScreenSize()

    local boxw = rect_length + 2 * box_padding
    local boxh = rect_width + 2 * box_padding  -- height of the box
    local box_startx = (w - boxw) // 2
    local box_starty = h // 2 - boxh + 200

    if draw_bg_box then
        draw.Color(0, 0, 0, 150)
        draw.FilledRect(box_startx, box_starty, box_startx + boxw, box_starty + boxh) --main box
    end

    --draw.Color(255, 101, 101, 255)
    local clr1 = {178,86,98,255}
    local clr2 = {104,34,42,255}
    FilledRectGradient(box_startx + box_padding, box_starty + box_padding, box_startx + box_padding + math.floor(rect_length*ticks/23), box_starty + box_padding + (rect_width // 2), clr1, clr2, false) -- inner bar
    FilledRectGradient(box_startx + box_padding, box_starty + box_padding + (rect_width // 2), box_startx + box_padding + math.floor(rect_length*ticks/23), box_starty + box_padding + rect_width, clr2, clr1, false) -- inner bar
    local text = "TICKS: " .. ticks
    local tx, ty = draw.GetTextSize(text)
    draw.Color(255, 255, 255, 255)
    draw.Text(box_startx + box_padding, box_starty + box_padding - math.floor(ty*1.1), text)
end

callbacks.Register("Draw", DrawDTInd)
