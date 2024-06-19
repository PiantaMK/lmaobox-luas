
--- ##### OPTIONS ##### ---
local fontsize = 14
local duration = 2  -- in seconds
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

    draw.SetFont(toastfont)
    for i, toast in ipairs(toastList) do
	
        local timeElapsed = globals.RealTime() - toast.time
		
        if timeElapsed < duration then

            local fade = 1 - (timeElapsed / duration)  -- fade out effect
			alpha = math.floor(255 * fade)
			
			if alpha >= 2 then
                draw.Color(54, 54, 54, 255)
                draw.FilledRectFade(1, drawy, 150, drawy + fontsize + padding, 200, 0, true)

                draw.Color(255, 255, 255, alpha)
				draw.Text(5, drawy + (padding // 2), toast.text)
                draw.Color(255, 101, 101, alpha)
				draw.Line(0, drawy, 0, drawy + fontsize + padding - 1)

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


--[[

local myfont = draw.CreateFont( "verdana", 2 ^ 4, 800, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE | FONTFLAG_DROPSHADOW )

local w, h = draw.GetScreenSize()
local cw, ch = w // 2, h // 2 + 15

function toasts(text)

	text = "hi"

	toastsdrawn = 0
	constx = 0
	drawy = toastsdrawn*15
	
	draw.SetFont(myfont)
	draw.Color(255, 255, 255, 255)

	
	draw.Color(255, drawy, 0, 255)
	draw.Line(constx, drawy, 0, drawy + 15)

	tw, th = draw.GetTextSize( text )
	draw.Text( 5, 0 + drawy, text )
end

callbacks.Register("Draw", "draw", toasts)
]]--