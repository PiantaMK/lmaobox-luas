local f = "\x66\x75\x63\x6b\x69\x6e\x67"
local e = "www.EZFrags.co.uk"

local cheat_names = {
    "lmaobox", "fedoraware", "nullcore", "sickcheat"
}

local features = {
    "aimbot", "visuals", "resolver", "lagswitch", "prediction", "gamingcarpet",
    "imaginary girlfriend", "keybind", "knifechanger", "vip hack",
    "window capture", "settings", "internet", "computer", "mother",
    "config", "brain", "screen capture", "steeringwheel assistance",
    "serverside", "kfg", "minecraft cheat"
}

local adjectives = {
    "interesting", "lol", "nice", "plz give", "cool", "awesome",
    "breathtaking", "insane", "refund", "ahahahahah", "good", "fantastic",
    "crazy", "amazing", "astonishing", "lidl", "mcdonalds", "shit", "nice " .. f,
    "laughing my ass off about", "xDDDDDDDD", "crying emoji"
}

local endings = {
    "uid", "paste", "IQ", "antiaim", "gamingcarpet", "lethality",
    "computer", "visuals", "VIP hack", "window capture", "death",
    "settings", "mother", "config", "brain", "screen capture", "steeringwheel assistance",
    "serverside", "kfg", "minecraft cheat"
}

local ezfrags = {
    "Think you could do better? Not without " .. e,
    "If I was cheating, I'd use " .. e,
    "I'm not using " .. e .. ", you're just bad",
    "Visit " .. e .. " for the finest public & private TF2 cheats",
    "Stop being a noob! Get good with " .. e,
    "You just got pwned by " .. e .. ", the #1 TF2 cheat"
}

local function generate_callout()
    local start = adjectives[math.random(#adjectives)]
    local category = math.random(1, 5)

    local finish
    if category == 1 then
        finish = cheat_names[math.random(#cheat_names)]
    elseif category == 2 then
        finish = features[math.random(#features)]
    elseif category == 3 then
        finish = endings[math.random(#endings)]
    elseif category == 4 then
        finish = ezfrags[math.random(#ezfrags)]
    else
        finish = endings[math.random(#endings)]
    end

    if category == 4 then
        return finish
    elseif start == "refund"
            or start == "laughing my ass off about"
            or start == "ahahahahah"
            or start == "xDDDDDDDD"
            or start == "lol" 
            then
        return start .. " that " .. finish
    else
        return start .. " " .. finish
    end
end

local lastCalloutTime = 0
local calloutInterval = 10

callbacks.Register("Draw", function()
    local currentTime = globals.RealTime()
    if currentTime - lastCalloutTime >= calloutInterval then
        client.ChatSay(generate_callout())
        lastCalloutTime = currentTime
    end
end)