import express from 'express';
import path from 'path';

import { readdir } from 'fs/promises';
import { pathToFileURL, fileURLToPath } from 'url';

import * as u from './utils.js';
import { enabled, port } from './config.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

process.chdir(__dirname);

const app = express();

// load all routes dynamically
(async () => {
    const routesPath = path.resolve('./routes');
    const routeFiles = await readdir(routesPath);

    for (const file of routeFiles) {
        const isEnabled = enabled[file]
        if (isEnabled === true) {
            const fileURL = pathToFileURL(path.join(routesPath, file)).href;
            const routeModule = await import(fileURL); // convert path to file:// URL
            app.use(routeModule.default);
            console.log(`${file} is enabled.`);
        } else if (isEnabled === false) {
            console.log(`${file} is disabled.`);
        } else {
            throw new Error(`File ${file} is not presend in the 'enabled' dict? Check config.js!`)
        }
    }

    app.use(u.crashhandler);
    setInterval(u.cleanupDataStore, 1000);

    app.listen(port, '0.0.0.0', () => {
        console.log(`Server running at http://localhost:${port}/`);
    });
})();
