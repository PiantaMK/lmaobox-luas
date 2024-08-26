---@diagnostic disable: param-type-mismatch
--[[
PMLib by pianta

CREDITS:
font: https://github.com/OneshotGH/supremacy/blob/9d56ba52f4ab380f48ca3f066c9c5009ea2bb74f/render.cpp#L13
setupwindow: https://github.com/OneshotGH/supremacy/blob/9d56ba52f4ab380f48ca3f066c9c5009ea2bb74f/form.cpp#L25
slider: https://github.com/Muqa1/Muqa-LBOX-pastas/blob/171ae1344b4ca5699da5283ebb7015294dfb8d81/Release%20misc%20tools.lua#L380
module logic: https://github.com/KaylinOwO/LMAOBOXToolboxLUA/blob/main/Toolbox.lua

VISUALS INSPIRED BY:
 - muqa's misc tools (https://i.postimg.cc/gkvPmWCG/misc-tools.png)
 - gamesense (https://i.postimg.cc/7ZwrLR40/gamesense.jpg)
 - supremacy (https://i.postimg.cc/SxdFYGQ5/supremacy.png)
 - onetap v1 (https://i.postimg.cc/bNXj7JF6/onetap-v1.png)
]]

-- minified loading logic (do not remove)
local a,Utils=pcall(require,"MenuModules/Utils")local c,Notify=pcall(require,"MenuModules/Notify")local e,Window=pcall(require,"MenuModules/Window")local g,Checkbox=pcall(require,"MenuModules/Checkbox")local i,Button=pcall(require,"MenuModules/Button")local k,Slider=pcall(require,"MenuModules/Slider")local m,Dropdowns=pcall(require,"MenuModules/Dropdowns")local o,Keybind=pcall(require,"MenuModules/Keybind")local q,TextInput=pcall(require,"MenuModules/TextInput")local s,Colorpicker=pcall(require,"MenuModules/Colorpicker")local u,Island=pcall(require,"MenuModules/Island")local w,Watermark=pcall(require,"MenuModules/Watermark")local function y(z)package.loaded[z]=nil;_G[z]=nil end;local function A(B,C)if not C then client.ChatPrintf("\x07FF0000"..B.." module failed to load!")engine.PlaySound("common/bugreporter_failed.wav")return false end;return true end;if not A("Utils",a)then return end;if not A("Notify",c)then return end;if not A("Window",e)then return end;if not A("Checkbox",g)then return end;if not A("Button",i)then return end;if not A("Slider",k)then return end;if not A("Dropdowns",m)then return end;if not A("Keybind",o)then return end;if not A("TextInput",q)then return end;if not A("Colorpicker",s)then return end;if not A("Island",u)then return end;if not A("Watermark",w)then return end;collectgarbage("collect")engine.PlaySound("hl1/fvox/activated.wav")Notify:Add("PMLib loaded successfully!",3,{110,250,115,255},true)if c then if client.GetConVar("developer")~=0 then client.SetConVar("developer",0)end end;local function OnUnload()y("MenuModules/Utils")y("MenuModules/Notify")y("MenuModules/Window")y("MenuModules/Checkbox")y("MenuModules/Button")y("MenuModules/Slider")y("MenuModules/Dropdowns")y("MenuModules/Keybind")y("MenuModules/TextInput")y("MenuModules/Colorpicker")y("MenuModules/Island")y("MenuModules/Watermark")engine.PlaySound("hl1/fvox/deactivated.wav")end
-- unminified: https://pastebin.com/raw/7xmrmaB7

---------------------------------------------------------- VARIABLES -------------------------------------------------------------

MENU_OPEN = true
BlockInput = false
Dropdown_open = nil
Values = {
    show_debug_info = true, -- hardcoded name
    test_checkbox2 = true,
    test_checkbox3 = true,
    testvalue4 = 5,
    test_dropdown1 = 2,
    test_dropdown2 = 2,
    test_multidropdown1 = {false, true, false},
    test_keybind1 = nil,
    test_keybind2 = nil,

    testcolor1_r = 255,
    testcolor1_g = 255,
    testcolor1_b = 255,

    testcolor2_r = 255,
    testcolor2_g = 255,
    testcolor2_b = 255,

    test_textinput = "",
}

CURRENT_TAB = "tab1"
Tabs = {
    "tab1",
    "debug"
}

--[[
local extending = true
local lastCommandTime = 0
local cooldown = 0.25
local previousExtendingState = nil

local function extendSpec()
    local bind = Keybind_states["test_keybind2"]
    if not bind then return end
    local t = globals.RealTime()
    if t - lastCommandTime < cooldown then
        return
    end

    local me = entities.GetLocalPlayer()
    -- toggle check
    if bind.toggle then
        extending = bind.active
    end

    if extending ~= previousExtendingState then
        if extending then
            client.Command("menuopen", true)
            Notify:Add("infinite spec enabled")
        else
            client.Command("menuclosed", true)
            Notify:Add("infinite spec disabled")
        end
        previousExtendingState = extending
    end

    lastCommandTime = t
end

callbacks.Unregister("Draw", "extendSpec")
callbacks.Register("Draw", "extendSpec", extendSpec)

local delays = {
    spy_warning = 0
}

local function IsVisible(player, localPlayer)
    local me = localPlayer
    local source = me:GetAbsOrigin() + me:GetPropVector( "localdata", "m_vecViewOffset[0]" );
    local destination = player:GetAbsOrigin() + Vector3(0,0,75)
    local trace = engine.TraceLine( source, destination, CONTENTS_SOLID | CONTENTS_GRATE | CONTENTS_MONSTER );
    if (trace.entity ~= nil) then
        if trace.entity == player then 
            return true 
        end
    end
    return false
end

-- TODO: make it look more like from fedware
-- https://github.com/Fedoraware/Fedoraware/blob/main/Fedoraware/Fedoraware-TF2/src/Features/SpyWarning/SpyWarning.cpp
local font = draw.CreateFont("Tahoma", 12, 400, FONTFLAG_DROPSHADOW)
local function spywarn()
    if Values.spywarn_enable then 
        local players = entities.FindByClass("CTFPlayer") 
        local sW, sH = draw.GetScreenSize()
        draw.SetFont(font)
        
        local closestSpy = nil
        local closestDistance = math.huge
        
        for i, spy in ipairs(players) do
            if spy:GetPropInt("m_iClass") == TF2_Spy then 
                local localPlayer = entities.GetLocalPlayer()
                local spy_pos = spy:GetAbsOrigin()
                local local_pos = localPlayer:GetAbsOrigin()
                local distance = vector.Distance(spy_pos, local_pos)
                
                if (distance < Values.spywarn_activation_radius) and spy:IsAlive() and spy:GetTeamNumber() ~= localPlayer:GetTeamNumber() and not spy:IsDormant() and IsVisible(spy, localPlayer) then
                    if distance < closestDistance then
                        closestSpy = spy
                        closestDistance = distance
                    end
                end
            end
        end
        
        if closestSpy then
            draw.Color(250, 85, 85, 255)
            local warning = Values.spywarn_text:gsub("!dist!", math.floor(closestDistance))
            local length, height = draw.GetTextSize(warning)
            draw.Text(math.floor((sW * 0.5) - (length * 0.5)), math.floor(sH * 0.6), warning)
            
            if Values.spywarn_callout and (globals.RealTime() > (delays.spy_warning + 2.5)) then 
                client.Command("voicemenu 1 1", true) -- Spy!
                delays.spy_warning = globals.RealTime()
            end
        end
    end
end

callbacks.Unregister("Draw", "spywarn")
callbacks.Register("Draw", "spywarn", spywarn)]]--
------------------------------------------------------------- MENU ---------------------------------------------------------------

local screenx, screeny = draw.GetScreenSize()
local w_x, w_y = Round(screenx*0.8), Round(screeny*0.4)
local w_w, w_h = 320, 400

local function menu()
    local dropdowns = {}
    local colorpickers = {}

    Utils:DrawDebugInfo(true)

    --Watermark:DrawWatermark()
    --Keybind:KeybindIndicator()

    if MENU_OPEN then
        w_x, w_y = Window:SetupWindow("mainmenu", w_x - w_w//2, w_y, w_w, w_h, true, true)

        if CURRENT_TAB == "tab1" then
            Checkbox:Checkbox(w_x + 20, w_y + 60, "test_checkbox2", "checkbox 2")
            Checkbox:Checkbox(w_x + 20, w_y + 80, "test_checkbox3", "checkbox 3")
            Slider:Slider(w_x + 20, w_y + 110, 130, 8, "testvalue4", 0, 50, "slider 4")
            table.insert(dropdowns, {w_x + 20, w_y + 140, 130, 20, "test_dropdown1", {"option 1", "option 2", "option 3"}, "dropdown 5"})
            Button:Button(w_x + 20, w_y + 170, 130, 20, "button 6", function() Notify:Add("Hi!") end)
            table.insert(dropdowns, {w_x + 20, w_y + 210, 130, 20, "test_dropdown2", {"option 1", "option 2", "option 3"}, "dropdown 7"})
            table.insert(dropdowns, {w_x + 20, w_y + 250, 130, 20, "test_multidropdown1", {"option 1", "option 2", "option 3"}, "multidropdown 8"})
            Keybind:Keybind(w_x + 20, w_y + 290, 130, 20, "test_keybind1", "keybind 9", false)
            Keybind:Keybind(w_x + 20, w_y + 340, 130, 20, "test_keybind2", "keybind 10", true, false, false)
            Island:Island("test island", w_x + 154, 140, w_y + 45, w_y + 140)
            table.insert(colorpickers, {w_x + 270, w_y + 65, 16, 6, "testcolor1"})
            table.insert(colorpickers, {w_x + 270, w_y + 105, 16, 6, "testcolor2"})
            TextInput:TextInput(w_x + 160, w_y + 75, 130, 20, "test_textinpt", "text input")
            TextInput:TextInput(w_x + 160, w_y + 115, 130, 20, "test_textinput", "text input2")
        end
        if CURRENT_TAB == "debug" then
            Island:Island("debug", w_x + 15, 140, w_y + 45, w_y + 125)
            Checkbox:Checkbox(w_x + 20, w_y + 70, "show_debug_info", "show debug info")
        end

        -- this is really dumb but i dont want to recode literally everything just to make specific items draw on top
        table.sort(dropdowns,function(a,b)return a[2]>b[2]end)table.sort(colorpickers,function(a,b)return a[2]>b[2]end)for c,d in ipairs(dropdowns)do Dropdowns:Dropdown(d[1],d[2],d[3],d[4],d[5],d[6],d[7])end;for c,e in ipairs(colorpickers)do Colorpicker:Colorpicker(e[1],e[2],e[3],e[4],e[5])end
        -- unminified: https://pastebin.com/raw/70rwheck

        if input.IsButtonPressed(MOUSE_LEFT) then
            BlockInput = true
        end
    end
end

callbacks.Unregister("Draw", "draw_menu")
callbacks.Register("Draw", "draw_menu", menu)

--------------------------------------------- OTHER CALLBACKS (DO NOT REMOVE) ---------------------------------------------------

callbacks.Unregister("Unload", "PMLib_unload")
callbacks.Register("Unload", "PMLib_unload", OnUnload)

callbacks.Unregister("CreateMove", "PMLib_UpdateKeybinds")
callbacks.Register("CreateMove", "PMLib_UpdateKeybinds", function()
    Keybind:UpdateKeybindValues()
end) -- CreateMove

callbacks.Unregister("Draw", "PMLib_Others")
callbacks.Register("Draw", "PMLib_Others", function()
    Utils:CheckMenu()
    Notify:Think()
end) -- Draw