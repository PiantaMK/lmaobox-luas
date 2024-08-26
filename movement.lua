---@diagnostic disable: cast-local-type, param-type-mismatch
local tickCounter = 0
local shouldPrintIntroduction = false

local logo = 
[=[
                                     __    __            
  __ _  ___ _  _____ __ _  ___ ___  / /_  / /_ _____ _   
 /  ' \/ _ \ |/ / -_)  ' \/ -_) _ \/ __/ / / // / _ `/   
/_/_/_/\___/___/\__/_/_/_/\__/_//_/\__(_)_/\_,_/\_,_/    
                                           By Pianta]=]

local features_velhud = 
[=[Thanks for trying out my lua!

Features:
- Velocity HUD: Displays your current speed.
    ... is your current speed, updated every tick.
    (...) is your ground speed, updated when you jump.]=]

local features_point = 
[=[
- Point Comparison: Mark and measure distances between points.
Keybinds:
    - PgDn: Change the point bind.
    - PgUp: Unbind the current point bind.
    - Use the key you selected to compare points in the game.

Have fun and enjoy the script!]=]

engine.PlaySound("ui/buttonclick.wav")
engine.PlaySound("ui/duel_challenge_accepted_with_restriction.wav")
client.Command("clear", true)

local function printIntroduction()
printc(0, 255, 0, 255, logo)
printc(255, 255, 255, 255, features_velhud)
printc(245, 84, 66, 255,"    When it is red, it means that you have reached your ground speed cap.")
printc(92, 137, 255, 255, "    When it is blue, it means that you are blastjumping.")
printc(255, 255, 255, 255, features_point)

if not engine.Con_IsVisible() then
        client.Command("toggleconsole", true)
    end
end

local function checkTicks()
    if shouldPrintIntroduction then
        tickCounter = tickCounter + 1
        if tickCounter >= 1 then
            printIntroduction()
            shouldPrintIntroduction = false
        end
    end
end

shouldPrintIntroduction = true

callbacks.Register("CreateMove", checkTicks)

--------------------------------------------------------------------

local speedhud_font = draw.CreateFont("Calibri", 24, 1000, 144)
local debug_font = draw.CreateFont("Lucida Console", 10, 0, 512)
local point_font = draw.CreateFont("Tahoma", 12, 400, 512)
local FL_ONGROUND = 1
local show_debug_info = false

local groundSpeed = 0
local previousGroundSpeed = 0
local previousOnGround = false
local speedNetGain = 0

local blastJumping = nil
local onGround = nil
local cap_hit = nil

local mem_usage = 0
local wait = 0

local spd_text = ""
local spdw, spdh = nil, nil
local grnd_text = ""
local grndw, grndh = nil, nil
local net_text = ""
local netw, neth = nil, nil

local fadeData = {}

