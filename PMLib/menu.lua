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

! UNFINISHED, PLEASE THINK TWICE ABOUT USING IT !
]]

local HasNotify,Notify = pcall(require, "MenuModules/Notify")
--local HasKeybind,Keybind = pcall(require, "MenuModules/Keybind")
--local HasWatermark,Watermark = pcall(require, "MenuModules/Watermark")

collectgarbage("collect") -- band aid fix

engine.PlaySound("hl1/fvox/activated.wav")
Notify:Add("PMLib loaded successfully!", 3, {110, 250, 115, 255}, true)

if HasNotify then
    if (client.GetConVar("developer") ~= 0) then
        client.SetConVar( "developer", 0) end
end

local function OnUnload()
    Notify = nil
    engine.PlaySound("hl1/fvox/deactivated.wav")
end

-- local Color = draw.Color
-- local FilledRect = draw.FilledRect
-- local OutlinedRect = draw.OutlinedRect
-- local FilledRectFade = draw.FilledRectFade
-- local Text = draw.Text
-- local SetFont = draw.SetFont
-- local GetTextSize = draw.GetTextSize
-- local CreateFont = draw.CreateFont
-- local GetScreenSize = draw.GetScreenSize
-- local Line = draw.Line

---------------------------------------------------------- VARIABLES -------------------------------------------------------------

local KeyTable={[1]="0",[2]="1",[3]="2",[4]="3",[5]="4",[6]="5",[7]="6",[8]="7",[9]="8",[10]="9",[11]="a",[12]="b",[13]="c",[14]="d",[15]="e",[16]="f",[17]="g",[18]="h",[19]="i",[20]="j",[21]="k",[22]="l",[23]="m",[24]="n",[25]="o",[26]="p",[27]="q",[28]="r",[29]="s",[30]="t",[31]="u",[32]="v",[33]="w",[34]="x",[35]="y",[36]="z",[37]="num 0",[38]="num 1",[39]="num 2",[40]="num 3",[41]="num 4",[42]="num 5",[43]="num 6",[44]="num 7",[45]="num 8",[46]="num 9",[47]="num divide",[48]="num multiply",[49]="num minus",[50]="num plus",[51]="num enter",[52]="num decimal",[53]="lbracket",[54]="rbracket",[55]="semicolon",[56]="apostrophe",[57]="backquote",[58]="comma",[59]="period",[60]="slash",[61]="backslash",[62]="minus",[63]="equal",[64]="enter",[65]="space",[66]="backspace",[67]="tab",[68]="caps lock",[69]="num lock",[70]="escape",[71]="scroll lock",[72]="insert",[73]="delete",[74]="home",[75]="end",[76]="pageup",[77]="pagedown",[78]="break",[79]="lshift",[80]="rshift",[81]="lalt",[82]="ralt",[83]="lcontrol",[84]="rcontrol",[85]="lwin",[86]="rwin",[87]="app",[88]="up",[89]="left",[90]="down",[91]="right",[92]="f1",[93]="f2",[94]="f3",[95]="f4",[96]="f5",[97]="f6",[98]="f7",[99]="f8",[100]="f9",[101]="f10",[102]="f11",[103]="f12",[104]="caps lock toggle",[105]="num lock toggle",[106]="scroll lock toggle",[107]="mouse1",[108]="mouse2",[109]="mouse3",[110]="mouse4",[111]="mouse5",[112]="mousewheel up",[113]="mousewheel down"}
-- for keybinds
local InputTable={[1]="0",[2]="1",[3]="2",[4]="3",[5]="4",[6]="5",[7]="6",[8]="7",[9]="8",[10]="9",[11]="a",[12]="b",[13]="c",[14]="d",[15]="e",[16]="f",[17]="g",[18]="h",[19]="i",[20]="j",[21]="k",[22]="l",[23]="m",[24]="n",[25]="o",[26]="p",[27]="q",[28]="r",[29]="s",[30]="t",[31]="u",[32]="v",[33]="w",[34]="x",[35]="y",[36]="z",[37]="0",[38]="1",[39]="2",[40]="3",[41]="4",[42]="5",[43]="6",[44]="7",[45]="8",[46]="9",[47]="/",[48]="*",[49]="-",[50]="+",[53]="[",[54]="]",[55]=";",[56]="'",[57]="`",[58]=",",[59]=".",[60]="/",[61]="\\",[62]="-",[63]="=",[65]=" ",[67]="    "}
-- for text input

