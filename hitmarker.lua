local hitmarkers = {}
local mostRecentHitmarker = nil

local prefer = "3d" -- "2d" or "3d"
local fadeTime = 2
local font = draw.CreateFont("Verdana", 12, 700, FONTFLAG_OUTLINE)

local function drawDamage(x, y, hitCrit, damage, alpha)
    if alpha and alpha > 15 then
        draw.SetFont(font)
        local dmg_tw, dmg_th = draw.GetTextSize(damage)
        if hitCrit then
            draw.Color(255, 50, 50, alpha)
        else
            draw.Color(255, 255, 255, alpha)
        end
        draw.Text(x - (dmg_tw / 2), y + 15, damage)
    end
end

local function drawHitmarker2D(alpha, hitCrit, hitDamage)
    local w, h = draw.GetScreenSize()
    local midw, midh = w / 2, h / 2
    if alpha and alpha > 15 then
        if hitCrit then
            draw.Color(255, 50, 50, alpha)
        else
            draw.Color(255, 255, 255, alpha)
        end
        draw.Line(midw - 10, midh - 10, midw - 5, midh - 5)
        draw.Line(midw + 10, midh + 10, midw + 5, midh + 5)
        draw.Line(midw - 10, midh + 10, midw - 5, midh + 5)
        draw.Line(midw + 10, midh - 10, midw + 5, midh - 5)
        drawDamage(midw, midh, hitCrit, "-" .. hitDamage, alpha)
    end
end

local function drawHitmarker3D(x, y, alpha, hitCrit, hitDamage)
    if alpha and alpha > 15 then
        if hitCrit then
            draw.Color(255, 50, 50, alpha)
        else
            draw.Color(255, 255, 255, alpha)
        end
        draw.Line(x - 10, y - 10, x - 5, y - 5)
        draw.Line(x + 10, y + 10, x + 5, y + 5)
        draw.Line(x - 10, y + 10, x - 5, y + 5)
        draw.Line(x + 10, y - 10, x + 5, y - 5)
        drawDamage(x, y, hitCrit, "-" .. hitDamage, alpha)
    end
end

local function damageLogger(event)
    if (event:GetName() == 'player_hurt') then
        local localPlayer = entities.GetLocalPlayer()
        local victim = entities.GetByUserID(event:GetInt("userid"))
        local attacker = entities.GetByUserID(event:GetInt("attacker"))
        local damage = event:GetInt("damageamount")
        local crit = event:GetInt("crit") == 1

        if (attacker == nil or localPlayer == nil or victim == nil or localPlayer:GetIndex() ~= attacker:GetIndex() or localPlayer:GetIndex() == victim:GetIndex()) then
            return
        end

        hitmarkers[victim:GetIndex()] = {
            victim = victim,
            damage = damage,
            time = globals.RealTime(),
            crit = crit
        }
        mostRecentHitmarker = hitmarkers[victim:GetIndex()]
    end
end

local function onDraw()
    local currentTime = globals.RealTime()
    for playerIndex, hitmarker in pairs(hitmarkers) do
        local elapsedTime = currentTime - hitmarker.time
        if elapsedTime <= fadeTime then
            local alpha = math.floor((255 / fadeTime) * (fadeTime - elapsedTime))
            local position = hitmarker.victim:GetAbsOrigin() + Vector3(0, 0, 50)
            if prefer == "2d" then
                if hitmarker == mostRecentHitmarker then
                    drawHitmarker2D(alpha, hitmarker.crit, hitmarker.damage)
                end
            elseif prefer == "3d" then
                local screenPos = client.WorldToScreen(position)
                if screenPos then
                    drawHitmarker3D(screenPos[1], screenPos[2], alpha, hitmarker.crit, hitmarker.damage)
                end
            end
        else
            hitmarkers[playerIndex] = nil
        end
    end
end

callbacks.Unregister("FireGameEvent", "damageLogger")
callbacks.Unregister("Draw", "drawHitmarkers")

callbacks.Register("FireGameEvent", "damageLogger", damageLogger)
callbacks.Register("Draw", "drawHitmarkers", onDraw)