local keys = {[1]="KEY_0",[2]="KEY_1",[3]="KEY_2",[4]="KEY_3",[5]="KEY_4",[6]="KEY_5",[7]="KEY_6",[8]="KEY_7",[9]="KEY_8",[10]="KEY_9",[11]="KEY_A",[12]="KEY_B",[13]="KEY_C",[14]="KEY_D",[15]="KEY_E",[16]="KEY_F",[17]="KEY_G",[18]="KEY_H",[19]="KEY_I",[20]="KEY_J",[21]="KEY_K",[22]="KEY_L",[23]="KEY_M",[24]="KEY_N",[25]="KEY_O",[26]="KEY_P",[27]="KEY_Q",[28]="KEY_R",[29]="KEY_S",[30]="KEY_T",[31]="KEY_U",[32]="KEY_V",[33]="KEY_W",[34]="KEY_X",[35]="KEY_Y",[36]="KEY_Z",[37]="KEY_PAD_0",[38]="KEY_PAD_1",[39]="KEY_PAD_2",[40]="KEY_PAD_3",[41]="KEY_PAD_4",[42]="KEY_PAD_5",[43]="KEY_PAD_6",[44]="KEY_PAD_7",[45]="KEY_PAD_8",[46]="KEY_PAD_9",[47]="KEY_PAD_DIVIDE",[48]="KEY_PAD_MULTIPLY",[49]="KEY_PAD_MINUS",[50]="KEY_PAD_PLUS",[51]="KEY_PAD_ENTER",[52]="KEY_PAD_DECIMAL",[53]="KEY_LBRACKET",[54]="KEY_RBRACKET",[55]="KEY_SEMICOLON",[56]="KEY_APOSTROPHE",[57]="KEY_BACKQUOTE",[58]="KEY_COMMA",[59]="KEY_PERIOD",[60]="KEY_SLASH",[61]="KEY_BACKSLASH",[62]="KEY_MINUS",[63]="KEY_EQUAL",[64]="KEY_ENTER",[65]="KEY_SPACE",[66]="KEY_BACKSPACE",[67]="KEY_TAB",[68]="KEY_CAPSLOCK",[69]="KEY_NUMLOCK",[70]="KEY_ESCAPE",[71]="KEY_SCROLLLOCK",[72]="KEY_INSERT",[73]="KEY_DELETE",[74]="KEY_HOME",[75]="KEY_END",[76]="KEY_PAGEUP",[77]="KEY_PAGEDOWN",[78]="KEY_BREAK",[79]="KEY_LSHIFT",[80]="KEY_RSHIFT",[81]="KEY_LALT",[82]="KEY_RALT",[83]="KEY_LCONTROL",[84]="KEY_RCONTROL",[85]="KEY_LWIN",[86]="KEY_RWIN",[87]="KEY_APP",[88]="KEY_UP",[89]="KEY_LEFT",[90]="KEY_DOWN",[91]="KEY_RIGHT",[92]="KEY_F1",[93]="KEY_F2",[94]="KEY_F3",[95]="KEY_F4",[96]="KEY_F5",[97]="KEY_F6",[98]="KEY_F7",[99]="KEY_F8",[100]="KEY_F9",[101]="KEY_F10",[102]="KEY_F11",[103]="KEY_F12",[104]="KEY_CAPSLOCKTOGGLE",[105]="KEY_NUMLOCKTOGGLE",[106]="KEY_SCROLLLOCKTOGGLE",[107]="MOUSE_LEFT",[108]="MOUSE_RIGHT",[109]="MOUSE_MIDDLE",[110]="MOUSE_4",[111]="MOUSE_5",[112]="MOUSE_WHEEL_UP",[113]="MOUSE_WHEEL_DOWN",[420]="UNBOUND, press PgDn to change the point bind"}
local pressedKey = 420
local freshly_changed = false

local x, y = draw.GetScreenSize()
local sw, sh = x, y 
local text = ""

local distance = nil
local selectedPoint = nil
local lastSelectionTime = 0
local shouldClear = false
local points = {}

local selectionCooldown = 0.2

--------------------------------------------------------------------

local function CalculateDistance(point1, point2)
    local dx = point2.x - point1.x
    local dy = point2.y - point1.y
    local dz = point2.z - point1.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function GetPressedKey()
    for i = 1, 113 do 
        if input.IsButtonPressed(i) then
            if i ~= 107 and i ~= 72 and i ~= 77 then
                engine.PlaySound("replay/rendercomplete.wav")
                freshly_changed = true
                return i
            end
        end
    end
end

