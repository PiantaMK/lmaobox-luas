# SendLib by Pianta

### Installation (client)
---
1. Put the contents of /client/ in %localappdata%.
2. execute the script in your lua with `.
3. `sendLib.Send` has been added as a global! (also `json.encode` and `json.decode`)
4. You can now send data over the internet in your programs using these APIs.

### Installation (server)
1. Install NodeJS and npm if you already don't have it.
2. Put the contents of /server/ in %localappdata%.
3. Go into the directory of the server in your command prompt.
4. Install express using `npm install express`.
5. Edit `config.js` to your liking.
5. Run the script using `node httpserver.js`.

### Included examples
---
- `ipc/` - Communicate over the internet.
- `fileipc/` - Communicate over the host's file system. Debug only. (disabled by default)
- `exec/` - Make the host execute commands send over the internet. Very unsafe. (disabled by default)
- `loader/` - A proof of concept for a backend loader of a private lua script. Just an example. (disabled by default)

---

# Creating your own route (serverside)

### Prerequisites
- Use `express.Router()`, not `express()`.
- **Only the `.get` should be use**.
- **`checkDataFinished` middleware** is highly recommended to ensure that data is fully processed.
- The router **must be exported as `default`**.

### Steps to Create a New Route

1. **Set up your Router**  
   To create a new route, first import the necessary modules and initialize a new router using `express.Router()`.

   ```javascript
   import express from 'express';
   const router = express.Router();
   ```

2. **Use `checkDataFinished` Middleware (strongly reccomended)**  
   Using it calls your code if data transfer is finished

   ```javascript
   import { checkDataFinished } from '../utils.js'; // import the middleware

   router.get('/your-route/*', checkDataFinished, (req, res) => {
       // checkDataFinished only calls your code if data transfer is finished
       console.log(req.data);
       console.log('data is ' + (!req.isjson ? 'not ' : '') + 'json');
       res.status(200).send('1'); // note: status code doesnt matter
   });
   ```

3. **Export the Router**  
   Make sure to export the router as `default`.

   ```javascript
   export default router;
   ```

4. **Add your file to `enabled` dict**  
    Specify your filename in the `enabled` dict in `config.js`.

    Before:

    ```javascript
    export const enabled = {
        'ipc.js': true,     
        'fileipc.js': false,
        'exec.js': false,   
        'loader.js': false
    };
    ```

    After:

    ```javascript
    export const enabled = {
        'ipc.js': true,     
        'fileipc.js': false,
        'exec.js': false,   
        'loader.js': false,
        'myfilename.js': true
    };
    ```

### Full Example Code

Here's how the full code looks when you put everything together:

```javascript
import express from 'express';
const router = express.Router();

import { checkDataFinished } from '../utils.js';

router.get('/ipc/*', checkDataFinished, (req, res) => {
    console.clear();
    console.log(req.data); // do whatever you want with the data
    console.log('data is ' + (!req.isjson ? 'not ' : '') + 'json');
    if (req.isjson) {
        console.log('original string:', req.originalData)
    }
    res.status(200).send('1'); // status code does not matter
});

export default router;
```

# Implementing in lua (clientside)

1. Initialize sendLib

```lua
-- change to whatever you want, this is just for localhost testing
local URL = "http://localhost:7090/"  -- URL to send data to

-- check if `json` and `sendLib` are available, and initialize if not
if not json or not sendLib then
    print('initialising sendlib...')
    
    require('sendLib_load/')  -- loading the library
    -- now, json.encode, json.decode and sendLib.Send are available for usage
else
    print('sendlib already initialized')
end
```

2. Start sending data using sendLib.Send

```lua
-- send data over the internet (network request)

local data = {teststr = "test1", testval = 1}
local resp = sendLib.Send(data, URL .. 'ipc/') -- in this example: http://localhost:7090/ipc/

print("------------network request successful!--------------")
print("request count: " .. resp.reqnum)  -- number of requests sent
print("unescaped data length: " .. #json.encode(data))  -- length of the encoded data
print("response(s): " .. json.encode(resp.responses))  -- server response(s)
print("-------------------------------------------------")
```