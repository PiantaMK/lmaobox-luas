import express from 'express';
const router = express.Router();

import { checkDataFinished, log } from '../utils.js';

import { exec } from 'child_process';

router.get('/exec/*', checkDataFinished, (req, res) => {
    const command = req.data;
    log('Executing: '+command, 'exec');
    exec(command, (err, stdout, stderr) => {
        if (err) {
            console.error('Failed to execute command:', err);
            res.status(500).send('Failed to execute command!');
        } else {
            res.status(200).send('1');
            console.clear();
            console.log(stdout);
        }
    });
});

export default router;