--- ##### OPTIONS ##### ---
local fontsize = 16
local padding = 4 -- in px
local duration = 2  -- in sec
local animspeed = 0.15 -- in sec
local toastcap = 15
local accentcolor = {255, 101, 101}
local textcolor = {255, 255, 255}
local fadecolor = {54, 54, 54}
--- ################### ---

local toastfont = draw.CreateFont('Tahoma', fontsize, 600, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)
local toastList = {}

local Toasts = {} -- so you can pcall it from other scripts

engine.PlaySound("ui/buttonclick.wav")

-- so i can trigger new toasts easily
function Toasts:Add(text)
    if #toastList < toastcap then
        table.insert(toastList, {text = text, time = globals.RealTime()})
    else
        table.remove(toastList, 1)  -- remove oldest toasts if the cap was hit
        table.insert(toastList, {text = text, time = globals.RealTime()})
    end
end

function Toasts:Think()

    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end

    local w, h = draw.GetScreenSize()
    local drawy = 0
    local initialOffsetX = -150 -- starting x pos & fade length

    draw.SetFont(toastfont)

--  for i = #toastList, 1, -1 do
--  replace "for i, toast in ipairs(toastList)" with this to make the toasts appear in reverse order

    for i, toast in ipairs(toastList) do
        local toast = toastList[i]
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

Toasts:Add("Toasts loaded!")
callbacks.Register("Draw", "drawToasts", Toasts.Think)

local function damageLogger(event)

    if (event:GetName() == 'player_hurt') then
        local localPlayer = entities.GetLocalPlayer()
        local victim = entities.GetByUserID(event:GetInt("userid"))
        local crit = event:GetInt("crit") == 1

        local minicrit = event:GetInt("minicrit") == 1
        local health = event:GetInt("health")
        local attacker = entities.GetByUserID(event:GetInt("attacker"))
        local damage = event:GetInt("damageamount")
        local critstr = ""

        if (attacker == nil or localPlayer == nil or victim == nil or localPlayer:GetIndex() ~= attacker:GetIndex() or localPlayer:GetIndex() == victim:GetIndex()) then
            return
        end

        local max_health = victim:GetMaxHealth()
        if minicrit then critstr = "(minicrit)" end
        if crit and not minicrit then critstr = "(crit)" end

        local message = "You hit " .. victim:GetName() .. " for " .. damage .. " damage "
        if health <= 0 then
            message = message .. "(dead) "
        else
            message = message .. "(" .. health .. " / " .. max_health .. ") "
        end
        message = message .. critstr
      
        Toasts:Add(message)
    end
end

callbacks.Register("FireGameEvent", "exampledamageLogger", damageLogger)

return Toasts
