Colorpicker = {}

local picker_state = {}
function Colorpicker:Colorpicker(x, y, w, h, clrName)
    if not picker_state[clrName] then
        picker_state[clrName] = {
            open = false
        }
    end
    
    local r = Values[clrName .. "_r"]
    local g = Values[clrName .. "_g"]
    local b = Values[clrName .. "_b"]
    -- note: this is dumb but recoding most menu elements to support something outside of Values is a pain
      
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
            picker_state[clrName].open = not picker_state[clrName].open
        end
    end
    local color_picker_x, color_picker_y = x, y + h + 10
    if picker_state[clrName].open then
        color_picker_x, color_picker_y = Window:SetupWindow(clrName, x, y + h + 10, 155, 130, true)

        -- rgb sliders
        Slider:Slider(color_picker_x + 10, color_picker_y + 20, 130, 8, clrName .."_r", 0, 255, "r")
        Slider:Slider(color_picker_x + 10, color_picker_y + 40, 130, 8, clrName .."_g", 0, 255, "g")
        Slider:Slider(color_picker_x + 10, color_picker_y + 60, 130, 8, clrName .."_b", 0, 255, "b")

        -- preview
        draw.Color(201, 201, 201, 255)
        draw.Text(color_picker_x + 10, color_picker_y + 80, clrName .. " - preview")

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
    return color_picker_x, color_picker_y
end

return Colorpicker