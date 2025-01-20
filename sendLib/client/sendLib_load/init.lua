-- https://i.postimg.cc/MKmP2mym/image.png
local MAX_URL_LENGTH = 16344

--#region external
-- if not http then -- outside of lbox
--     http = {}
--     local function _get(url)
--         local handle = io.popen("curl -s -m 5 " .. url)
--         if not handle then return '' end
--         local responses = handle:read("*a")
--         handle:close()
--         return responses
--     end
--     http.Get = _get
-- end
--#endregion external

--#region setup & utils
if not json then -- dependency
    local dkjson = load(http.Get("http://dkolf.de/dkjson-lua/dkjson-2.8.lua"))()
    
    assert(dkjson, "Failed to load dkjson")
    json = {} -- global

    ---@diagnostic disable-next-line: duplicate-set-field
    function json.encode(data)
        return dkjson.encode(data)
    end
    
    ---@diagnostic disable-next-line: duplicate-set-field
    function json.decode(data)
        return dkjson.decode(data)
    end
end

local function isalphaordigit(c)
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9')
end

local function encodeURI(str) -- also prevents 'xss' (faking # metadata)
    local res = ""
    for i = 1, #str do
        local c = str:sub(i, i)
        if isalphaordigit(c) or c == ' ' then
            res = res .. c
        else
            res = res .. string.format("%%%02X", string.byte(c))
        end
    end
    return res
end
--#endregion setup & utils

print('Setting up sendLib...')

local function sendChunks(data, sendto)
    if type(data) == "table" then
        data = tostring(json.encode(data))
    end
    data = encodeURI(data)

    local base = sendto .. '#'
    local identifier = tostring(math.random(1, 100000000)) -- unique id
    local urls = {} -- client requests
    local responses = {} -- server responses(s)

    -- check if we can send in one go
    if #(base .. data) <= MAX_URL_LENGTH then -- example: http://localhost:8080/ipc/#somedata
        urls = {base .. data}
        data = ''
    end
    
    while #data ~= 0 do -- example: http://localhost:8080/ipc/#123143#0#somedata
        local start = base .. identifier .. '#0#'
        local spaceleft = MAX_URL_LENGTH - #start

        if #urls == 0 then
            start = start:gsub('#0#', '#2#') -- start tag
        end

        if #data > spaceleft then -- extract the portion that fits
            local extract = data:sub(1, spaceleft)
            data = data:sub(spaceleft + 1)

            table.insert(urls, start .. extract)
        else -- last chunk
            start = start:gsub('#0#', '#1#') -- end tag
            table.insert(urls, start .. data)
            data = ''
        end
    end

    for i, url in ipairs(urls) do
        if #url > MAX_URL_LENGTH then
            print('URL OVERFLOW???!!!! size: ' .. #url)
        end
        local res = http.Get(url)
        if res == '' then -- no response from server
            responses = {}
            break
        end
        table.insert(responses, res)
    end

    if #responses == 1 then
        responses = responses[1]
    end

    return {reqnum = #urls, responses = responses}
end

--global
sendLib = {
    Send = sendChunks
}