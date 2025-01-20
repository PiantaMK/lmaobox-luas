Keybind = {}
Keybind = {
    font = draw.CreateFont("Tahoma", 12, 400, FONTFLAG_DROPSHADOW)
}

local idcounter = 0
local function GetID()
    idcounter = idcounter + 1
    return idcounter
end

local Keybind_indicator_state = {
    dragging = false,
    drag_offset_x = 0,
    drag_offset_y = 0,
    x = draw.GetScreenSize()[1]//2,  -- initial position
    y = draw.GetScreenSize()[2]//2   -- initial position
}

local Keybind_states = {}

---@param val number
---@param label string
---@param initiallyToggle boolean
---@param noshowType boolean
---@param allowtypeChanges boolean
---@param pos table {x, y, w, h}
function Keybind:Keybind(val, label, initiallyToggle, noshowType, allowtypeChanges, pos)
    local ID = GetID()
    local x, y, w, h = pos[1], pos[2], pos[3], pos[4]
    
    noshowType = noshowType or false
    allowtypeChanges = allowtypeChanges or true

    if not Keybind_states[ID] then
        Keybind_states[ID] = {
            label = label,
            waiting_for_keybind = false,
            key = val or nil,
            toggle = initiallyToggle,
            wasRightMouseDown = false,
            active = false,
            keyPreviouslyPressed = false,
            noshowType = noshowType,
            allowtypeChanges = allowtypeChanges
        }
    end
    local state = Keybind_states[ID]
    local key = state.key
    local ckey = KeyTable[key] or ""
    if state.waiting_for_keybind and input.IsButtonPressed(KEY_ESCAPE) then
        state.waiting_for_keybind = false
        Keybind_states[ID].key = nil
    end
    if state.waiting_for_keybind then
        ckey = "..."
        local pressedKey = GetPressedKey()
        if pressedKey ~= nil then
            val = pressedKey
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
    
    draw.Color(41, 41, 41, 255)
    draw.FilledRect(x, y, x + w, y + h)

    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + w, y + h, 0, 150, false)
    
    draw.Color(201, 201, 201, 255)
    local tx, ty = draw.GetTextSize(ckey)
    draw.Text(x + 5, y + (h // 2) - (ty // 2), ckey)
    local isRightMouseDown = input.IsButtonDown(MOUSE_RIGHT)
    if IsMouseInBounds(x, y, x + w, y + h) and isRightMouseDown and not state.wasRightMouseDown and not BlockInput and not Dropdown_open and state.allowtypeChanges then
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

    return state.active
end

--! not sure if this works
function Keybind:UpdateKeybindValues()
    for id, state in pairs(Keybind_states) do
        local key = state.key
        if key and not (engine.Con_IsVisible() or engine.IsGameUIVisible()) then
            if state.toggle then
                if input.IsButtonPressed(key) and not state.keyPreviouslyPressed then
                    state.active = not state.active
                    state.keyPreviouslyPressed = true
                elseif not input.IsButtonPressed(key) then
                    state.keyPreviouslyPressed = false
                end
            else
                state.active = input.IsButtonPressed(key)
            end
        end
    end
end

local keybind_animations = {}
function Keybind:KeybindIndicator()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() or engine.IsTakingScreenshot() then
        return
    end
    draw.SetFont(Keybind.font)
    local header = "keybinds"
    local headerw, headerh = draw.GetTextSize(header)
    local mouseX, mouseY = input.GetMousePos()[1], input.GetMousePos()[2]
    local LMBDown = input.IsButtonDown(MOUSE_LEFT)
    local LMBPressed = input.IsButtonPressed(MOUSE_LEFT)
    
    -- update position if dragging
    if Keybind_indicator_state.dragging then
        if LMBDown then
            Keybind_indicator_state.x = mouseX - Keybind_indicator_state.drag_offset_x
            Keybind_indicator_state.y = mouseY - Keybind_indicator_state.drag_offset_y
        else
            Keybind_indicator_state.dragging = false
        end
    end
    
    -- should we start dragging?
    if IsMouseInBounds(Keybind_indicator_state.x - 70, Keybind_indicator_state.y - 10, Keybind_indicator_state.x + 70, Keybind_indicator_state.y + 10) and LMBPressed and not Keybind_indicator_state.dragging and gui.IsMenuOpen() then
        Keybind_indicator_state.dragging = true
        Keybind_indicator_state.drag_offset_x = mouseX - Keybind_indicator_state.x
        Keybind_indicator_state.drag_offset_y = mouseY - Keybind_indicator_state.y
    end
    
    draw.Color(178, 4, 41, 255)
    draw.FilledRect(Keybind_indicator_state.x - 70, Keybind_indicator_state.y - 11, Keybind_indicator_state.x + 70, Keybind_indicator_state.y - 10)
    
    draw.Color(0, 0, 0, 100)
    draw.FilledRect(Keybind_indicator_state.x - 70, Keybind_indicator_state.y - 10, Keybind_indicator_state.x + 70, Keybind_indicator_state.y + 10)
    draw.Color(201, 201, 201, 255)
    draw.Text(Keybind_indicator_state.x - (headerw // 2), Keybind_indicator_state.y - (headerh // 2), header)

    -- display the status and type
    local yOffset = 10
    for _, state in pairs(Keybind_states) do
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
                local boxTopLeftX = Keybind_indicator_state.x - 70
                local boxTopLeftY = Keybind_indicator_state.y + yOffset
                local boxBottomRightX = Keybind_indicator_state.x + 70
                --local boxBottomRightY = Keybind_indicator_state.y + yOffset + 20
                
                -- keybind name
                draw.Color(201, 201, 201, math.floor(anim.alpha))
                draw.Text(boxTopLeftX + 5, boxTopLeftY + 5 - math.floor(anim.yOffset), label)

                -- keybind type
                local type = state.toggle and "[toggled]" or "[held]"
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