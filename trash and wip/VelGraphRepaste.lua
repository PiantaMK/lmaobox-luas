-- aimware lua repaste
-- not mine and broken
-- do not use


local fnt = draw.CreateFont("Calibri", 24, 1000, 144)
local graph_font = draw.CreateFont("Tahoma", 12, 12, 0)

draw.SetFont(fnt)

local onGround = true
local uiSpeed = true -- Enable speed indicator
local uiGraph = true -- Enable speed graph
local uiGraphJumps = true -- Speed graph display jumps
local uiGraphWidth = 250 -- Speed graph width (min: 0, max: 700, default: 250)
local uiGraphMaxY = 400 -- Speed graph max speed (min: 0, max: 5000, default: 400)-- Causes uiGraphWidth and uiGraphMaxY to be ignored, instead graph size will be dynamically calculated from screen size
local uiGraphCompression = 3 -- Speed graph compression
local uiGraphFreq = 0 -- Speed graph delay (min: 0, max: 150, default: 0)
local uiGraphSpread = 10 -- Speed graph spread (min: 0, max: 50, default: 10)
local uiGraphAlpha = 255 -- Speed graph alpha (min: 0, max: 255, default: 255)
local bRainbowColor = true -- Masterswitch for rainbow colors
local bRainbowCurve = false -- Changes graph curve color to rainbow
local bRainbowIndicator = false -- Changes speed indicator color to rainbow

-- END OF SETTINGS --

local lastVel = 0
local tickPrev = 0
local history = {} -- set this to empty upon changing vars above when script is running (if you implement gui)
local lastGraph = 0
local jumpTime = 0
local jumping = false
local jumpPos = nil
local landPos = nil
local jumpSpeed = nil
local lastJump = 0
local graphSetJump = false
local graphSetLand = false
local text = nil
local lastYaw = 0

local last_realtime = globals.RealTime()

local function get_local_player()
    local player = entities.GetLocalPlayer()
    if player == nil then return end
    if (not player:IsAlive()) then
        player = player:GetPropEntity("m_hObserverTarget")
    end
    return player
end

local function round(number, decimals)
    local power = (10 ^ decimals)
    return (math.floor(number * power) / power)
end

local function colour(dist)
    if dist >= 235 then
        return {255, 137, 34}
    elseif dist >= 230 then
        return {255, 33, 33}
    elseif dist >= 227 then
        return {57, 204, 96}
    elseif dist >= 225 then
        return {91, 225, 255}
    else
        return {170, 170, 170}
    end
end

local function speedgraph(vel, x, y, tickNow)

    local sx, sy = draw.GetScreenSize()

    local alpha = uiGraphAlpha
    local graphMaxY = uiGraphMaxY
    local w = uiGraphWidth
  

    local graphCompression = uiGraphCompression

    local graphFreq = uiGraphFreq
    local graphSpread = (uiGraphSpread / 10)

    x = x - (w / 2)

    if(jumpSpeed == nil) then
        jumpSpeed = 0
    end

    if (lastGraph + graphFreq < tickNow) then
        local temp = {}
        temp.vel = math.min(vel, graphMaxY)
        if graphSetJump then
            graphSetJump = false
            temp.jump = true
            temp.jumpSpeed = jumpSpeed
            temp.jumpPos = jumpPos
        end

        if graphSetLand then
            graphSetLand = false
            temp.landed = true
            temp.landPos = landPos
        end

        table.insert(history, temp)
        lastGraph = tickNow
    end

    local over = #history - w / graphSpread
    if over > 0 then
        table.remove(history, 1)
    end

    for i = 2, #history, 1 do
        local val = history[i].vel
        local prevVal = history[i].vel

        local curX = x + ((i * graphSpread))
        local prevX = x + ((i - 1) * graphSpread)

        local curY = y - (val / graphCompression)
        local prevY = y - (prevVal / graphCompression)

        if (uiGraphJumps) then
            if history[i].jump then
                local index

                for q = i + 1, #history, 1 do
                    if history[q].jump then
                        index = q
                        break
                    end

                    if history[q].landed then
                        index = q
                        break
                    end
                end

                local above = 13

                if index then
                    if history[index].landPos and history[index].landPos[1] then
                        local jSpeed = history[i].jumpSpeed
                        local lSpeed = history[index].vel

                        local speedGain = lSpeed - jSpeed

                        if speedGain > -100 then
                            local jPos = history[i].jumpPos[1]
                            local lPos = history[index].landPos[1]
                      
                          

                            local distX = (lPos.x - jPos.x)
                            local distY = (lPos.y - jPos.y)
                          
                          

                            local distance = math.sqrt( (distX ^ 2) + (distY ^ 2) ) + 32

                            if distance > 150 then
                                local jumpX = curX - 1
                                local jumpY = curY

                                local landX = x + (index * graphSpread)
                                local landY = y - (history[index].vel / graphCompression)

                                local topY = landY - above
                                if topY > jumpY or topY > jumpY - above then
                                    topY = jumpY - above
                                end

                                draw.Color(255, 255, 255, math.max(alpha - 55, 50))
                              
                                if(bRainbowColor and bRainbowCurve) then
                                    draw.Color( (math.sin(globals.RealTime()) * 255), (math.cos(globals.RealTime()) * 255), (math.tan(globals.RealTime()) * 255), alpha)
                                end
                              
                                draw.Line(math.floor(jumpX), math.floor(jumpY), math.floor(jumpX), math.floor(topY))
                                draw.Line(math.floor(landX), math.floor(topY), math.floor(landX), math.floor(landY))

                                draw.SetFont(graph_font)

                                text = speedGain > 0 and "+" or ""
                                text = text .. math.floor(speedGain+0.5)

                                local middleX = ((jumpX + landX) / 2) - 18

                                draw.Color(255, 255, 255, alpha)
                                draw.Text(math.floor(middleX + 5), math.floor(topY - 13), text)

                                local ljColour = colour(distance)
                                draw.Color(ljColour[1], ljColour[2], ljColour[3], alpha)
                                draw.Text(math.floor(middleX + 5), math.floor(topY), "(" .. math.floor(distance+0.5) .. ")")
                            end
                        end
                    end
                end
            end
        end

        draw.Color(255, 255, 255, alpha)
      
        if(bRainbowColor and bRainbowCurve) then
            draw.Color( (math.sin(globals.RealTime()) * 255), (math.cos(globals.RealTime()) * 255), (math.tan(globals.RealTime()) * 255), alpha)
        end
        draw.Line(math.floor(prevX), math.floor(prevY), math.floor(curX), math.floor(curY))
    end
