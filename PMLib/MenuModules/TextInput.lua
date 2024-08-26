TextInput = {}

local keyHeld = {}
local textinput_state = {}
local cursorBlinkTimer = 0
local cursorVisible = true

---@param x number
---@param y number
---@param w number
---@param h number
---@param varName string
---@param label string
function TextInput:TextInput(x, y, w, h, varName, label)
    if not textinput_state[varName] then
        textinput_state[varName] = {
            focused = false,
            text = Values[varName] or "",
            cursorPosition = 0,
        }
    end

    local state = textinput_state[varName]
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
                Values[varName] = state.text
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
end

return TextInput