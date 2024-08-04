local words = {
    f_word = "\x66\x75\x63\x6b\x69\x6e\x67",
    ezfrags = "www.EZFrags.co.uk"
}

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
    "crazy", "amazing", "astonishing", "lidl", "mcdonalds", "shit", "nice " .. words.f_word,
    "laughing my ass off about", "xDDDDDDDD", "crying emoji"
}

local endings = {
    "uid", "paste", "IQ", "antiaim", "gamingcarpet", "lethality",
    "computer", "visuals", "VIP hack", "window capture", "death",
    "settings", "mother", "config", "brain", "screen capture", "steeringwheel assistance",
    "serverside", "kfg", "minecraft cheat"
}

local ezfrags = {
    "Think you could do better? Not without " .. words.ezfrags,
    "If I was cheating, I'd use " .. words.ezfrags,
    "I'm not using " .. words.ezfrags .. ", you're just bad",
    "Visit " .. words.ezfrags .. " for the finest public & private TF2 cheats",
    "Stop being a noob! Get good with " .. words.ezfrags,
    "You just got pwned by " .. words.ezfrags .. ", the #1 TF2 cheat"
}

local function generate_callout()
    local start = adjectives[math.random(#adjectives)]
    local chosen_category = math.random(1, 5)

    local finish
    if chosen_category == 1 then
        finish = cheat_names[math.random(#cheat_names)]
    elseif chosen_category == 2 then
        finish = features[math.random(#features)]
    elseif chosen_category == 3 then
        finish = endings[math.random(#endings)]
    elseif chosen_category == 4 then
        finish = ezfrags[math.random(#ezfrags)]
    else
        finish = endings[math.random(#endings)]
    end

    if chosen_category == 4 then
        return finish
    elseif start == "refund" or start == "laughing my ass off about" or start == "ahahahahah" or start == "xDDDDDDDD" or start == "lol" then
        return start .. " that " .. finish
    else
        return start .. " " .. finish
    end
end

local function send_chat_message()
    local callout = generate_callout()
    client.ChatSay(callout)
end

callbacks.Register("Draw", function()
    local currentTime = globals.RealTime()
    if currentTime % 10 == 0 then -- % X is the intreval between messages
        send_chat_message()
    end
end)