end

callbacks.Register('Draw',function()
        if not uiSpeed and not uiGraph then
            return
        end

        if get_local_player() == nil then
            return
        end

        local sx, sy = draw.GetScreenSize()

        local flags = get_local_player():GetPropInt('m_fFlags')
        if flags == nil then
            return
        end

        onGround = (flags & FL_ONGROUND) ~= 0

        local movetype = get_local_player():GetPropInt('m_iMoveState') -- this isn't proper way to get 'movetype'

        if movetype == 2 then -- moving on a ladder and nocliping
            jumping = false
            landPos = {nil, nil, nil}
            graphSetLand = true
            return
        end

        if not onGround and not jumping then
            local x, y, z = get_local_player():GetAbsOrigin()
            if x == nil then
                return
            end

            local vx = get_local_player():GetPropFloat('localdata', 'm_vecVelocity[0]')
            local vy = get_local_player():GetPropFloat('localdata', 'm_vecVelocity[1]')

            if vx == nil then
                return
            end

            graphSetJump = true
            jumping = true
            jumpPos = {x, y, z}
            jumpSpeed = math.floor(math.min(10000, math.sqrt(vx * vx + vy * vy) + 0.5))

            local thisTick = globals.TickCount()
            lastJump = thisTick

            if last_realtime + 4 < globals.RealTime() then
                if lastJump == thisTick then
                    jumpSpeed = nil
                end
                last_realtime = globals.RealTime()
            end
        end

        if jumping and onGround then
            local x, y, z = get_local_player():GetAbsOrigin()
            if x == nil then
                return
            end

            jumping = false
            landPos = {x, y, z}
            graphSetLand = true
        end

        --draw.SetFont(draw.CreateFont("Trebuchet MS", math.floor( (sx*0.015625) + 0.5) )) -- 30 on fhd

if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then return end

        local vx = get_local_player():GetPropFloat('localdata', 'm_vecVelocity[0]')
        local vy = get_local_player():GetPropFloat('localdata', 'm_vecVelocity[1]')

        if vx ~= nil then
            local velocity = math.floor(math.min(10000, math.sqrt(vx * vx + vy * vy) + 0.5))

            local x = (sx / 2)
            local y = (sy / 1.2)

            if (uiSpeed) then
                local r, g, b = 255, 255, 255

                if lastVel < velocity then
                    r, g, b = 30, 255, 109
                end

                if lastVel == velocity then
                    r, g, b = 255, 199, 89
                end

                if lastVel > velocity then
                    r, g, b = 255, 119, 119
                end

                local text = tostring(velocity)

                if jumpSpeed then
                    text = text .. ' (' .. jumpSpeed .. ')'
                end

                draw.Color(r, g, b, 255)

                if (bRainbowColor and bRainbowIndicator) then
                    draw.Color(
                        math.floor(math.sin(globals.RealTime()) * 255),
                        math.floor(math.cos(globals.RealTime()) * 255),
                        math.floor(math.tan(globals.RealTime()) * 255),
                        255
                    )
                end

                if (velocity == 0) then
                    draw.Text(math.floor(x - (x * 0.0175)), math.floor(y), text)
                else
                    draw.Text(math.floor(x - (x * 0.0175)), math.floor(y), text)
                end
            end

            local tickNow = globals.TickCount()
            speedgraph(velocity, x, y - (y * 0.03), tickNow, false)

            if tickPrev + 5 < tickNow then
                lastVel = velocity
                tickPrev = tickNow
            end
        end
    end
)


callbacks.Register("FireGameEvent", function(event)
    tickPrev = globals.TickCount()
    lastGraph = globals.TickCount()
end)