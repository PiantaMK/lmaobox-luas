Checkbox = {}

---@param x number
---@param y number
---@param varName string
---@param label string
function Checkbox:Checkbox(x, y, varName, label)
    local CHECKBOX_SIZE = 8

    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end

    if IsMouseInBounds(x, y, x+CHECKBOX_SIZE, y+CHECKBOX_SIZE) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        Values[varName] = not Values[varName]
        BlockInput = true
    end


    draw.Color(75, 75, 75, 255)
    draw.FilledRect(x, y, x+CHECKBOX_SIZE, y+CHECKBOX_SIZE)

    if Values[varName] then
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
    draw.Text(x + 20, y + Round(CHECKBOX_SIZE/2) - (ty//2), label)
end

return Checkbox