local BlockInput = false
local Dropdown_open = nil
local Values = {
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

local globalFont = draw.CreateFont("Tahoma", 12, 400, FONTFLAG_DROPSHADOW)

---@param x number
---@param y number
---@param x2 number
---@param y2 number
local function IsMouseInBounds(x,y,x2,y2)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    if mX >= x and mX <= x2 and mY >= y and mY <= y2 then
        return true 
    end
    return false
end

local function GetPressedKey()
    for i = 1, 113 do 
        if input.IsButtonPressed(i) then
            if i ~= 107 and i ~= 75 and i ~= 72 and i ~= 108 then 
                return i
            end
        end
    end
end

---@param num number
local function round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

local idcounter = 0
function GetID()
    idcounter = idcounter + 1
    return idcounter
end

local items = {}

-- state vars etc. --

-- colorpicker --
local picker_state = {}
-----------------

---- slider -----
local slider_state = {}
-----------------

--- textinput ---
local keyHeld = {}
local textinput_state = {}
local cursorBlinkTimer = 0
local cursorVisible = true
------------------


----- window -----
local Window_state = {}
local previous_lmb = false
------------------


---------------------

---@param label string
---@param onclick function
---@param pos table {x, y, w, h}
function items.button(label, onclick, pos)
    local x, y, w, h = pos[1], pos[2], pos[3], pos[4]
    
    -- background
    draw.Color(41, 41, 41, 255)
    draw.FilledRect(x, y, x + w, y + h)

    -- button label
    draw.Color(201, 201, 201, 255)
    local tx, ty = draw.GetTextSize(label)
    draw.Text(x + (w // 2) - (tx // 2), y + (h // 2) - (ty // 2), label)

    -- hue
    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + w, y + h, 0, 150, false)

    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        BlockInput = true
        local mouse_x, mouse_y = input.GetMousePos()[1], input.GetMousePos()[2]
        if mouse_x >= x and mouse_x <= x + w and mouse_y >= y and mouse_y <= y + h then
            onclick()
        end
    end
    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end
end

---@param val boolean
---@param label string
---@param pos table {x, y}
---@return boolean
function items.checkbox(val, label, pos)
    local x, y = pos[1], pos[2]
    local CHECKBOX_SIZE = 8

    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end

    if IsMouseInBounds(x, y, x+CHECKBOX_SIZE, y+CHECKBOX_SIZE) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        val = not val
        BlockInput = true
    end

    draw.Color(75, 75, 75, 255)
    draw.FilledRect(x, y, x+CHECKBOX_SIZE, y+CHECKBOX_SIZE)

    if val then
        draw.Color(178, 4, 41, 255)
    else
        draw.Color(69, 69, 69, 255)
    end
    draw.FilledRect(x, y, x+CHECKBOX_SIZE, (y+CHECKBOX_SIZE))
    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x+CHECKBOX_SIZE, y+CHECKBOX_SIZE, 0, 150, false)

    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x+CHECKBOX_SIZE, y+CHECKBOX_SIZE)

    draw.Color(201, 201, 201, 255)
    local tx, ty = draw.GetTextSize(label)
    draw.Text(x + CHECKBOX_SIZE + 5, y + (CHECKBOX_SIZE // 2) - (ty // 2), label)

    return val
end

---@param clr table
---@param pos table {x, y, w, h}
---@returns number, number, table
function items.colorpicker(ID, clr, label, pos)
    local x, y, w, h = pos[1], pos[2], pos[3], pos[4]

    if not picker_state[ID] then
        picker_state[ID] = {
            open = false
        }
    end

    local r, g, b = clr[1], clr[2], clr[3]

    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x + w, y + h)

    draw.Color(r, g, b, 255)
    draw.FilledRect(x, y, x + w, y + h)

    -- hue
    draw.Color(50, 50, 35, 255)
    draw.FilledRectFade(x, y, x + w, y + h, 0, 150, false)

    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        BlockInput = true
        local mouse_x, mouse_y = input.GetMousePos()[1], input.GetMousePos()[2]
        if mouse_x >= x and mouse_x <= x + w and mouse_y >= y and mouse_y <= y + h then
            picker_state[ID].open = not picker_state[ID].open
        end
    end
    local color_picker_x, color_picker_y = x, y + h + 10
    if picker_state[ID].open then
        color_picker_x, color_picker_y = items.window(ID+34587, true, false, {x, y + h + 10, 155, 130})

        -- rgb sliders
        r = items.slider(ID+34589, r, {color_picker_x + 10, color_picker_y + 20, 130, 8}, 0, 255, "r")
        g = items.slider(ID+34590, g, {color_picker_x + 10, color_picker_y + 40, 130, 8}, 0, 255, "g")
        b = items.slider(ID+34591, b, {color_picker_x + 10, color_picker_y + 60, 130, 8}, 0, 255, "b")

        -- preview
        draw.Color(201, 201, 201, 255)
        draw.Text(color_picker_x + 10, color_picker_y + 80, label .. " - preview")

        draw.Color(0, 0, 0, 255)
        draw.OutlinedRect(color_picker_x + 10, color_picker_y + 95, color_picker_x + 140, color_picker_y + 110)

        draw.Color(r, g, b, 255)
        draw.FilledRect(color_picker_x + 10, color_picker_y + 95, color_picker_x + 140, color_picker_y + 110)

        -- hue
        draw.Color(50, 50, 35, 255)
        draw.FilledRectFade(color_picker_x + 10, color_picker_y + 95, color_picker_x + 140, color_picker_y + 110, 0, 150, false)
    end

    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end

    clr = {r, g, b}

    return color_picker_x, color_picker_y, clr
end

---@param pos table {x, y, w, h}
---@param val number|table
---@param label string
---Will become a multi-dropdown if val is a table
function items.dropdown(val, itemLabels, label, pos)
    local x, y, w, h = pos[1], pos[2], pos[3], pos[4]
    local item_height = 20
    local isMulti = type(val) == "table"

    if val == nil then
        if isMulti then
            val = {}
            for i = 1, #itemLabels do
                val[i] = false
            end
        else
            val = 1
        end
    end

    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end

    -- label
    draw.Color(201, 201, 201, 255)
    draw.Text(x, y - 15, label)

    -- dropdown box
    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x + w, y + h)

    draw.Color(44, 44, 44, 255)
    draw.FilledRect(x + 1, y + 1, x + w - 1, y + h - 1)

    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + w, y + h, 0, 150, false)

    -- current selection
    draw.Color(201, 201, 201, 255)
    if isMulti then
        local selected_text = ""
        for i, isSelected in ipairs(val) do
            if isSelected then
                local item_text = itemLabels[i]
                if selected_text ~= "" then
                    selected_text = selected_text .. ", "
                end
                local text_with_item = selected_text .. item_text
                local text_width, _ = draw.GetTextSize(text_with_item)
                if text_width <= 0.7 * w then
                    selected_text = text_with_item
                else
                    selected_text = selected_text .. "..."
                    break
                end
            end
        end
        draw.Text(x + 5, y + 5, selected_text)
    else
        draw.Text(x + 5, y + 5, tostring(itemLabels[val]))
    end

    local arrow_x = x + w - 15
    local arrow_y = y + 10
    draw.Color(201, 201, 201, 255)
    if not Dropdown_open then -- down arrow
        for i = 1, 3, 1 do
            draw.Line(arrow_x - i, arrow_y - i + 1 + 1, arrow_x + i, arrow_y - i + 1 + 1)
        end
    end
    if Dropdown_open then -- up arrow
        for i = -3, -1, 1 do
            draw.Line(arrow_x - i, arrow_y - i - 1 - 3 + 1, arrow_x + i, arrow_y - i - 1 - 3 + 1)
        end
    end

    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and Dropdown_open == label then
        Dropdown_open = nil
        BlockInput = true
    end
    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        if Dropdown_open == label then
            Dropdown_open = nil
        else
            Dropdown_open = label
        end
        BlockInput = true
    end

    if Dropdown_open == label then
        -- items
        for i, item in ipairs(itemLabels) do
            local item_y = y + (i * item_height)
            draw.Color(41, 41, 41, 255)
            draw.FilledRect(x + 1, item_y, x + w - 1, item_y + item_height)
            draw.Color(0, 0, 0, 100)
            draw.OutlinedRect(x + 1, item_y, x + w - 1, item_y + item_height)

            draw.Color(0, 0, 0, 255)
            draw.FilledRectFade(x, item_y, x + w, item_y + item_height, 0, 150, false)

            if isMulti then
                if val[i] then
                    draw.Color(178, 4, 41, 255) -- highlight selected item
                else
                    draw.Color(201, 201, 201, 255)
                end
                draw.Text(x + 5, item_y + 5, item)
                if IsMouseInBounds(x, item_y, x + w, item_y + item_height) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput then
                    val[i] = not val[i]
                    BlockInput = true
                end
            else
                if i == val then
                    draw.Color(178, 4, 41, 255) -- highlight selected item
                else
                    draw.Color(201, 201, 201, 255)
                end
                draw.Text(x + 5, item_y + 5, item)
                if IsMouseInBounds(x, item_y, x + w, item_y + item_height) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput then
                    val = i
                    Dropdown_open = nil
                    BlockInput = true
                end
            end
        end
    end
