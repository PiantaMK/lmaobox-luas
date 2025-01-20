-- change to whatever you want, this is just for localhost testing
local URL = "http://localhost:7090/"

if not json or not sendLib then
    print('initialising sendlib...')
    
    require('sendLib_load/')
    -- json.encode, json.decode and sendLib.Send
    -- are now available!
else
    print('sendlib already initialized')
end

--#region examples

--? send data over the internet
local function sendnet(data)
    local resp = sendLib.Send(data, URL .. 'ipc/')


    print("------------network req successful!--------------")
    print("req count: " .. resp.reqnum)
    print("unescaped len: " .. #json.encode(data))
    print("resp: " .. json.encode(resp.responses))
    print("-------------------------------------------------")
end

--? send data over local fs (for debug only)
local function sendfile(data)
    data = json.encode(data)

    local filepath = "tempfile" .. tostring(math.random(897345, 98723654)) .. ".tmp"

    local file = io.open(filepath, "w")
    if not file then
        print('Client Error: Creating file failed!')
        return false
    end

    file:write(data)
    file:close()

    local resp = sendLib.Send(filepath, URL .. 'fileipc/')

    print("--------------filereq successful!----------------")
    print("filepath: " .. filepath)
    print("filelen: " .. #json.encode(data))
    print("resp: " .. json.encode(resp.responses))
    print("req count: " .. resp.reqnum)
    if resp.responses ~= '1' then
        print("response ~= '1', deleting tempfile...")
        local deleteStatus = os.remove(filepath)
        if deleteStatus then
            print("File deleted successfully!")
        else
            print("Error: Failed to delete the file.")
        end
    end
    print("-------------------------------------------------")
end

--! testing code below
local tests = {
    {name = "test1", value = 1},
    {name = "test2", value = 2},
    {name = "test3", value = 3},
}

for i = 1, 1000 do
    table.insert(tests, {name = "test" .. i, value = i})
end

local filedebug = false
if filedebug then
    sendfile(tests)
else
    sendnet(tests)
end

--#endregion examples