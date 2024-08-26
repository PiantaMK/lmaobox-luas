Button = {}

---@param x number
---@param y number
---@param w number
---@param h number
---@param label string
---@param dowhat function
function Button:Button(x, y, w, h, label, dowhat)
    
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
            dowhat()
        end
    end
    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end
end

return Button