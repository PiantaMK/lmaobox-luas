Keybind = {
    font = draw.CreateFont("Tahoma", 12, 400, FONTFLAG_DROPSHADOW)
}
local keybind_state = {}

local keybind_indicator_state = {
    dragging = false,
    drag_offset_x = 0,
    drag_offset_y = 0,
    x = 500,  -- Initial position
    y = 500   -- Initial position
}

function Keybind:Keybind(x, y, w, h, varName, label, initiallyToggle, noshowType, allowtypeChanges)
    if not keybind_state[varName] then
        keybind_state[varName] = {
            label = label,
            waiting_for_keybind = false,
            key = Values[varName] or nil,
            toggle = initiallyToggle,
            wasRightMouseDown = false,
            active = false,
            keyPreviouslyPressed = false,
            noshowType = noshowType or false,
            allowtypeChanges = allowtypeChanges or true
        }
    end
    local state = keybind_state[varName]
    local key = state.key
    local ckey = KeyTable[key] or ""
    if state.waiting_for_keybind and input.IsButtonPressed(KEY_ESCAPE) then
        state.waiting_for_keybind = false
        keybind_state[varName].key = nil
    end
    if state.waiting_for_keybind then
        ckey = "..."
        local pressedKey = GetPressedKey()
        if pressedKey ~= nil then
            Values[varName] = pressedKey
            state.key = pressedKey
            state.waiting_for_keybind = false
        end
    end
    draw.Color(201, 201, 201, 255)
    if not state.noshowType then
        if state.toggle then
            label = label .. " (toggle)"
        else
            label = label .. " (hold)"
        end
    end
    draw.Text(x, y - 15, label)
    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x + w, y + h)
    
    draw.Color(41, 41, 41, 255)
    draw.FilledRect(x, y, x + w, y + h)
    
    draw.Color(201, 201, 201, 255)
    local tx, ty = draw.GetTextSize(ckey)
    draw.Text(x + 5, y + (h // 2) - (ty // 2), ckey)
    local isRightMouseDown = input.IsButtonDown(MOUSE_RIGHT)
    if IsMouseInBounds(x, y, x + w, y + h) and isRightMouseDown and not state.wasRightMouseDown and not BlockInput and not Dropdown_open and allowtypeChanges then
        BlockInput = true
        state.toggle = not state.toggle
    end
    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        BlockInput = true
        state.waiting_for_keybind = true
    end
    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end
    state.wasRightMouseDown = isRightMouseDown
end

function Keybind:UpdateKeybindValues()
    for varName, state in pairs(keybind_state) do
        local key = state.key
        if key then
            if state.toggle then
                if input.IsButtonDown(key) and not state.keyPreviouslyPressed then
                    state.active = not state.active
                    Values[varName] = state.active
                    state.keyPreviouslyPressed = true
                elseif not input.IsButtonDown(key) then
                    state.keyPreviouslyPressed = false
                end
            else
                Values[varName] = input.IsButtonDown(key)
                state.active = input.IsButtonDown(key)
            end
        end
    end
end

local keybind_animations = {}
function Keybind:KeybindIndicator()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end
    draw.SetFont(Keybind.font)
    local header = "keybinds"
    local headerw, headerh = draw.GetTextSize(header)
    local mouseX, mouseY = input.GetMousePos()[1], input.GetMousePos()[2]
    local LMBDown = input.IsButtonDown(MOUSE_LEFT)
    
    -- update position if dragging
    if keybind_indicator_state.dragging then
        if LMBDown then
            keybind_indicator_state.x = mouseX - keybind_indicator_state.drag_offset_x
            keybind_indicator_state.y = mouseY - keybind_indicator_state.drag_offset_y
        else
            keybind_indicator_state.dragging = false
        end
    end
    
    -- should we start dragging?
    if IsMouseInBounds(keybind_indicator_state.x - 70, keybind_indicator_state.y - 10, keybind_indicator_state.x + 70, keybind_indicator_state.y + 10) and LMBDown and not keybind_indicator_state.dragging and MENU_OPEN then
        keybind_indicator_state.dragging = true
        keybind_indicator_state.drag_offset_x = mouseX - keybind_indicator_state.x
        keybind_indicator_state.drag_offset_y = mouseY - keybind_indicator_state.y
    end
    
    draw.Color(178, 4, 41, 255)
    draw.FilledRect(keybind_indicator_state.x - 70, keybind_indicator_state.y - 11, keybind_indicator_state.x + 70, keybind_indicator_state.y - 10)
    
    draw.Color(0, 0, 0, 100)
    draw.FilledRect(keybind_indicator_state.x - 70, keybind_indicator_state.y - 10, keybind_indicator_state.x + 70, keybind_indicator_state.y + 10)
    draw.Color(201, 201, 201, 255)
    draw.Text(keybind_indicator_state.x - (headerw // 2), keybind_indicator_state.y - (headerh // 2), header)

    -- display the status and type
    local yOffset = 10
    for _, state in pairs(keybind_state) do
        local label = state.label
        local anim = keybind_animations[label]
        
        -- init anim state
        if not anim and state.active then
            keybind_animations[label] = {alpha = 0, yOffset = 5, startTime = globals.RealTime(), active = false}
            anim = keybind_animations[label]
        end
        
        if anim then
            local elapsedTime = globals.RealTime() - anim.startTime
            
            if state.active then
                if not anim.active then
                    anim.startTime = globals.RealTime()
                    anim.active = true
                end
                
                if elapsedTime < 0.1 then
                    anim.alpha = math.min(255, (elapsedTime / 0.1) * 255)
                    anim.yOffset = 5 - (elapsedTime / 0.1) * 5
                else
                    anim.alpha = 255
                    anim.yOffset = 0
                end
            else
                if anim.active then
                    anim.startTime = globals.RealTime()
                    anim.active = false
                end
                
                if elapsedTime < 0.1 then
                    anim.alpha = 255 - math.min(255, (elapsedTime / 0.1) * 255)
                    anim.yOffset = (elapsedTime / 0.1) * 5
                else
                    anim.alpha = 0
                    anim.yOffset = 5
                end
            end
            
            if anim.alpha and anim.alpha > 5 then
                local boxTopLeftX = keybind_indicator_state.x - 70
                local boxTopLeftY = keybind_indicator_state.y + yOffset
                local boxBottomRightX = keybind_indicator_state.x + 70
                local boxBottomRightY = keybind_indicator_state.y + yOffset + 20
                
                local type = state.toggle and "[toggled]" or "[held]"
                draw.Color(201, 201, 201, math.floor(anim.alpha))
                draw.Text(boxTopLeftX + 5, boxTopLeftY + 5 - math.floor(anim.yOffset), label)
                local typew, _ = draw.GetTextSize(type)
                draw.Color(201, 201, 201, math.floor(anim.alpha))
                draw.Text(boxBottomRightX - typew - 5, boxTopLeftY + 5 - math.floor(anim.yOffset), type)
                
                yOffset = yOffset + 20
            end
        end
        
        state.wasActive = state.active
    end

    -- clean up inactive animations
    for label, anim in pairs(keybind_animations) do
        if not anim.active and globals.RealTime() - anim.startTime > 0.1 then
            keybind_animations[label] = nil
        end
    end
end

return Keybind