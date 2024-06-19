--- ##### OPTIONS ##### ---
local fontsize = 14
local duration = 2  -- in sec
local animspeed = 0.15 -- in sec
local accentcolor = {255, 101, 101}
local textcolor = {255, 255, 255}
local fadecolor = {54, 54, 54}
local padding = 4 -- in px
--- ################### ---

local toastfont = draw.CreateFont('Tahoma', -11, 400, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)
local toastList = {}

-- so i can trigger new toasts easily
function toasts(text)
    table.insert(toastList, {text = text, time = globals.RealTime()})
end

function drawToasts()
    local w, h = draw.GetScreenSize()
    local drawy = 0
    local initialOffsetX = -150 -- starting x pos & fade length

    draw.SetFont(toastfont)


--  for i = #toastList, 1, -1 do
--      local toast = toastList[i]
-- replace "for i, toast in ipairs(toastList)" to make the toasts appear in reverse order

    for i, toast in ipairs(toastList) do
        local timeElapsed = globals.RealTime() - toast.time
        if timeElapsed < duration then
            local fade = 1 - (timeElapsed / duration)  -- fade out effect
            local alpha = math.floor(255 * fade)
            local animationProgress = math.min(1, timeElapsed / animspeed)
            local animatedX = initialOffsetX + (1 - initialOffsetX) * animationProgress
            animatedX = math.floor(animatedX)

            if alpha >= 2 then
                draw.Color(fadecolor[1], fadecolor[2], fadecolor[3], 255)
                draw.FilledRectFade(animatedX, drawy, animatedX - initialOffsetX, drawy + fontsize + padding, alpha, 0, true)

                draw.Color(textcolor[1], textcolor[2], textcolor[3], alpha)
                draw.Text(animatedX + 5, drawy + (padding // 2), toast.text)
                draw.Color(accentcolor[1], accentcolor[2], accentcolor[3], alpha)
                draw.Line(animatedX, drawy, animatedX, drawy + fontsize + padding - 1)

                drawy = drawy + fontsize + padding
            end
        else
            table.remove(toastList, i)
        end
    end
end

toasts("Toasts loaded!")
callbacks.Register("Draw", "drawToasts", drawToasts)

local function damageLogger(event)

    if (event:GetName() == 'player_hurt') then
        local localPlayer = entities.GetLocalPlayer()
        local victim = entities.GetByUserID(event:GetInt("userid"))
        local health = event:GetInt("health")
        local attacker = entities.GetByUserID(event:GetInt("attacker"))
        local damage = event:GetInt("damageamount")

        if (attacker == nil or localPlayer:GetIndex() ~= attacker:GetIndex()) then
            return
        end

        local message = victim:GetName() .. " -" .. damage .. " hp (" .. health .. " left)"
        
        toasts(message)
    end
end

callbacks.Register("FireGameEvent", "exampledamageLogger", damageLogger)
