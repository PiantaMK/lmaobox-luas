--- ##### GENERAL OPTIONS ##### ---
local font = draw.CreateFont("verdana", 16, 800, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE | FONTFLAG_DROPSHADOW)
local box_padding = 5
local accentlinewidth = 2
local num_segments = 100 -- decrease this if you have performance issues
local wave_spread = 1 -- how spread out a "wave" is (less is more spread out)
local bias = 0.55 -- color balancing. bigger values will show more of the 2nd value and vice versa
local color1 = {0, 0, 0}
local color2 = {255, 255, 255}
local frequency = 0.5 -- controls the speed of color change
--- ########################### ---

local fps = 0
local ms = 0

engine.PlaySound("ui/buttonclick.wav")

local function LerpBetweenColors(color1, color2, t) -- credits: Muqa
    t = math.max(0, math.min(1, t))
    local r1, g1, b1 = color1[1], color1[2], color1[3]
    local r2, g2, b2 = color2[1], color2[2], color2[3]
    local r = math.floor(r1 + (r2 - r1) * t)
    local g = math.floor(g1 + (g2 - g1) * t)
    local b = math.floor(b1 + (b2 - b1) * t)
    return r, g, b
end

local function draw_watermark()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end
	draw.SetFont(font)

    if globals.FrameCount() % 50 == 0 then
        fps = math.floor(1 / globals.FrameTime())
        ms = clientstate.GetClientSignonState() == 6 and entities.GetPlayerResources():GetPropDataTableInt("m_iPing")[entities.GetLocalPlayer():GetIndex()] or "-" -- credits: Muqa
    end

    local text = "lmaobox | fps: " .. fps .. " | ping: " .. ms
	
    local w, h = draw.GetScreenSize()
    local tw, th = draw.GetTextSize(text)
	
    local boxw = tw + 2 * box_padding
    local boxh = th + 2 * box_padding
	
	--- ##### POSITION OPTIONS ##### ---
    local box_startx = 10 -- right (use w - boxw - 10 for left)
    local box_starty = 10 -- top (remove "h -" for top)
	--- ############################ ---

    draw.Color(0, 0, 0, 150)
    draw.FilledRect(w - box_startx - boxw, box_starty, w - box_startx, box_starty + boxh) -- main box

    local segment_width = boxw / num_segments

    for i = 0, num_segments - 1 do
        local phase_shift = (i / num_segments) * math.pi * wave_spread -- shift the sine wave phase for each segment
        local t = (math.sin(globals.CurTime() * frequency + phase_shift) + bias) / 2
        local r, g, b = LerpBetweenColors(color1, color2, t)
        draw.Color(r, g, b, 255)
        draw.FilledRect(math.floor(w - box_startx - boxw + i * segment_width), box_starty - accentlinewidth, math.floor(w - box_startx - boxw + (i + 1) * segment_width), box_starty) -- accent
    end

    draw.Color(255, 255, 255, 255)
    draw.Text(w - box_startx - boxw + box_padding, box_starty + box_padding, text) -- text
end

callbacks.Register("Draw", "mydraw", draw_watermark)
