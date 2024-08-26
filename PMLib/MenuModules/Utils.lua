Utils = {}

------------------------------------------------------------ GLOBALS ------------------------------------------------------------
KeyTable={[1]="0",[2]="1",[3]="2",[4]="3",[5]="4",[6]="5",[7]="6",[8]="7",[9]="8",[10]="9",[11]="a",[12]="b",[13]="c",[14]="d",[15]="e",[16]="f",[17]="g",[18]="h",[19]="i",[20]="j",[21]="k",[22]="l",[23]="m",[24]="n",[25]="o",[26]="p",[27]="q",[28]="r",[29]="s",[30]="t",[31]="u",[32]="v",[33]="w",[34]="x",[35]="y",[36]="z",[37]="num 0",[38]="num 1",[39]="num 2",[40]="num 3",[41]="num 4",[42]="num 5",[43]="num 6",[44]="num 7",[45]="num 8",[46]="num 9",[47]="num divide",[48]="num multiply",[49]="num minus",[50]="num plus",[51]="num enter",[52]="num decimal",[53]="lbracket",[54]="rbracket",[55]="semicolon",[56]="apostrophe",[57]="backquote",[58]="comma",[59]="period",[60]="slash",[61]="backslash",[62]="minus",[63]="equal",[64]="enter",[65]="space",[66]="backspace",[67]="tab",[68]="caps lock",[69]="num lock",[70]="escape",[71]="scroll lock",[72]="insert",[73]="delete",[74]="home",[75]="end",[76]="pageup",[77]="pagedown",[78]="break",[79]="lshift",[80]="rshift",[81]="lalt",[82]="ralt",[83]="lcontrol",[84]="rcontrol",[85]="lwin",[86]="rwin",[87]="app",[88]="up",[89]="left",[90]="down",[91]="right",[92]="f1",[93]="f2",[94]="f3",[95]="f4",[96]="f5",[97]="f6",[98]="f7",[99]="f8",[100]="f9",[101]="f10",[102]="f11",[103]="f12",[104]="caps lock toggle",[105]="num lock toggle",[106]="scroll lock toggle",[107]="mouse1",[108]="mouse2",[109]="mouse3",[110]="mouse4",[111]="mouse5",[112]="mousewheel up",[113]="mousewheel down"}
-- for keybinds
InputTable={[1]="0",[2]="1",[3]="2",[4]="3",[5]="4",[6]="5",[7]="6",[8]="7",[9]="8",[10]="9",[11]="a",[12]="b",[13]="c",[14]="d",[15]="e",[16]="f",[17]="g",[18]="h",[19]="i",[20]="j",[21]="k",[22]="l",[23]="m",[24]="n",[25]="o",[26]="p",[27]="q",[28]="r",[29]="s",[30]="t",[31]="u",[32]="v",[33]="w",[34]="x",[35]="y",[36]="z",[37]="0",[38]="1",[39]="2",[40]="3",[41]="4",[42]="5",[43]="6",[44]="7",[45]="8",[46]="9",[47]="/",[48]="*",[49]="-",[50]="+",[53]="[",[54]="]",[55]=";",[56]="'",[57]="`",[58]=",",[59]=".",[60]="/",[61]="\\",[62]="-",[63]="=",[65]=" ",[67]="    "}
-- for text input
------------------------------------------------------------- UTILS -------------------------------------------------------------

local lastToggleTime = 0
function Utils:ToggleMenu()
    local currentTime = globals.RealTime()
    if currentTime - lastToggleTime >= 0.1 then
        MENU_OPEN = not MENU_OPEN

        collectgarbage("collect")
        -- collects garbage every time the menu is opened or closed
        -- band aid fix, will lag the game for a split second
        -- if you are using other luas with memleaks
        
        lastToggleTime = currentTime
    end
end

function Utils:CheckMenu() -- credits: muqa
    if input.IsButtonPressed(KEY_END) or input.IsButtonPressed(KEY_INSERT) or input.IsButtonPressed(KEY_F11) then 
        Utils:ToggleMenu()
    end
end

function GetPressedKey()
    for i = 1, 113 do 
        if input.IsButtonPressed(i) then
            if i ~= 107 and i ~= 75 and i ~= 72 and i ~= 108 then 
                return i
            end
        end
    end
end

---@param num number
function Round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

---@param x number
---@param y number
---@param x2 number
---@param y2 number
function IsMouseInBounds(x,y,x2,y2)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    if mX >= x and mX <= x2 and mY >= y and mY <= y2 then
        return true 
    end
    return false
end

------------------------------------------------------------- DEBUG -------------------------------------------------------------

local function getMemoryUsage()
    local mem = collectgarbage("count") / 1024
    if mem > 800 then
        collectgarbage("collect")
        mem = collectgarbage("count") / 1024
    end
    return mem
end

local dbg_font = draw.CreateFont("Lucida Console", 10, 0, 512)
---@param memonly boolean
---memonly will only show memory usage
function Utils:DrawDebugInfo(memonly)
    if not Values.show_debug_info then return end
    draw.SetFont(dbg_font)
    draw.Color(230, 230, 180, 255)

    local dbgx = 10
    local dbgy = 200
    local i = 1

    draw.Text(dbgx, dbgy - 12, "Memory usage: " .. string.format("%.2f", getMemoryUsage()) .. " MB")
    if not memonly then
        draw.Text(dbgx, dbgy, "Values:")
        for key, value in pairs(Values) do
            if type(value) == "table" then
                local entries = {}
                for _, entry in ipairs(value) do
                    table.insert(entries, tostring(entry))
                end
                local entries_str = "{" .. table.concat(entries, ", ") .. "}"

                draw.Text(dbgx, dbgy + i * 12, key .. " - " .. entries_str)
            else
                draw.Text(dbgx, dbgy + i * 12, key .. " - " .. tostring(value))
            end

            i = i + 1
        end
    end
end

return Utils