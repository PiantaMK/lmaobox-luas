local keyTable = {
    [1] = "KEY_0",
    [2] = "KEY_1",
    [3] = "KEY_2",
    [4] = "KEY_3",
    [5] = "KEY_4",
    [6] = "KEY_5",
    [7] = "KEY_6",
    [8] = "KEY_7",
    [9] = "KEY_8",
    [10] = "KEY_9",
    [11] = "KEY_A",
    [12] = "KEY_B",
    [13] = "KEY_C",
    [14] = "KEY_D",
    [15] = "KEY_E",
    [16] = "KEY_F",
    [17] = "KEY_G",
    [18] = "KEY_H",
    [19] = "KEY_I",
    [20] = "KEY_J",
    [21] = "KEY_K",
    [22] = "KEY_L",
    [23] = "KEY_M",
    [24] = "KEY_N",
    [25] = "KEY_O",
    [26] = "KEY_P",
    [27] = "KEY_Q",
    [28] = "KEY_R",
    [29] = "KEY_S",
    [30] = "KEY_T",
    [31] = "KEY_U",
    [32] = "KEY_V",
    [33] = "KEY_W",
    [34] = "KEY_X",
    [35] = "KEY_Y",
    [36] = "KEY_Z",
    [37] = "KEY_PAD_0",
    [38] = "KEY_PAD_1",
    [39] = "KEY_PAD_2",
    [40] = "KEY_PAD_3",
    [41] = "KEY_PAD_4",
    [42] = "KEY_PAD_5",
    [43] = "KEY_PAD_6",
    [44] = "KEY_PAD_7",
    [45] = "KEY_PAD_8",
    [46] = "KEY_PAD_9",
    [47] = "KEY_PAD_DIVIDE",
    [48] = "KEY_PAD_MULTIPLY",
    [49] = "KEY_PAD_MINUS",
    [50] = "KEY_PAD_PLUS",
    [51] = "KEY_PAD_ENTER",
    [52] = "KEY_PAD_DECIMAL",
    [53] = "KEY_LBRACKET",
    [54] = "KEY_RBRACKET",
    [55] = "KEY_SEMICOLON",
    [56] = "KEY_APOSTROPHE",
    [57] = "KEY_BACKQUOTE",
    [58] = "KEY_COMMA",
    [59] = "KEY_PERIOD",
    [60] = "KEY_SLASH",
    [61] = "KEY_BACKSLASH",
    [62] = "KEY_MINUS",
    [63] = "KEY_EQUAL",
    [64] = "KEY_ENTER",
    [65] = "KEY_SPACE",
    [66] = "KEY_BACKSPACE",
    [67] = "KEY_TAB",
    [68] = "KEY_CAPSLOCK",
    [69] = "KEY_NUMLOCK",
    [70] = "KEY_ESCAPE",
    [71] = "KEY_SCROLLLOCK",
    [72] = "KEY_INSERT",
    [73] = "KEY_DELETE",
    [74] = "KEY_HOME",
    [75] = "KEY_END",
    [76] = "KEY_PAGEUP",
    [77] = "KEY_PAGEDOWN",
    [78] = "KEY_BREAK",
    [79] = "KEY_LSHIFT",
    [80] = "KEY_RSHIFT",
    [81] = "KEY_LALT",
    [82] = "KEY_RALT",
    [83] = "KEY_LCONTROL",
    [84] = "KEY_RCONTROL",
    [85] = "KEY_LWIN",
    [86] = "KEY_RWIN",
    [87] = "KEY_APP",
    [88] = "KEY_UP",
    [89] = "KEY_LEFT",
    [90] = "KEY_DOWN",
    [91] = "KEY_RIGHT",
    [92] = "KEY_F1",
    [93] = "KEY_F2",
    [94] = "KEY_F3",
    [95] = "KEY_F4",
    [96] = "KEY_F5",
    [97] = "KEY_F6",
    [98] = "KEY_F7",
    [99] = "KEY_F8",
    [100] = "KEY_F9",
    [101] = "KEY_F10",
    [102] = "KEY_F11",
    [103] = "KEY_F12",
    [104] = "KEY_CAPSLOCKTOGGLE",
    [105] = "KEY_NUMLOCKTOGGLE",
    [106] = "KEY_SCROLLLOCKTOGGLE",
    [107] = "MOUSE_LEFT",
    [108] = "MOUSE_RIGHT",
    [109] = "MOUSE_MIDDLE",
    [110] = "MOUSE_4",
    [111] = "MOUSE_5",
    [112] = "MOUSE_WHEEL_UP",
    [113] = "MOUSE_WHEEL_DOWN"
}

local pressedKey = nil
local toggled = false
local lastToggleTime = 0

local initial_value = gui.GetValue("Trigger Shoot Key")
local x, y = draw.GetScreenSize()
local text = ""
local fontoption = gui.GetValue('Font')
local font = draw.CreateFont(fontoption, 12, 400, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)

local function GetPressedKey()
    for i = 1, 113 do 
        if input.IsButtonPressed(i) then
            if i ~= 107 and i ~= 72 then 
                return i
            end
        end
    end
end

local function main()
    draw.SetFont(font)
    draw.Color(255, 255, 255, 255)

    if pressedKey == nil then
        text = "Waiting for keys..."
        pressedKey = GetPressedKey()
    else
        if input.IsButtonPressed(pressedKey) then
            local currentTime = globals.RealTime()
            if currentTime - lastToggleTime > 0.25 then
                toggled = not toggled
                lastToggleTime = currentTime

                if toggled then
                    gui.SetValue("Trigger Shoot Key", 0)
                else
                    gui.SetValue("Trigger Shoot Key", initial_value)
                end
            end
        end
        text = "Toggle key: " .. keyTable[pressedKey] .. " | Toggled: " .. tostring(toggled)
    end
    local tx, ty = draw.GetTextSize(text)
    draw.Text(x // 2 - (tx // 2), y - ty, text)

end

local function unload()
    gui.SetValue("Trigger Shoot Key", initial_value)
end

callbacks.Register("Draw", "main", main)
callbacks.Register("Unload", "onUnload", unload)
