Watermark = {
    font = draw.CreateFont("Tahoma", 12, 400, FONTFLAG_DROPSHADOW),
    dragging = false,
    drag_offset_x = 0,
    drag_offset_y = 0,
    x = 10, -- initial x position (right)
    y = 10  -- initial y position (top)
}

--- ##### GENERAL OPTIONS ##### ---
local box_padding = 4
local accentlinewidth = 1
--- ########################### ---
local fps = 0
local ms = 0
local previous_lmb = false

local function GetCurrentTime()
    local hour = os.date("%H")
    local minute = os.date("%M")
    return hour, minute
end

function Watermark:DrawWatermark()
    local localPlayer = entities.GetLocalPlayer()
    local nickname = localPlayer and localPlayer:GetName() or "error"

    if engine.Con_IsVisible() or engine.IsGameUIVisible() or engine.IsTakingScreenshot() then
        return
    end

    draw.SetFont(Watermark.font)

    if globals.FrameCount() % 50 == 0 then
        fps = math.floor(1 / globals.FrameTime())
        ms = clientstate.GetClientSignonState() == 6 and entities.GetPlayerResources():GetPropDataTableInt("m_iPing")[entities.GetLocalPlayer():GetIndex()] or 0
    end

    local hour, minute = GetCurrentTime()
    local text = "lmaobox | fps: " .. fps .. " | ping: " .. ms .. " | user: " .. nickname .. " | " .. hour .. ":" .. minute
    local w, h = draw.GetScreenSize()
    local tw, th = draw.GetTextSize(text)
    local boxw = tw + 2 * box_padding
    local boxh = th + 2 * box_padding
    local mouseX, mouseY = input.GetMousePos()[1], input.GetMousePos()[2]
    local LMBDown = input.IsButtonDown(MOUSE_LEFT)

    if IsMouseInBounds(w - Watermark.x - boxw, Watermark.y, w - Watermark.x, Watermark.y + boxh) and MENU_OPEN then
        if LMBDown and not previous_lmb then
            if not Watermark.dragging then
                Watermark.dragging = true
                Watermark.drag_offset_x = mouseX - (w - Watermark.x - boxw)
                Watermark.drag_offset_y = mouseY - Watermark.y
            end
        end
    end

    if Watermark.dragging then
        if LMBDown then
            Watermark.x = w - (mouseX - Watermark.drag_offset_x + boxw)
            Watermark.y = mouseY - Watermark.drag_offset_y
        else
            Watermark.dragging = false
        end
    end

    previous_lmb = LMBDown

    draw.Color(0, 0, 0, 100)
    draw.FilledRect(w - Watermark.x - boxw, Watermark.y, w - Watermark.x, Watermark.y + boxh) -- main box
    draw.Color(178, 4, 41, 255)
    draw.FilledRect(w - Watermark.x - boxw, Watermark.y - accentlinewidth, w - Watermark.x, Watermark.y) -- accent line
    draw.Color(201, 201, 201, 255)
    draw.Text(w - Watermark.x - boxw + box_padding, Watermark.y + box_padding, text) -- text
end

return Watermark