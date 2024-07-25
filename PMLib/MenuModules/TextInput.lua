TextInput = {}


local keyHeld = {}
local textinput_state = {}
function TextInput:TextInput(x, y, w, h, varName, label)
    if not textinput_state[varName] then
        textinput_state[varName] = {
            focused = false,
            text = Values[varName] or "",
        }
    end

    local state = textinput_state[varName]
    local text = state.text

    draw.Color(201, 201, 201, 255)
    draw.Text(x, y - 15, label)

    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x + w, y + h)
    
    draw.Color(41, 41, 41, 255)
    draw.FilledRect(x, y, x + w, y + h)
    
    draw.Color(201, 201, 201, 255)
    local tx, ty = draw.GetTextSize(text)
    draw.Text(x + 5, y + (h // 2) - (ty // 2), text)

    local isRightMouseDown = input.IsButtonDown(MOUSE_RIGHT)
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
                    state.text = state.text:sub(1, -2)
                else
                    local char = InputTable[pressedKey]
                    if input.IsButtonDown(KEY_RSHIFT) or input.IsButtonDown(KEY_LSHIFT) then
                        if char:upper() then
                            char = char:upper()
                        else
                            char = char
                        end
                    end
                    state.text = state.text .. char
                end
                Values[varName] = state.text
            end
        else
            for k in pairs(keyHeld) do
                keyHeld[k] = false
            end
        end
    end

    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end
end

return TextInput