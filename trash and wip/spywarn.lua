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


local HasNotify,Notify = pcall(require, "MenuModules/Notify")
local HasWindow,Window = pcall(require, "MenuModules/Window")
local HasCheckbox,Checkbox = pcall(require, "MenuModules/Checkbox") 
local HasButton,Button = pcall(require, "MenuModules/Button") 
local HasSlider,Slider = pcall(require, "MenuModules/Slider")
local HasDropdowns,Dropdowns = pcall(require, "MenuModules/Dropdowns")
local HasKeybind,Keybind = pcall(require, "MenuModules/Keybind")
local HasTextInput,TextInput = pcall(require, "MenuModules/TextInput")
local HasColorpicker,Colorpicker = pcall(require, "MenuModules/Colorpicker")
local HasIsland,Island = pcall(require, "MenuModules/Island")
local HasWatermark,Watermark = pcall(require, "MenuModules/Watermark")

local function unrequire(m) package.loaded[m] = nil _G[m] = nil end -- from lbox toolbox by callie

if (not(HasNotify)) then client.ChatPrintf("\x07FF0000Notify module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasWindow)) then client.ChatPrintf("\x07FF0000Window module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasCheckbox)) then client.ChatPrintf("\x07FF0000Checkbox module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasButton)) then client.ChatPrintf("\x07FF0000Button module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasSlider)) then client.ChatPrintf("\x07FF0000Slider module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasDropdowns)) then client.ChatPrintf("\x07FF0000Dropdowns module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasKeybind)) then client.ChatPrintf("\x07FF0000Keybind module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasTextInput)) then client.ChatPrintf("\x07FF0000TextInput module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasColorpicker)) then client.ChatPrintf("\x07FF0000Colorpicker module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasIsland)) then client.ChatPrintf("\x07FF0000Island module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end
if (not(HasWatermark)) then client.ChatPrintf("\x07FF0000Watermark module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end

collectgarbage("collect") -- band aid fix

engine.PlaySound("hl1/fvox/activated.wav")
Notify:Add("PMLib loaded successfully!", 3, {110, 250, 115, 255}, true)

if HasNotify then
    if (client.GetConVar("developer") ~= 0) then
        client.SetConVar( "developer", 0) end
end

local function OnUnload() 
    unrequire("MenuModules/Notify")
    unrequire("MenuModules/Window")
    unrequire("MenuModules/Checkbox")
    unrequire("MenuModules/Button")
    unrequire("MenuModules/Slider")
    unrequire("MenuModules/Dropdowns")
    unrequire("MenuModules/Keybind")
    unrequire("MenuModules/TextInput")
    unrequire("MenuModules/Colorpicker")
    unrequire("MenuModules/Island")
    unrequire("MenuModules/Watermark")

    engine.PlaySound("hl1/fvox/deactivated.wav")
end

MENU_OPEN = true
local lastToggleTime = 0
local function toggleMenu()
    local currentTime = globals.RealTime()
    if currentTime - lastToggleTime >= 0.1 then
        MENU_OPEN = not MENU_OPEN

        collectgarbage("collect")
        -- band aid fix, will lag the game for a split second
        -- if you are using other luas with memleaks
        
        lastToggleTime = currentTime
    end
end

local function checkMenu() -- credits: muqa
    if input.IsButtonPressed(KEY_END) or input.IsButtonPressed(KEY_INSERT) or input.IsButtonPressed(KEY_F11) then 
        toggleMenu()
    end
end

BlockInput = false
Dropdown_open = nil
KeyTable={[1]="0",[2]="1",[3]="2",[4]="3",[5]="4",[6]="5",[7]="6",[8]="7",[9]="8",[10]="9",[11]="a",[12]="b",[13]="c",[14]="d",[15]="e",[16]="f",[17]="g",[18]="h",[19]="i",[20]="j",[21]="k",[22]="l",[23]="m",[24]="n",[25]="o",[26]="p",[27]="q",[28]="r",[29]="s",[30]="t",[31]="u",[32]="v",[33]="w",[34]="x",[35]="y",[36]="z",[37]="num 0",[38]="num 1",[39]="num 2",[40]="num 3",[41]="num 4",[42]="num 5",[43]="num 6",[44]="num 7",[45]="num 8",[46]="num 9",[47]="num divide",[48]="num multiply",[49]="num minus",[50]="num plus",[51]="num enter",[52]="num decimal",[53]="lbracket",[54]="rbracket",[55]="semicolon",[56]="apostrophe",[57]="backquote",[58]="comma",[59]="period",[60]="slash",[61]="backslash",[62]="minus",[63]="equal",[64]="enter",[65]="space",[66]="backspace",[67]="tab",[68]="caps lock",[69]="num lock",[70]="escape",[71]="scroll lock",[72]="insert",[73]="delete",[74]="home",[75]="end",[76]="pageup",[77]="pagedown",[78]="break",[79]="lshift",[80]="rshift",[81]="lalt",[82]="ralt",[83]="lcontrol",[84]="rcontrol",[85]="lwin",[86]="rwin",[87]="app",[88]="up",[89]="left",[90]="down",[91]="right",[92]="f1",[93]="f2",[94]="f3",[95]="f4",[96]="f5",[97]="f6",[98]="f7",[99]="f8",[100]="f9",[101]="f10",[102]="f11",[103]="f12",[104]="caps lock toggle",[105]="num lock toggle",[106]="scroll lock toggle",[107]="mouse1",[108]="mouse2",[109]="mouse3",[110]="mouse4",[111]="mouse5",[112]="mousewheel up",[113]="mousewheel down"}
InputTable={[1]="0",[2]="1",[3]="2",[4]="3",[5]="4",[6]="5",[7]="6",[8]="7",[9]="8",[10]="9",[11]="a",[12]="b",[13]="c",[14]="d",[15]="e",[16]="f",[17]="g",[18]="h",[19]="i",[20]="j",[21]="k",[22]="l",[23]="m",[24]="n",[25]="o",[26]="p",[27]="q",[28]="r",[29]="s",[30]="t",[31]="u",[32]="v",[33]="w",[34]="x",[35]="y",[36]="z",[37]="0",[38]="1",[39]="2",[40]="3",[41]="4",[42]="5",[43]="6",[44]="7",[45]="8",[46]="9",[47]="/",[48]="*",[49]="-",[50]="+",[53]="[",[54]="]",[55]=";",[56]="'",[57]="`",[58]=",",[59]=".",[60]="/",[61]="\\",[62]="-",[63]="=",[65]=" ",[67]="    "}

Values = {
    show_debug_info = true,
    spywarn_enable = true,
    spywarn_callout = false,
    spywarn_activation_radius = 500,
    spywarn_text = "Spy within !dist! units",
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

    test_textinput = ""
}

CURRENT_TAB = "tab1"
Tabs = {
    "tab1",
    "tab2"
}

------------------------------------------------------------- UTILS -------------------------------------------------------------

function GetPressedKey()
    for i = 1, 113 do 
        if input.IsButtonPressed(i) then
            if i ~= 107 and i ~= 75 and i ~= 72 and i ~= 108 then 
                return i
            end
        end
    end
end

function Round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

function IsMouseInBounds(x,y,x2,y2)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    if mX >= x and mX <= x2 and mY >= y and mY <= y2 then
        return true 
    end
    return false
end

------------------------------------------------------------- DEBUG -------------------------------------------------------------

local function getMemoryUsage()
    local mem = collectgarbage("count") / 1024
    if mem > 800 then
        collectgarbage("collect")
        mem = collectgarbage("count") / 1024
        Notify:Add("Garbage collected", 10.0, {255, 90, 90, 255}, true)
    end
    return mem
end

local dbg_font = draw.CreateFont("Lucida Console", 10, 0, 512)
local function draw_debug()
    if not Values.show_debug_info then return end
    draw.SetFont(dbg_font)
    draw.Color(230, 230, 180, 255)

    local dbgx = 10
    local dbgy = 200
    local i = 1

    draw.Text(dbgx, dbgy - 12, "Memory usage: " .. string.format("%.2f", getMemoryUsage()) .. " MB")
    draw.Text(dbgx, dbgy, "Values:")
    for key, value in pairs(Values) do
        
        if type(value) == "table" then
            local entries = {}
            for _, entry in ipairs(value) do
                table.insert(entries, tostring(entry))
            end
            local entries_str = "{" .. table.concat(entries, ", ") .. "}"
            
            draw.Text(dbgx, dbgy + i * 12, key .. " - " .. entries_str)
        else
            draw.Text(dbgx, dbgy + i * 12, key .. " - " .. tostring(value))
        end
        
        i = i + 1
    end
end
------------------------------------------------------------- MENU -------------------------------------------------------------

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
                client.Command("voicemenu 1 1", 1)
                delays.spy_warning = globals.RealTime()
            end
        end
    end
end

local screenx, screeny = draw.GetScreenSize()
local w_x, w_y = Round(screenx*0.8), Round(screeny*0.4)
local w_w, w_h = 320, 400

local function UpdateKeybinds()
    Keybind:UpdateKeybindValues()
end


local function menu()
    local dropdowns = {}
    local colorpickers = {}

    draw_debug()

    --Watermark:DrawWatermark()
    --Keybind:KeybindIndicator()
    spywarn()

    if MENU_OPEN then
        w_x, w_y = Window:SetupWindow("mainmenu", w_x - w_w//2, w_y, w_w, w_h, true, true)

        if CURRENT_TAB == "tab1" then
            Island:Island("test", w_x + 154, 140, w_y + 45, w_y + 125)
            Checkbox:Checkbox(w_x + 160, w_y + 60, "show_debug_info", "show debug info")
            Checkbox:Checkbox(w_x + 20, w_y + 60, "spywarn_enable", "enable spy warning")
            Checkbox:Checkbox(w_x + 20, w_y + 80, "spywarn_callout", "callout on spy")
            Slider:Slider(w_x + 20, w_y + 110, 130, 8, "spywarn_activation_radius", 50, 1000, "activation radius")
            TextInput:TextInput(w_x + 20, w_y + 140, 130, 20, "spywarn_text", "warning text")
            --table.insert(dropdowns, {w_x + 20, w_y + 140, 130, 20, "test_dropdown1", {"option 1", "option 2", "option 3"}, "dropdown 5"})
            --Button:Button(w_x + 20, w_y + 170, 130, 20, "button 6", function() Notify:Add("Hi!") end)
            --table.insert(dropdowns, {w_x + 20, w_y + 210, 130, 20, "test_dropdown2", {"option 1", "option 2", "option 3"}, "dropdown 7"})
            --table.insert(dropdowns, {w_x + 20, w_y + 250, 130, 20, "test_multidropdown1", {"option 1", "option 2", "option 3"}, "multidropdown 8"})
            --Keybind:Keybind(w_x + 20, w_y + 290, 130, 20, "test_keybind1", "keybind 9", false)
            --Keybind:Keybind(w_x + 20, w_y + 340, 130, 20, "test_keybind2", "keybind 10", true)
            --table.insert(colorpickers, {w_x + 275, w_y + 60, 16, 6, "testcolor1"})
            --table.insert(colorpickers, {w_x + 275, w_y + 88, 16, 6, "testcolor2"})
            --TextInput:TextInput(w_x + 160, w_y + 100, 130, 20, "test_textinput", "text input")
        end

        -- this is really dumb but i dont want to recode literally everything just to make specific items draw on top
        table.sort(dropdowns, function(a, b)
            return a[2] > b[2]
        end)
        table.sort(colorpickers, function(a, b)
            return a[2] > b[2]
        end)
        for _, d in ipairs(dropdowns) do
            Dropdowns:Dropdown(d[1], d[2], d[3], d[4], d[5], d[6], d[7])
        end
        for _, c in ipairs(colorpickers) do
            Colorpicker:Colorpicker(c[1], c[2], c[3], c[4], c[5])
        end

        if input.IsButtonPressed(MOUSE_LEFT) then
            BlockInput = true
        end
    end
end

------------------------------------------------------------- CALLBACKS -------------------------------------------------------------

callbacks.Unregister("CreateMove", "UpdateKeybinds")
callbacks.Register("CreateMove", "UpdateKeybinds", UpdateKeybinds)

callbacks.Unregister("Unload", "PMLib_unload")
callbacks.Register("Unload", "PMLib_unload", OnUnload)

callbacks.Unregister("Draw", "checkMenu")
callbacks.Register("Draw", "checkMenu", checkMenu)

callbacks.Unregister("Draw", "drawNotifs")
callbacks.Register("Draw", "drawNotifs", function() Notify:Think() end)

callbacks.Unregister("Draw", "draw_menu")
callbacks.Register("Draw", "draw_menu", menu)