end

---@param label string
---@param pos table {x, y, w, h}
function items.island(label, pos)
    local x, y, w, h = pos[1], pos[2], pos[3], pos[4]
    local starty = y
    local endy = y + h

    if endy < starty then
        return
    end

    draw.Color(201, 201, 201, 255)
    local fixedTextStartX = x + 10
    draw.Text(fixedTextStartX, starty, label)

    local _, label_tstarty = draw.GetTextSize(label)
    draw.Color(44, 44, 44, 255)
    draw.Line(x, starty + (label_tstarty//2), fixedTextStartX - 5, starty + (label_tstarty//2))
    draw.Line(fixedTextStartX + draw.GetTextSize(label) + 3, starty + (label_tstarty//2), x + w, starty + (label_tstarty//2))
    draw.Line(x, starty + (label_tstarty//2), x, endy)
    draw.Line(x + w, starty + (label_tstarty//2), x + w, endy)
    draw.Line(x, endy, x + w, endy)
end

---@param ID number
---@param val number
---@param name string
---@param min number
---@param max number
---@param pos table {x, y, w, h}
function items.slider(ID, val, name, min, max, pos)
    local x, y, w, h = pos[1], pos[2], pos[3], pos[4]
    local mX = input.GetMousePos()[1]

    local function clamp(value, min, max)
        return math.max(min, math.min(max, value))
    end

    if not input.IsButtonDown(MOUSE_LEFT) then
        slider_state[ID] = false
        BlockInput = false
    end

    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        slider_state[ID] = true
        BlockInput = true
    end

    if slider_state[ID] then
        local percent = clamp((mX - x) / w, 0, 1)
        local value2 = math.floor((min + (max - min) * percent))
        val = value2
    end

    local sliderWidth = math.floor(w * (val - min) / (max - min))

    -- background
    draw.Color(69, 69, 69, 255)
    draw.FilledRect(x, y, x + w, y + h)

    -- background hue
    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + w, y + h, 0, 150, false)

    -- slider
    draw.Color(178, 4, 41, 255)
    draw.FilledRect(x, y, x + sliderWidth, y + h)

    -- slider hue
    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + sliderWidth, y + h, 0, 150, false)

    -- outline
    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x + w, y + h + 1)

    draw.Color(201, 201, 201, 255)
    if val ~= max and val ~= min then
        local value_tx, value_ty = draw.GetTextSize(val)
        draw.Text(x + sliderWidth - (value_tx // 2), y + (value_ty // 4), val)
    end
    local name_tx, name_ty = draw.GetTextSize(name)
    draw.Text(x, y - name_ty, name)

    return clamp(val, min, max)
end

---@param pos table {x, y, w, h}
---@param val string
---@param label string
function items.textinput(ID, val, label, pos)
    local x, y, w, h = pos[1], pos[2], pos[3], pos[4]
    if not textinput_state[ID] then
        textinput_state[ID] = {
            focused = false,
            text = val or "",
            cursorPosition = 0,
        }
    end

    local state = textinput_state[ID]
    local text = state.text

    -- label
    draw.Color(201, 201, 201, 255)
    draw.Text(x, y - 15, label)

    -- background
    draw.Color(41, 41, 41, 255)
    draw.FilledRect(x, y, x + w, y + h)

    -- text
    draw.Color(201, 201, 201, 255)
    local tx, ty = draw.GetTextSize(text)
    draw.Text(x + 5, y + (h // 2) - (ty // 2), text)

    --local isRightMouseDown = input.IsButtonDown(MOUSE_RIGHT)
    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        BlockInput = true
        state.focused = true
    elseif input.IsButtonPressed(MOUSE_LEFT) and not IsMouseInBounds(x, y, x + w, y + h) then
        state.focused = false
    end

    if state.focused then
        local pressedKey = GetPressedKey()
        if pressedKey ~= nil then
            if not keyHeld[pressedKey] then
                keyHeld[pressedKey] = true
                if pressedKey == KEY_BACKSPACE then
                    state.text = state.text:sub(1, state.cursorPosition - 1) .. state.text:sub(state.cursorPosition + 1)
                    state.cursorPosition = math.max(0, state.cursorPosition - 1)
                elseif pressedKey == KEY_LEFT then
                    state.cursorPosition = math.max(0, state.cursorPosition - 1)
                elseif pressedKey == KEY_RIGHT then
                    state.cursorPosition = math.min(#state.text, state.cursorPosition + 1)
                else
                    local char = InputTable[pressedKey]
                    if input.IsButtonDown(KEY_RSHIFT) or input.IsButtonDown(KEY_LSHIFT) then
                        char = char:upper()
                    end
                    state.text = state.text:sub(1, state.cursorPosition) .. char .. state.text:sub(state.cursorPosition + 1)
                    state.cursorPosition = state.cursorPosition + 1
                end
                val = state.text
            end
        else
            for k in pairs(keyHeld) do
                keyHeld[k] = false
            end
        end

        if state.cursorPosition < #state.text then
            local preText = state.text:sub(1, state.cursorPosition - 1)
            local focusedChar = state.text:sub(state.cursorPosition, state.cursorPosition)
            local postText = state.text:sub(state.cursorPosition + 1)
            local preWidth = draw.GetTextSize(preText)
            draw.Color(178, 4, 41, 255)
            draw.Text(x + 5 + preWidth, y + (h // 2) - (ty // 2), focusedChar)
            draw.Color(201, 201, 201, 255)
            draw.Text(x + 5 + preWidth + draw.GetTextSize(focusedChar)[1], y + (h // 2) - (ty // 2), postText)
        end

        if state.cursorPosition == #state.text then
            cursorBlinkTimer = cursorBlinkTimer + 1
            if cursorBlinkTimer > 30 then
                cursorVisible = not cursorVisible
                cursorBlinkTimer = 0
            end
            if cursorVisible then
                local cursorX = x + 5 + draw.GetTextSize(state.text:sub(1, state.cursorPosition))
                draw.Text(cursorX, y + (h // 2) - (ty // 2), "ⵊ")
            end
        end
    end

    -- hue
    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + w, y + h, 0, 150, false)
        
    -- outline
    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x + w, y + h)

    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end

    return val
end

---@param ID number
---@param enable_dragging boolean
---@param tabopts table
---@param pos table {x, y, w, h}
---Will return the current x and y position of the window
function items.window(ID, enable_dragging, tabopts, pos)
    local tabs, current_tab
    if tabopts then
        tabs, current_tab = tabopts[1], (tabopts[2] or tabs[1])
    end
    local m_x, m_y, m_w, m_h = pos[1], pos[2], pos[3], pos[4]
    if not Window_state[ID] then
        Window_state[ID] = {
            dragging = false,
            drag_offset_x = 0,
            drag_offset_y = 0,
            x = m_x,
            y = m_y,
            width = m_w,
            height = m_h,
            enable_dragging = enable_dragging
        }
    end

    local window = Window_state[ID]

    draw.SetFont(globalFont)

    if gui.IsMenuOpen() then
        draw.Color(5, 5, 5, 255)
        draw.FilledRect(window.x, window.y, window.x + window.width, window.y + window.height)
        draw.Color(60, 60, 60, 255)
        draw.FilledRect(window.x + 2, window.y + 2, window.x + window.width - 4, window.y + window.height - 4)
        draw.Color(40, 40, 40, 255)
        draw.FilledRect(window.x + 3, window.y + 3, window.x + window.width - 6, window.y + window.height - 6)
        draw.FilledRect(window.x + 4, window.y + 4, window.x + window.width - 8, window.y + window.height - 8)
        draw.Color(60, 60, 60, 255)
        draw.FilledRect(window.x + 5, window.y + 5, window.x + window.width - 10, window.y + window.height - 10)
        draw.Color(5, 5, 5, 255)
        draw.FilledRect(window.x + 6, window.y + 6, window.x + window.width - 12, window.y + window.height - 12)

        local mouseX, mouseY = input.GetMousePos()[1], input.GetMousePos()[2]
        local LMBDown = input.IsButtonDown(MOUSE_LEFT)

        if tabs then
            local num_tabs = #tabs
            local tab_spacing = 5
            local tab_width = round((window.width - 28 - (num_tabs - 1) * tab_spacing) / num_tabs)  -- calculate the width of each tab
            local first_tab_x_start = window.x + 11  -- start of the first tab
            local last_tab_x_end = first_tab_x_start + (num_tabs - 1) * (tab_width + tab_spacing) + tab_width  -- end of the last tab
        
            for i, p in ipairs(tabs) do
                local tab_x_start = window.x + 11 + (i - 1) * (tab_width + tab_spacing)
                local tab_x_end = tab_x_start + tab_width
                if current_tab == p then
                    draw.Color(178, 4, 41, 255)
                    draw.FilledRect(tab_x_start, window.y + 30, tab_x_end, window.y + 36)
                    draw.Color(0, 0, 0, 255)
                    draw.FilledRectFade(tab_x_start, window.y + 30, tab_x_end, window.y + 36, 0, 150, false)
                else
                    draw.Color(69, 69, 69, 255)
                    draw.FilledRect(tab_x_start, window.y + 30, tab_x_end, window.y + 36)
                    draw.Color(0, 0, 0, 255)
                    draw.FilledRectFade(tab_x_start, window.y + 30, tab_x_end, window.y + 36, 0, 150, false)
                end
                local tx, ty = draw.GetTextSize(p)
                draw.Color(201, 201, 201, 255)
                draw.Text(tab_x_start + (tab_width // 2) - (tx // 2), window.y + 15, p)

            end
        
            draw.Color(44, 44, 44, 255)
            draw.OutlinedRect(first_tab_x_start, window.y + 45, last_tab_x_end, window.y + window.height - 18)
        
            if LMBDown and not previous_lmb then
                for i, p in ipairs(tabs) do
                    local tab_x_start = window.x + 11 + (i - 1) * (tab_width + tab_spacing)
                    local tab_x_end = tab_x_start + tab_width
                    if IsMouseInBounds(tab_x_start, window.y + 10, tab_x_end, window.y + 36) then
                        current_tab = p
                    end
                end
            end
        end


        if window.enable_dragging then
            for _, win in pairs(Window_state) do
                if IsMouseInBounds(win.x, win.y, win.x + win.width, win.y + win.height) and not IsMouseInBounds(win.x + 6, win.y + 6, win.x + win.width - 12, win.y + win.height - 12) then
                    if LMBDown and not previous_lmb then
                        if not win.dragging then
                            win.dragging = true
                            win.drag_offset_x = mouseX - win.x
                            win.drag_offset_y = mouseY - win.y
                        end
                    end
                end

                if win.dragging then
                    if LMBDown then
                        win.x = mouseX - win.drag_offset_x
                        win.y = mouseY - win.drag_offset_y
                    else
                        win.dragging = false
                    end
                end
            end
        end

        previous_lmb = LMBDown

        return window.x, window.y, current_tab
    end
end


local CURRENT_TAB = "tab1"
local Tabs = {
    "tab1",
    "debug"
}

------------------------------------------------------------ DEBUG ---------------------------------------------------------------

local function getMemoryUsage()
    local mem = collectgarbage("count") / 1024
    if mem > 800 then
        collectgarbage("collect")
        mem = collectgarbage("count") / 1024
    end
    return mem
end

local dbg_font = draw.CreateFont("Lucida Console", 10, 0, 512)
---@param memonly boolean
---@param extra_values table
---memonly will only show memory usage if true
local function DrawDebugInfo(memonly, extra_values)
    extra_values = extra_values or {}
    if not Values.show_debug_info then return end
    draw.Color(230, 230, 180, 255)

    local dbgx = 10
    local dbgy = 200
    local i = 1

    draw.Text(dbgx, dbgy - 12, "Memory usage: " .. string.format("%.2f", getMemoryUsage()) .. " MB")
    if not memonly then
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

        if extra_values then
            for key, value in pairs(extra_values) do
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
    end
end

------------------------------------------------------------- MENU ---------------------------------------------------------------

local screenx, screeny = draw.GetScreenSize()
local winx, winy = round(screenx*0.8), round(screeny*0.4)
local winw, winh = 320, 400
winx = (winx - winw//2)

-- local register = {
--     window = items.window,
--     checkbox = items.checkbox,
--     colorpicker = items.colorpicker,
--     dropdown = items.dropdown,
--     slider = items.slider,
--     textinput = items.textinput,
--     button = items.button,
--     island = items.island
-- }

local function menu()
    local dropdowns = {}
    local colorpickers = {}

    DrawDebugInfo(false, {})

    --Watermark:DrawWatermark()
    --Keybind:KeybindIndicator()

    if gui.IsMenuOpen() then
        --winx, winy = Window:SetupWindow("mainmenu", winx - winw//2, winy, winw, winh, true, true)
        winx, winy, CURRENT_TAB = items.window(1, true, {Tabs, CURRENT_TAB}, {winx, winy, winw, winh})

        if CURRENT_TAB == "tab1" then
            -- Checkbox:Checkbox(winx + 20, winy + 60, "test_checkbox2", "checkbox 2")
            Values.test_checkbox2 = items.checkbox(Values.test_checkbox2, "checkbox 2", {winx + 20, winy + 60})
            
            -- Checkbox:Checkbox(winx + 20, winy + 80, "test_checkbox3", "checkbox 3")
            Values.test_checkbox3 = items.checkbox(Values.test_checkbox3, "checkbox 3", {winx + 20, winy + 80})
            
            -- Slider:Slider(winx + 20, winy + 110, 130, 8, "testvalue4", 0, 50, "slider 4")
            Values.testvalue4 = items.slider(1, Values.testvalue4, "slider 4", 0, 50, {winx + 20, winy + 110, 130, 8})
            
            -- table.insert(dropdowns, {winx + 20, winy + 140, 130, 20, "test_dropdown1", {"option 1", "option 2", "option 3"}, "dropdown 5"})
            --TODO use some kind of register function to correct draw order
            Values.test_dropdown1 = items.dropdown(Values['test_dropdown1'], {"option 1", "option 2", "option 3"}, "dropdown 5", {winx + 20, winy + 140, 130, 20})
            
            -- Button:Button(winx + 20, winy + 170, 130, 20, "button 6", function() Notify:Add("Hi!") end)
            items.button("button 6", function() client.ChatPrintf("Hi!") end, {winx + 20, winy + 170, 130, 20})
            
            -- table.insert(dropdowns, {winx + 20, winy + 210, 130, 20, "test_dropdown2", {"option 1", "option 2", "option 3"}, "dropdown 7"})
            Values.test_dropdown2 = items.dropdown(Values.test_dropdown2, {"option 1", "option 2", "option 3"}, "dropdown 7", {winx + 20, winy + 210, 130, 20})
            
            -- table.insert(dropdowns, {winx + 20, winy + 250, 130, 20, "test_multidropdown1", {"option 1", "option 2", "option 3"}, "multidropdown 8"})
            Values.test_multidropdown1 = items.dropdown(Values.test_multidropdown1, {"option 1", "option 2", "option 3"}, "multidropdown 8", {winx + 20, winy + 250, 130, 20})
            
            -- Keybind:Keybind(winx + 20, winy + 290, 130, 20, "test_keybind1", "keybind 9", false)
            
            -- Keybind:Keybind(winx + 20, winy + 340, 130, 20, "test_keybind2", "keybind 10", true, false, false)
            
            -- Island:Island("test island", winx + 154, 140, winy + 45, winy + 140)
            items.island("test island", {winx + 154, winy + 45, 140, 100})
            
            -- table.insert(colorpickers, {winx + 270, winy + 65, 16, 6, "testcolor1"})
            
            -- table.insert(colorpickers, {winx + 270, winy + 105, 16, 6, "testcolor2"})
            
            -- TextInput:TextInput(winx + 160, winy + 75, 130, 20, "test_textinpt", "text input")
            Values.test_textinput = items.textinput(1, Values.test_textinput, "text input", {winx + 160, winy + 75, 130, 20})
            
            -- TextInput:TextInput(winx + 160, winy + 115, 130, 20, "test_textinput", "text input2")
        end
        if CURRENT_TAB == "debug" then
           items.island("debug", {winx + 15, winy + 45, 290, 80})
           Values.show_debug_info = items.checkbox(Values.show_debug_info, "show debug info", {winx + 20, winy + 60})
        end

        -- table.sort(dropdowns, function(a, b)
        --     return a[2] > b[2]
        -- end)
        -- table.sort(colorpickers, function(a, b)
        --     return a[2] > b[2]
        -- end)
        -- for _, d in ipairs(dropdowns) do
        --     Dropdowns:Dropdown(d[1], d[2], d[3], d[4], d[5], d[6], d[7])
        -- end
        -- for _, c in ipairs(colorpickers) do
        --     Colorpicker:Colorpicker(c[1], c[2], c[3], c[4], c[5])
        -- end


        if input.IsButtonPressed(MOUSE_LEFT) then
            BlockInput = true
        end
    end
end

callbacks.Unregister("Draw", "draw_menu")
callbacks.Register("Draw", "draw_menu", menu)

--------------------------------------------- PMLIB CALLBACKS (DO NOT REMOVE) ---------------------------------------------------

callbacks.Unregister("Unload", "PMLib_unload")
callbacks.Register("Unload", "PMLib_unload", OnUnload)

callbacks.Unregister("CreateMove", "PMLib_UpdateKeybinds")
-- callbacks.Register("CreateMove", "PMLib_UpdateKeybinds", function()
--     Keybind:UpdateKeybindValues()
-- end) -- CreateMove

callbacks.Unregister("Draw", "PMLib_Others")
callbacks.Register("Draw", "PMLib_Others", function()
    Notify:Think()
end) -- Draw