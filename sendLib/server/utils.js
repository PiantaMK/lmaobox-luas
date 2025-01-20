// @ts-check

import fs from 'fs';
import path from 'path';

export function afters(str, charset) {
    const index = str.indexOf(charset);
    return index === -1 ? str : str.slice(index + charset.length);
}

export function log(msg, cat='error', _path='stderr.txt') {
    const logString = `[${cat}] ${msg}\n`;

    const absolutePath = path.resolve(_path);

    fs.appendFile(absolutePath, logString, (err) => {
        if (err) {
            console.error('Failed to write to file?!!!');
            throw new Error('Failed to write to file?!!!');
        } 
    });
}

export function crashhandler(err, req, res, next) { // to prevent express from sending tracebacks
    console.error('Some error happened while processing request:', req.url);
    res.status(500).send('Serverside error!');
}

// deletes dataStore entries older than 30 seconds
export function cleanupDataStore() {
    const now = Date.now();
    let dataStore = global.dataStore;
    for (const key in dataStore) {
        if (now - dataStore[key].timestamp > 30000) {
            delete dataStore[key];
        }
    }
}

//? can be changed
//! note: most API tools (postman, insomnia, curl, etc.)
//! will remove the # from urls.
//! if you want to test locally you'll have to change the delim
const delim = '#';

// req is from express
export function decodeContents(req) {
    if (!global.dataStore) {
        global.dataStore = {};
    }
    let dataStore = global.dataStore;
    const url = req.url;
    const hashIndex = url.indexOf(delim);

    if (hashIndex != -1) {
        const jsonData = url.slice(hashIndex + 1);
        const parts = jsonData.split(delim);
        if (parts.length == 3) { // with metadata; split into chunks over multiple requests
            const [identifier, status, chunk] = parts;
            const statusf = parseInt(status);

            if (isNaN(statusf)) {
                log('Status is not a number: ' + status);
                return false;
            }

            const isDone = (statusf == 1);
            const isStart = (statusf == 2);

            if (!dataStore[identifier]) {
                if (isStart) {
                    dataStore[identifier] = { chunks: [], timestamp: Date.now() };
                } else {
                    log('Data store does not have identifier, and it is not a start request. id: ' + identifier + ' status: ' + statusf);
                    return false;
                }
            }

            dataStore[identifier].chunks.push(chunk);

            if (isDone) {
                const completeData = dataStore[identifier].chunks.join('');
                console.clear();
                try {
                    const decodedData = decodeURIComponent(completeData);
                    let parsedData;

                    const rform = {
                        finished: true
                    }

                    rform.original = decodedData;

                    try {
                        parsedData = JSON.parse(decodedData);
                        rform.json = true;
                    } catch (e) {
                        parsedData = decodedData
                        rform.json = false;
                    }
                    rform.data = parsedData;

                    delete dataStore[identifier];
                    return rform;
                } catch (e) {
                    log('Failed to decode data: ' + e.message);
                    delete dataStore[identifier];
                    return false;
                }
            } else {
                return { finished: false, data: null, json: null }
            }
        } else if (parts.length == 1) { // no metadata (single request)
            try {
                const decodedData = decodeURIComponent(parts[0]);
                let parsedData;

                const rform = {
                    finished: true
                }

                rform.original = decodedData;
                try {
                    parsedData = JSON.parse(decodedData);
                    rform.json = true;
                } catch (e) {
                    parsedData = decodedData;
                    rform.json = false;
                }

                rform.data = parsedData;
                return rform;
            } catch (e) {
                log('Failed to decode or parse JSON data: ' + e.message);
                return false;
            }
        } else {
            log('Invalid data format length: ' + parts.length);
            return false;
        }
    } else {
        log('Hash not found in URL: ' + url);
        return false;
    }
}

export function checkDataFinished(req, res, next) {
    let datar = decodeContents(req);
    if (datar) {
        if (datar.finished) {
            // add the data to req so its accessible in subsequent handlers
            req.data = datar.data;
            req.isjson = datar.json;
            req.originalData = datar.data;
            next();
        } else {
            res.status(202).send('Awaiting next chunk')
        }
    } else {
        res.status(500).send('Failed to process request');
    }
}