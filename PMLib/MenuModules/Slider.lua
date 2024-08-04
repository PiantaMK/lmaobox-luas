Slider = {}

function Slider:Slider(x, y, w, h, sliderValue, min, max, name)
    local mX = input.GetMousePos()[1]
    local value = Values[sliderValue]
    if not input.IsButtonPressed(MOUSE_LEFT) then
        BlockInput = false
    end
    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonDown(MOUSE_LEFT) and not BlockInput and not Dropdown_open then 
        local function clamp(value, min, max)
            BlockInput = true
            return math.max(min, math.min(max, value))
        end
        local percent = clamp((mX - x) / w, 0, 1)
        local value2 = math.floor((min + (max - min) * percent))
        Values[sliderValue] = value2
    end
    
    local sliderWidth = math.floor(w * (value - min) / (max - min))
    draw.Color(69, 69, 69, 255)
    draw.FilledRect(x, y, x + w, y + h)

    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + w, y + h, 0, 150, false)

    draw.Color(178, 4, 41, 255)
    draw.FilledRect(x, y, x + sliderWidth, y + h)

    draw.Color(0, 0, 0, 255)
    draw.FilledRectFade(x, y, x + sliderWidth, y + h, 0, 150, false)

    draw.Color(0, 0, 0, 255)
    draw.OutlinedRect(x, y, x + w, y + h + 1)

    draw.Color(201, 201, 201, 255)
    if value ~= max and value ~= min then
        local value_tx, value_ty = draw.GetTextSize(value)
        draw.Text(x + sliderWidth - (value_tx // 2), y + (value_ty // 4), value)
    end
    local name_tx, name_ty = draw.GetTextSize(name)
    draw.Text(x, y - name_ty, name)
end

return Slider