local function point_calculation()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end
    if pressedKey == nil then
        text = ("Waiting for keys...")
        pressedKey = GetPressedKey()
    else
        text = ("Point key: " .. keys[pressedKey])

        if not input.IsButtonPressed(pressedKey) and freshly_changed then
            freshly_changed = false
        end

        if input.IsButtonPressed(pressedKey) and not freshly_changed then
            local currentTime = globals.RealTime()

            if currentTime - lastSelectionTime >= selectionCooldown then
                lastSelectionTime = currentTime

                local player = entities.GetLocalPlayer()
                if player then
                    local eyePos = player:GetAbsOrigin() + player:GetPropVector("localdata", "m_vecViewOffset[0]")
                    local viewAngles = engine.GetViewAngles()
                    local forward = viewAngles:Forward()
                    local trace = engine.TraceLine(eyePos, eyePos + forward * 10000, MASK_SOLID)

                    if trace.entity then
                        if not shouldClear then
                            selectedPoint = trace.endpos
                            table.insert(points, selectedPoint)
                            engine.PlaySound("ui/hint.wav")
                            --client.ChatPrintf("\x05Point " .. #points .. " set!\x01")
                        end

                        if shouldClear then
                            engine.PlaySound("ui/credits_updated.wav")
                            points = {}
                            shouldClear = false
                        end

                        if #points == 2 then
                            distance = CalculateDistance(points[1], points[2])
                            --client.ChatPrintf("\x04Distance between points: " .. string.format("%.2f", distance) .. "\x01")
                            shouldClear = true
                        end
                    end
                end
            end
        end
        if input.IsButtonPressed(77) then
            pressedKey = nil
            engine.PlaySound("ui/hint.wav")
        end
        if input.IsButtonPressed(76) then
            pressedKey = 420
        end
    end
end

local function draw_points()
    draw.SetFont(point_font)
    draw.Color(255, 255, 255, 255) -- bind text color
    local tx, ty = draw.GetTextSize(text)
    draw.Text(x // 2 - (tx // 2), y - ty, text)
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end

    if #points == 2 then
        draw.Color(255, 255, 255, 50)
        local screenPos1 = client.WorldToScreen(points[1])
        local screenPos2 = client.WorldToScreen(points[2])
        if screenPos1 and screenPos2 then
            draw.Line(screenPos1[1], screenPos1[2], screenPos2[1], screenPos2[2])
        end
    end

    for n, i in ipairs(points) do
        local screenPos = client.WorldToScreen(i)
        if screenPos then
            local x, y = screenPos[1], screenPos[2]
            local size = 10
            for i=size-1, 1, -1 do -- outline doesnt work for some reason, so i did this
                draw.ColoredCircle(x, y, i, 82, 82, 82, 255)
            end
            draw.Color(255, 255, 255, 255) -- outline color
            draw.OutlinedCircle(x, y, size, 20)
            local point_text = tostring(n)
            local tx, ty = draw.GetTextSize(n)
            draw.Color(255, 255, 255, 255) -- point text color
            draw.Text(x - (tx // 2), y - (ty // 2), point_text)
        end
    end
end

local function draw_dist()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() or not distance or #points ~= 2 then
        return
    end

    draw.SetFont(speedhud_font)

    local distext = string.format("%.2f", distance)

    local w, h = draw.GetScreenSize()
    local tw, th = draw.GetTextSize(distext)

    draw.Color(255, 255, 255, 255)
    draw.Text(w // 2 - (tw//2), math.floor(0.6*h), distext) -- text
end



callbacks.Register("CreateMove", "CreateMove", point_calculation)
callbacks.Register("Draw", "distDraw", draw_dist)
callbacks.Register("Draw", "pointDraw", draw_points)

--------------------------------------------------------------------

local function updateFadeData(key, value)
    if not fadeData[key] or fadeData[key].value ~= value then
        fadeData[key] = {value = value, time = globals.RealTime(), alpha = 255}
    end
end

local function getAlpha(elapsedTime)
    local fadeDuration = 1
    local alpha = 255 * (1 - math.min(elapsedTime / fadeDuration, 1))
    return math.max(alpha, 0)
end

local function GetHorizontalSpeed(velocity)
    return math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
end

local function UpdatePlayerVelocity()
    local player = entities.GetLocalPlayer()
    if not player then return end

    local velocity = player:EstimateAbsVelocity()
    if not velocity then return end

    if player:InCond(81) then blastJumping = true else blastJumping = false end -- 81 = TF_COND_BLASTJUMPING

    local flags = player:GetPropInt("m_fFlags")
    onGround = (flags & FL_ONGROUND) ~= 0

    if previousOnGround and not onGround then
        if groundSpeed then
            previousGroundSpeed = groundSpeed
        end
        groundSpeed = GetHorizontalSpeed(velocity)
        if previousGroundSpeed then
            speedNetGain = groundSpeed - previousGroundSpeed
        end
    end

    previousOnGround = onGround
end

local function getMemoryUsage()
    local mem = collectgarbage("count") / 1024
    return mem
end

local function DrawPlayerVelocity()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end

    local player = entities.GetLocalPlayer()
    local maxspeed = player:GetPropFloat("m_flMaxspeed")
    if not player then return end

    local velocity = player:EstimateAbsVelocity()
    if not velocity then return end
    local speed = GetHorizontalSpeed(velocity)
    local capSpeed = (maxspeed * 1.2) - 1

    if groundSpeed and groundSpeed >= capSpeed and speed >= capSpeed then
        cap_hit = true
    elseif onGround then -- only update the cap status when we're on the ground
        cap_hit = false
    end

    --- debug
    if show_debug_info then
        draw.SetFont(debug_font)
        local dbgx = 10
        local dbgy = 200

        draw.Color(230, 230, 180, 255)
        draw.Text(dbgx, dbgy, "Debug Info")
        draw.Text(dbgx, dbgy + (1*12), "ground: " ..  string.format("%.2f", groundSpeed))
        draw.Text(dbgx, dbgy + (2*12), "cap: " .. capSpeed)
        draw.Text(dbgx, dbgy + (3*12), "speed: " .. string.format("%.2f", speed))
        if speedNetGain then
            draw.Text(dbgx, dbgy + (4*12), "net gain: " .. string.format("%.2f", speedNetGain))
        end
        draw.Text(dbgx, dbgy + (5*12), "blastJumping: " .. tostring(blastJumping))
        draw.Text(dbgx, dbgy + (6*12), "cap_hit: " .. tostring(cap_hit))
        if globals.RealTime() > (wait + 1) then
            mem_usage = getMemoryUsage()
            wait = globals.RealTime()
        end
        local rounded_mem = string.format("%.2f", mem_usage)
        draw.Text(dbgx, dbgy + (7*12), "mem_usage: " .. rounded_mem .. " MB")
    end
    ---------------------------

    if speed then
        draw.Color(255, 255, 255, 255)
        draw.SetFont(speedhud_font)
        spd_text = string.format("%.0f", speed)
        spdw, spdh = draw.GetTextSize(spd_text)
        draw.Text(sw // 2 - (spdw // 2), sh // 2 + (spdh // 2) + 30, spd_text)
    end

    if groundSpeed then
        grnd_text = string.format("(%.0f)", groundSpeed)
        grndw, grndh = draw.GetTextSize(grnd_text)
        if blastJumping then
            draw.Color(92, 137, 255, 255)
        elseif cap_hit then
            draw.Color(245, 84, 66, 255)
        else
            draw.Color(255, 255, 255, 255)
        end
        draw.Text(sw // 2 - (grndw // 2), math.floor((sh // 2) + (grndh // 2) + (spdh * 2)), grnd_text)
    end

    if speedNetGain and speedNetGain ~= groundSpeed then
        draw.Text(sw // 2 - (grndw // 2), math.floor((sh // 2) + (grndh // 2) + (spdh * 2)), grnd_text)
        
        updateFadeData("speedNetGain", speedNetGain)
    
        local elapsedTime = globals.RealTime() - fadeData["speedNetGain"].time
        local alpha = math.floor(getAlpha(elapsedTime))
        
        local decpoints = 0
        local offset = 15
        
        if alpha > 5 then
            if speedNetGain > 1 then
                net_text = "+" .. string.format("%." .. decpoints .. "f", speedNetGain)
                netw, neth = draw.GetTextSize(net_text)
                draw.Color(147, 245, 66, alpha)
                draw.Text(sw // 2 - (netw // 2) + netw + offset, math.floor((sh // 2) + (spdh * 2)), net_text)
            elseif speedNetGain < -1 then
                net_text = string.format("%." .. decpoints .. "f", speedNetGain)
                netw, neth = draw.GetTextSize(net_text)
                draw.Color(245, 84, 66, alpha)
                draw.Text(sw // 2 - (netw // 2) - netw - offset, math.floor((sh // 2) + (spdh * 2)), net_text)
            end
        end
    end


    --[[ VELOCITY GRAPH (i still have no idea how to finish this xd)
    local stored_records_target = 300
    local graph_basex = sw // 2
    local graph_basey = sh - 200
    local px_for_each_tick = 2
    local basespeed = 150
    
    local vels = {300, 100}
    
    -- base line
    draw.Color(255, 255, 255, 255)
    draw.Line(graph_basex - stored_records_target, graph_basey, graph_basex + stored_records_target, graph_basey)
    
    local function draw_velocity_graph(velocities)
        for i = 1, #velocities - 1 do
            local x1 = graph_basex - stored_records_target + (i * px_for_each_tick)
            local y1 = graph_basey - (velocities[i] - basespeed)
            local x2 = graph_basex - stored_records_target + ((i + 1) * px_for_each_tick)
            local y2 = graph_basey - (velocities[i + 1] - basespeed)
            
            draw.Line(x1, math.max(y1, graph_basey), x2, math.max(y2, graph_basey))
        end
    end
    
    -- Draw the graph with the sample data
    draw_velocity_graph(vels)
    ----]]--
end

callbacks.Register("CreateMove", "UpdatePlayerVelocity", UpdatePlayerVelocity)
callbacks.Register("Draw", "DrawPlayerVelocity", DrawPlayerVelocity)
