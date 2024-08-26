-- repaste from some aimware lua

local activeHitLogs = {};
local font = draw.CreateFont('Arial', 14, 14, 0);

local function add(time, ...)
    table.insert(activeHitLogs, {
        ["text"] = { ... },
        ["time"] = time,
        ["delay"] = globals.RealTime() + time,
        ["color"] = {{150, 185, 1}, {16, 0, 0}},
        ["x_pad"] = -11,
        ["x_pad_b"] = -11,
    })
end

local function getMultiColorTextSize(lines)
    local fw = 0
    local fh = 0;
    for i = 1, #lines do
        draw.SetFont(font);
        local w, h = draw.GetTextSize(lines[i][4])
        fw = fw + w
        fh = h;
    end
    return fw, fh
end

local function drawMultiColorText(x, y, lines)
    local x_pad = 0
    for i = 1, #lines do
        local line = lines[i];
        local r, g, b, msg = line[1], line[2], line[3], line[4]
        draw.SetFont(font);
        draw.Color(r, g, b, 255);
        draw.Text(x + x_pad, y, msg);
        local w, _ = draw.GetTextSize(msg)
        x_pad = x_pad + w
    end
end

local function showLog(count, color, text, layer)
    local y = 15 + (42 * (count - 1));
    local w, h = getMultiColorTextSize(text)
    local mw = w < 150 and 150 or w
    if globals.RealTime() < layer.delay then
        if layer.x_pad < mw then layer.x_pad = layer.x_pad + (mw - layer.x_pad) * 0.05 end
        if layer.x_pad > mw then layer.x_pad = mw end
        if layer.x_pad > mw / 1.09 then
            if layer.x_pad_b < mw - 6 then
                layer.x_pad_b = layer.x_pad_b + ((mw - 6) - layer.x_pad_b) * 0.05
            end
        end
        if layer.x_pad_b > mw - 6 then
            layer.x_pad_b = mw - 6
        end
    else
        if layer.x_pad_b > -11 then
            layer.x_pad_b = layer.x_pad_b - (((mw - 5) - layer.x_pad_b) * 0.05) + 0.01
        end
        if layer.x_pad_b < (mw - 11) and layer.x_pad >= 0 then
            layer.x_pad = layer.x_pad - (((mw + 1) - layer.x_pad) * 0.05) + 0.01
        end
        if layer.x_pad < 0 then
            table.remove(activeHitLogs, count)
        end
    end
    local c1 = color[1]
    local c2 = color[2]
    local a = 255;
    draw.Color(c1[1], c1[2], c1[3], a);
    draw.FilledRect(math.floor(layer.x_pad - layer.x_pad), math.floor(y), math.floor(layer.x_pad + 28), math.floor((h + y) + 20));
    draw.Color(c2[1], c2[2], c2[3], a);
    draw.FilledRect(math.floor(layer.x_pad_b - layer.x_pad), math.floor(y), math.floor(layer.x_pad_b + 22), math.floor((h + y) + 20));
    drawMultiColorText(math.floor(layer.x_pad_b - mw + 18), math.floor(y + 9), text)
end

local function damageLogger(event)

    if (event:GetName() == 'player_hurt') then
        local localPlayer = entities.GetLocalPlayer()
        local victim = entities.GetByUserID(event:GetInt("userid"))
        local health = event:GetInt("health")
        local attacker = entities.GetByUserID(event:GetInt("attacker"))
        local damage = event:GetInt("damageamount")

        if (attacker == nil or localPlayer:GetIndex() ~= attacker:GetIndex() or localPlayer:GetIndex() == victim:GetIndex()) then
            return
        end

        --local message = victim:GetName() .. " -" .. damage .. " hp (" .. health .. " left)"
      
        add(5,
        { 255, 255, 255, "Hit " },
        { 150, 185, 1, string.sub(victim:GetName(), 0, 28) },
        { 255, 255, 255, " for " },
        { 150, 185, 1, damage },
        { 255, 255, 255, " damage (" },
        { 150, 185, 1, health .. " health remaining" },
        { 255, 255, 255, ")" }
        )
    end
end

callbacks.Register("FireGameEvent", "exampledamageLogger", damageLogger)

callbacks.Register('Draw', function()
    for index, hitlog in pairs(activeHitLogs) do
        showLog(index, hitlog.color, hitlog.text, hitlog)
    end
end);