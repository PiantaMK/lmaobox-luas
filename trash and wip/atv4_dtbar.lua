---@diagnostic disable: undefined-global

for keyname, value in pairs(draw) do
    if type(value) == "function" then
        _ENV[keyname] = value
    end
end


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
        Color(r, g, b, a)

        if horizontal then
            FilledRect(x1 + i, y1, x1 + i + 1, y2)
        else
            FilledRect(x1, y1 + i, x2, y1 + i + 1)
        end
    end
end

local font = CreateFont("Verdana", 12, 0, 128)
local box_padding = 5
local max_ticks = 23

local function DrawDTInd()
    local ticks = warp.GetChargedTicks()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end
    SetFont(font)

    local draw_bg_box = true
    local rect_length = 150
    local rect_width = 10

    local w, h = GetScreenSize()

    local boxw = rect_length + 2 * box_padding
    local boxh = rect_width + 2 * box_padding  -- height of the box
    local box_startx = (w - boxw) // 2
    local box_starty = h // 2 - boxh + 200

    local dt_text = "TICKS: " .. ticks
    local dt_tx, dt_ty = GetTextSize(dt_text)

    if draw_bg_box then
        Color(0, 0, 0, 150)
        FilledRect(box_startx, box_starty - dt_ty, box_startx + boxw, box_starty + boxh) --main box
    end

    local clr1 = {178, 86, 98, 255}
    local clr2 = {104, 34, 42, 255}
    FilledRectGradient(box_startx + box_padding, box_starty + box_padding, box_startx + box_padding + math.floor(rect_length*ticks/max_ticks), box_starty + box_padding + (rect_width // 2), clr1, clr2, false) -- top
    FilledRectGradient(box_startx + box_padding, box_starty + box_padding + (rect_width // 2), box_startx + box_padding + math.floor(rect_length*ticks/max_ticks), box_starty + box_padding + rect_width, clr2, clr1, false) -- bottom
    Color(255, 255, 255, 255)
    Text(box_startx + box_padding, box_starty + box_padding - math.floor(dt_ty*1.25), dt_text)
    local alpha = math.abs(math.floor(200 * (ticks/max_ticks)) - 200) + 22
    if alpha > 255 then alpha = 255 end
    Color(255, 255, 255, alpha)
    OutlinedRect(box_startx + box_padding, box_starty + box_padding, box_startx + box_padding + math.floor(rect_length*ticks/max_ticks), box_starty + box_padding + rect_width) -- inner bar

    local status_text = ""
    if ticks < max_ticks then
        Color(217, 35, 48, 255)
        status_text = "LOW CHARGE"
    elseif ticks == max_ticks then
        Color(60, 222, 90, 255)
        status_text = "READY"
    end
    --status_text = tostring(alpha)

    local status_tx, status_ty = GetTextSize(status_text)
    Text(box_startx + boxw - box_padding - status_tx, box_starty + box_padding - math.floor(status_ty*1.25), status_text)
end

callbacks.Register("Draw", DrawDTInd)
