Window = {
    font = draw.CreateFont("Tahoma", 12, 400, FONTFLAG_DROPSHADOW)
}

local window_state = {}
local previous_lmb = false
function Window:SetupWindow(window_id, m_x, m_y, m_width, m_height, enable_dragging, enable_tabs)
    draw.SetFont(Window.font)
    if not window_state[window_id] then
        window_state[window_id] = {
            dragging = false,
            drag_offset_x = 0,
            drag_offset_y = 0,
            x = m_x,
            y = m_y,
            width = m_width,
            height = m_height,
            enable_dragging = enable_dragging
        }
    end

    local window = window_state[window_id]

    if MENU_OPEN then
        draw.Color(5, 5, 5, 255)
        draw.FilledRect(window.x, window.y, window.x + window.width, window.y + window.height)
        draw.Color(60, 60, 60, 255)
        draw.FilledRect(window.x + 2, window.y + 2, window.x + window.width - 4, window.y + window.height - 4)
        draw.Color(40, 40, 40, 255)
        draw.FilledRect(window.x + 3, window.y + 3, window.x + window.width - 6, window.y + window.height - 6)
        draw.FilledRect(window.x + 4, window.y + 4, window.x + window.width - 8, window.y + window.height - 8)
        draw.Color(60, 60, 60, 255)
        draw.FilledRect(window.x + 5, window.y + 5, window.x + window.width - 10, window.y + window.height - 10)
        draw.Color(5, 5, 5, 255)
        draw.FilledRect(window.x + 6, window.y + 6, window.x + window.width - 12, window.y + window.height - 12)

        local mouseX, mouseY = input.GetMousePos()[1], input.GetMousePos()[2]
        local LMBDown = input.IsButtonDown(MOUSE_LEFT)

        if Tabs and enable_tabs then
            local num_tabs = #Tabs
            local tab_spacing = 5
            local tab_width = Round((window.width - 28 - (num_tabs - 1) * tab_spacing) / num_tabs)  -- calculate the width of each tab
            local first_tab_x_start = window.x + 11  -- start of the first tab
            local last_tab_x_end = first_tab_x_start + (num_tabs - 1) * (tab_width + tab_spacing) + tab_width  -- end of the last tab
        
            for i, p in ipairs(Tabs) do
                local tab_x_start = window.x + 11 + (i - 1) * (tab_width + tab_spacing)
                local tab_x_end = tab_x_start + tab_width
                if CURRENT_TAB == p then
                    draw.Color(178, 4, 41, 255)
                    draw.FilledRect(tab_x_start, window.y + 30, tab_x_end, window.y + 36)
                    draw.Color(0, 0, 0, 255)
                    draw.FilledRectFade(tab_x_start, window.y + 30, tab_x_end, window.y + 36, 0, 150, false)
                else
                    draw.Color(69, 69, 69, 255)
                    draw.FilledRect(tab_x_start, window.y + 30, tab_x_end, window.y + 36)
                    draw.Color(0, 0, 0, 255)
                    draw.FilledRectFade(tab_x_start, window.y + 30, tab_x_end, window.y + 36, 0, 150, false)
                end
                local tx, ty = draw.GetTextSize(p)
                draw.Color(201, 201, 201, 255)
                draw.Text(tab_x_start + (tab_width // 2) - (tx // 2), window.y + 15, p)

            end
        
            draw.Color(44, 44, 44, 255)
            draw.OutlinedRect(first_tab_x_start, window.y + 45, last_tab_x_end, window.y + window.height - 18)
        
            if LMBDown and not previous_lmb then
                for i, p in ipairs(Tabs) do
                    local tab_x_start = window.x + 11 + (i - 1) * (tab_width + tab_spacing)
                    local tab_x_end = tab_x_start + tab_width
                    if IsMouseInBounds(tab_x_start, window.y + 10, tab_x_end, window.y + 36) then
                        CURRENT_TAB = p
                    end
                end
            end
        end


        if window.enable_dragging then
            for id, win in pairs(window_state) do
                if IsMouseInBounds(win.x, win.y, win.x + win.width, win.y + win.height) and not IsMouseInBounds(win.x + 6, win.y + 6, win.x + win.width - 12, win.y + win.height - 12) then
                    if LMBDown and not previous_lmb then
                        if not win.dragging then
                            win.dragging = true
                            win.drag_offset_x = mouseX - win.x
                            win.drag_offset_y = mouseY - win.y
                        end
                    end
                end

                if win.dragging then
                    if LMBDown then
                        win.x = mouseX - win.drag_offset_x
                        win.y = mouseY - win.drag_offset_y
                    else
                        win.dragging = false
                    end
                end
            end
        end

        previous_lmb = LMBDown

        return window.x, window.y
    end
end

return Window