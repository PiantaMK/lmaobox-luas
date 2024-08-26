Dropdowns = {}

---@param x number
---@param y number
---@param w number
---@param h number
---@param varName string
---@param varLabels table
---@param label string
---Will become a multi-dropdown if varName is a table
function Dropdowns:Dropdown(x, y, w, h, varName, varLabels, label)
    local item_height = 20
    local isMulti = type(Values[varName]) == "table"

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
        for i, isSelected in ipairs(Values[varName]) do
            if isSelected then
                local item_text = varLabels[i]
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
        draw.Text(x + 5, y + 5, tostring(varLabels[Values[varName]]))
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

    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and Dropdown_open == varName then
        Dropdown_open = nil
        BlockInput = true
    end
    if IsMouseInBounds(x, y, x + w, y + h) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput and not Dropdown_open then
        if Dropdown_open == varName then
            Dropdown_open = nil
        else
            Dropdown_open = varName
        end
        BlockInput = true
    end

    if Dropdown_open == varName then
        -- items
        for i, item in ipairs(varLabels) do
            local item_y = y + (i * item_height)
            draw.Color(41, 41, 41, 255)
            draw.FilledRect(x + 1, item_y, x + w - 1, item_y + item_height)
            draw.Color(0, 0, 0, 100)
            draw.OutlinedRect(x + 1, item_y, x + w - 1, item_y + item_height)

            draw.Color(0, 0, 0, 255)
            draw.FilledRectFade(x, item_y, x + w, item_y + item_height, 0, 150, false)

            if isMulti then
                if Values[varName][i] then
                    draw.Color(178, 4, 41, 255) -- highlight selected item
                else
                    draw.Color(201, 201, 201, 255)
                end
                draw.Text(x + 5, item_y + 5, item)
                if IsMouseInBounds(x, item_y, x + w, item_y + item_height) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput then
                    Values[varName][i] = not Values[varName][i]
                    BlockInput = true
                end
            else
                if i == Values[varName] then
                    draw.Color(178, 4, 41, 255) -- highlight selected item
                else
                    draw.Color(201, 201, 201, 255)
                end
                draw.Text(x + 5, item_y + 5, item)
                if IsMouseInBounds(x, item_y, x + w, item_y + item_height) and input.IsButtonPressed(MOUSE_LEFT) and not BlockInput then
                    Values[varName] = i
                    Dropdown_open = nil
                    BlockInput = true
                end
            end
        end
    end
end

return Dropdowns