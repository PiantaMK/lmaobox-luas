-- menu pos options
local baseX = 100
local baseY = 100
local rectWidth = 360
local rectHeight = 200

-- game setup options
local rows = 10
local cols = rows * 2
local padding = 1
local topSpace = 17

-- game options
local text = "Minesweeper"
local numBombs = 30

-- menu toggle state
local lastToggleTime = 0
local Lbox_Menu_Open = true

-- game state
local gameOver = false
local debugMode = false



local grid = {}
local revealed = {}
for row = 1, rows do
    grid[row] = {}
    revealed[row] = {}
    for col = 1, cols do
        grid[row][col] = 0 -- 0 means no bomb
        revealed[row][col] = false -- not revealed
    end
end

local function generateBombs()
    local bombCount = 0
    while bombCount < numBombs do
        local row = math.random(1, rows)
        local col = math.random(1, cols)
        if grid[row][col] == 0 then
            grid[row][col] = -1 -- -1 means bomb
            bombCount = bombCount + 1
        end
    end
end

-- how many bombs around each tile
local function calculateNumbers()
    for row = 1, rows do
        for col = 1, cols do
            if grid[row][col] ~= -1 then
                local count = 0
                for dr = -1, 1 do
                    for dc = -1, 1 do
                        local r = row + dr
                        local c = col + dc
                        if r > 0 and r <= rows and c > 0 and c <= cols and grid[r][c] == -1 then
                            count = count + 1
                        end
                    end
                end
                grid[row][col] = count
            end
        end
    end
end

local function checkWinCondition()
    for row = 1, rows do
        for col = 1, cols do
            if grid[row][col] ~= -1 and not revealed[row][col] then
                return false  -- Found a non-bomb square that is not revealed
            end
        end
    end
    return true  -- All non-bomb squares are revealed
end


generateBombs()
calculateNumbers()

local leftMousePressed = false

local function toggleMenu()
    local currentTime = globals.RealTime()
    if currentTime - lastToggleTime >= 0.1 then
        Lbox_Menu_Open = not Lbox_Menu_Open
        lastToggleTime = currentTime
    end
end

local function NonMenuDraw()
    if input.IsButtonPressed(KEY_INSERT) or input.IsButtonPressed(KEY_F11) or input.IsButtonPressed(KEY_DELETE) then
        toggleMenu()
    end
end

callbacks.Register("Draw", "NonMenuDraw", NonMenuDraw)

local function IsMouseInBounds(x, y, x2, y2)
    if gameOver then
        return false
    end

    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    return mX >= x and mX <= x2 and mY >= y and mY <= y2
end

local function revealSquare(row, col)
    if not revealed[row][col] then
        revealed[row][col] = true
        if grid[row][col] == -1 then
            gameOver = true
        elseif checkWinCondition() then
            gameOver = true
        end
    end
end


local function drawTable()
    if Lbox_Menu_Open == true then
        local fontoption = gui.GetValue('Font')
        local font = draw.CreateFont(fontoption, 12, 400, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)

        local squareWidth = (rectWidth - 2 * padding) / cols
        local squareHeight = (rectHeight - topSpace - padding) / rows

        draw.Color(255, 255, 255, 255)
        draw.FilledRect(baseX, baseY, baseX + rectWidth, baseY + rectHeight)
        draw.SetFont(font)
        local tx, ty = draw.GetTextSize(text)
        draw.Text(baseX + rectWidth // 2 - (tx // 2), baseY + 2, text)

        if debugMode then 
            draw.Color(255, 0, 0, 50)
            draw.FilledRect(baseX, baseY - 10, baseX + rectWidth, baseY + topSpace)
            draw.Color(255, 255, 255, 255)
        end

        if IsMouseInBounds(baseX, baseY - 10, baseX + rectWidth, baseY + topSpace) and input.IsButtonDown(MOUSE_LEFT)then
            local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
            baseX = mX - baseX // 2
            baseY = mY
        end

        for row = 0, rows - 1 do
            for col = 0, cols - 1 do
                local x = baseX + padding + col * squareWidth
                local y = baseY + topSpace + padding + row * squareHeight

                if IsMouseInBounds(x, y, x + squareWidth, y + squareHeight) and input.IsButtonDown(MOUSE_LEFT) and not leftMousePressed and not gameOver then
                    revealSquare(row + 1, col + 1)
                    leftMousePressed = true
                elseif not input.IsButtonDown(MOUSE_LEFT) then
                    leftMousePressed = false
                end

                if revealed[row + 1][col + 1] or debugMode then
                    if grid[row + 1][col + 1] == -1 then
                        draw.Color(255, 0, 0, 255) -- red for bomb
                    else
                        draw.Color(255, 255, 255, 255) -- white for revealed
                    end
                    draw.FilledRect(math.floor(x), math.floor(y), math.floor(x + squareWidth - 1), math.floor(y + squareHeight - 1))
                    if grid[row + 1][col + 1] ~= -1 and (debugMode or revealed[row + 1][col + 1]) and not gameOver then
                        local textWidth, textHeight = draw.GetTextSize(tostring(grid[row + 1][col + 1]))
                        draw.Text(math.floor(x + squareWidth / 2 - textWidth / 2), math.floor(y + squareHeight / 2 - textHeight / 2), tostring(grid[row + 1][col + 1]))
                    end
                else
                    draw.Color(0, 0, 0, 255) -- black for unrevealed
                    draw.FilledRect(math.floor(x), math.floor(y), math.floor(x + squareWidth - 1), math.floor(y + squareHeight - 1))
                end
            end
        end

        if gameOver then
            if checkWinCondition() then
                draw.Color(0, 255, 0, 255)  -- Green color for win message
                draw.Text(baseX + rectWidth // 2 - (tx // 2), baseY + rectHeight // 2, "You Win!")
            else
                draw.Color(255, 0, 0, 255)  -- Red color for game over message
                draw.Text(baseX + rectWidth // 2 - (tx // 2), baseY + rectHeight // 2, "Game Over")
            end
        end
        
    end
end

callbacks.Register("Draw", "drawTable", drawTable)

local function toggleDebugMode()
    if input.IsButtonPressed(KEY_F1) then
        debugMode = not debugMode
    end
end

callbacks.Register("Draw", "toggleDebugMode", toggleDebugMode)
