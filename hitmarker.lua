local hitmarkers = {}
local mostRecentHitmarker = nil

-- SET TO FALSE TO USE 2D HITMARKERS
local prefer3 = true

-- SUMS UP DAMAGE FOR A PLAYER (RESETS AFTER FADE)
local sumDamage = true

local fadeTime = 2
local font = draw.CreateFont("Verdana", 12, 700, FONTFLAG_OUTLINE)

local function drawDamage(x, y, damage, alpha, color)
    if alpha and alpha > 15 then
        draw.SetFont(font)
        local dmg_tw, dmg_th = draw.GetTextSize(damage)
        draw.Color(color[1], color[2], color[3], alpha)
        
        -- crosshair like shape
        -- \ /
        -- / \
        draw.Line(x - 10, y - 10, x - 5, y - 5)
        draw.Line(x + 10, y + 10, x + 5, y + 5)
        draw.Line(x - 10, y + 10, x - 5, y + 5)
        draw.Line(x + 10, y - 10, x + 5, y - 5)
        draw.Text(x - (dmg_tw / 2), y + 15, damage)
    end
end

local function drawHitmarker2D(alpha, hit, color)
    local w, h = draw.GetScreenSize()
    local midw, midh = w / 2, h / 2
    local prefix = hit.heal and "+" or "-"
    drawDamage(midw, midh, prefix .. hit.damage, alpha, color)
end

local function drawHitmarker3D(x, y, alpha, hit, color)
    local prefix = hit.heal and "+" or "-"
    drawDamage(x, y, prefix .. hit.damage, alpha, color)
end

local function updateHitmarker(victim, damage, crit, heal)
    local currentTime = globals.RealTime()
    local hitmarker = hitmarkers[victim:GetIndex()]

    if hitmarker and (currentTime - hitmarker.time) <= fadeTime and sumDamage then
        hitmarker.damage = hitmarker.damage + damage
        hitmarker.time = currentTime
        hitmarker.crit = crit
        hitmarker.heal = heal
    else
        hitmarkers[victim:GetIndex()] = {
            victim = victim,
            damage = damage,
            time = currentTime,
            crit = crit,
            heal = heal
        }
    end

    mostRecentHitmarker = hitmarkers[victim:GetIndex()]
end

local function damageLogger(event)
    --client.ChatPrintf("DEBUG: " .. event:GetName())

    local ev = event:GetName()
    local localPlayer = entities.GetLocalPlayer()
    if ev == 'player_hurt' then
        local victim = entities.GetByUserID(event:GetInt("userid"))
        local attacker = entities.GetByUserID(event:GetInt("attacker"))
        local damage = event:GetInt("damageamount")
        local crit = event:GetInt("crit") == 1

        if (attacker == nil or localPlayer == nil or victim == nil or localPlayer:GetIndex() ~= attacker:GetIndex() or localPlayer:GetIndex() == victim:GetIndex()) then
            return
        end

        updateHitmarker(victim, damage, crit, false)
    elseif ev == 'player_healonhit' then
        local amount = event:GetInt("amount")
        local healed = entities.GetByUserID(event:GetInt("userid"))
        if healed then
            updateHitmarker(healed, amount, false, true)
        end
    elseif ev == 'player_healed' then
        local patient = entities.GetByUserID(event:GetInt("patient"))
        local healer = entities.GetByUserID(event:GetInt("healer"))
        local amount = event:GetInt("amount")

        if patient and localPlayer and healer and localPlayer:GetIndex() == healer:GetIndex() then
            updateHitmarker(patient, amount, false, true)
        end
    end
end

local function main()
    local currentTime = globals.RealTime()
    for playerIndex, hitmarker in pairs(hitmarkers) do
        local elapsedTime = currentTime - hitmarker.time
        if elapsedTime <= fadeTime then
            local alpha = math.floor((255 / fadeTime) * (fadeTime - elapsedTime))
            local position = hitmarker.victim:GetAbsOrigin() + Vector3(0, 0, 50)
            local color = {255, 255, 255}

            if hitmarker.crit then
                color = {255, 0, 0}
            elseif hitmarker.heal then
                color = {0, 255, 0}
            end

            if not prefer3 then
                if hitmarker == mostRecentHitmarker then
                    drawHitmarker2D(alpha, hitmarker, color)
                end
            else
                local screenPos = client.WorldToScreen(position)
                if screenPos then
                    drawHitmarker3D(screenPos[1], screenPos[2], alpha, hitmarker, color)
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
callbacks.Register("Draw", "drawHitmarkers", main)