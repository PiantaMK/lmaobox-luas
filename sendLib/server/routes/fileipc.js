import express from 'express';
const router = express.Router();

import fs from 'fs';
import path from 'path';

import { checkDataFinished, log } from '../utils.js';
import { tf2_path } from '../config.js';

// Middleware to check if request is from localhost
function isLocalhost(req, res, next) {
    const isLocal = req.ip === '127.0.0.1' || req.ip === '::1';
    if (!isLocal) {
        return res.status(403).send('Forbidden: Only requests from localhost are allowed');
    }
    next();
};

router.get('/fileipc/*', isLocalhost, checkDataFinished, async (req, res) => {
    if (!tf2_path.length) {
        return res.status(500).send('No TF2 Path set!');
    }

    const filename = req.data;
    const filepath = path.join(tf2_path, filename);

    try {
        await fs.promises.access(filepath, fs.constants.F_OK);

        const data = await fs.promises.readFile(filepath, 'utf8');
        let dataf;
        try {
            dataf = JSON.parse(data);
        } catch {
            dataf = data;
        }

        await fs.promises.unlink(filepath);

        res.status(200).send('1');
    } catch (err) {
        if (err.code === 'ENOENT') {
            log('TF2 path not found!', 'fileipc');
            res.status(404).send('File not found!');
        } else {
            console.error('Failed to handle file:', err);
            res.status(500).send('Failed to process file!');
        }
    }
});

export default router;
