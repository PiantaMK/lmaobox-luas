local hitPositions = {}
local font = draw.CreateFont("Calibri", 24, 1000, 144)
draw.SetFont(font)

local function drawHitmarker(x, y, alpha)
    if alpha and alpha > 15 then
    local size = 10
    draw.Color(255, 0, 0, alpha)
    draw.Line(x - size, y - size, x + size, y + size)
    draw.Line(x + size, y - size, x - size, y + size)
    end
end

local function drawDamage(x, y, damage, alpha)
    draw.Color(255, 255, 255, alpha)
    draw.TextShadow(x - 10, y + 15, tostring(damage))
end


local function damageLogger(event)
    if (event:GetName() == 'player_hurt') then
        local localPlayer = entities.GetLocalPlayer()
        local victim = entities.GetByUserID(event:GetInt("userid"))
        local attacker = entities.GetByUserID(event:GetInt("attacker"))
        local damage = event:GetInt("damageamount")

        if (attacker == nil or localPlayer:GetIndex() ~= attacker:GetIndex()) then
            return
        end

        table.insert(hitPositions, {victim = victim, damage = damage, time = globals.RealTime()})
    end
end

local function onDraw()
    local currentTime = globals.RealTime()
    for i = #hitPositions, 1, -1 do
        local pos = hitPositions[i]
        local elapsedTime = currentTime - pos.time
        if elapsedTime > 1 then
            table.remove(hitPositions, i)
        else
            local alpha = math.floor(255 * (1 - elapsedTime)) 
            local victim = pos.victim
            local victimPos = victim:GetAbsOrigin() + Vector3(0, 0, 50)
            local screenPos = client.WorldToScreen(victimPos)
            if screenPos then
                drawHitmarker(screenPos[1], screenPos[2], alpha)
                drawDamage(screenPos[1], screenPos[2], pos.damage, alpha)
            end
        end
    end
end

callbacks.Register("FireGameEvent", "exampleDamageLogger", damageLogger)
callbacks.Register("Draw", "drawHitmarkers", onDraw)
