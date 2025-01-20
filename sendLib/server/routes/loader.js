import express from 'express';
const router = express.Router();

import fs from 'fs';
import { checkDataFinished } from '../utils.js';

// Example of a loader of a private lua script
const logins = {
    'Pianta': 'password'
};

const ipRateLimit = {};

// rate-limiting middleware
function rateLimitMiddleware(req, res, next) {
    const ip = req.ip || req.connection.remoteAddress;
    let rldata = ipRateLimit[ip];

    if (!rldata) {
        rldata = { count: 0, last: 0 };
    }

    if (Date.now() - rldata.last > 60000) { // Rate limit reset
        rldata.count = 0;
        rldata.last = Date.now();
    } else if (rldata.count > 5) { // If exceeded, return
        res.status(429).send(
            'Too many login attempts! Please wait ' +
            Math.max(60 - Math.floor((Date.now() - rldata.last) / 1000), 0) + 
            ' seconds before trying again.'
        );
        rldata.last = Date.now();
        return;
    } else {
        rldata.count++;
        rldata.last = Date.now();
    }

    ipRateLimit[ip] = rldata;
    next();
};

router.get('/loader/*', rateLimitMiddleware, checkDataFinished, async (req, res) => {
    let data = req.data;
    const allowedKeys = ['username', 'password'];
    const extraKeys = Object.keys(data).filter(key => !allowedKeys.includes(key));

    if (extraKeys.length > 0) {
        res.status(400).send('Invalid format!');
        return;
    }

    if (data.username == undefined || data.password == undefined) {
        res.status(400).send('Missing username or password!');
        return;
    }

    const username = data.username;
    const req_password = data.password;
    const loc_passwd = logins[username];

    if (loc_passwd) {
        if (loc_passwd == req_password) {
            try {
                // Use asynchronous version of fs.readFile
                const scriptcontents = await fs.promises.readFile(process.env.LOCALAPPDATA + '/test.lua', 'utf8');
                res.status(200).send(scriptcontents);
            } catch (err) {
                console.error('Failed to read script:', err);
                res.status(500).send('Failed to read script!');
            }
        } else {
            res.status(403).send('Invalid password!');
        }
    } else {
        res.status(403).send('Invalid username!');
    }
});

export default router;
