import express from 'express';
const router = express.Router();

import { checkDataFinished } from '../utils.js';

router.get('/ipc/*', checkDataFinished, (req, res) => {
    console.clear();
    console.log(req.data); // do whatever you want with the data
    console.log('data is ' + (!req.isjson ? 'not ' : '') + 'json');
    // if (req.isjson) {
    //     console.log('original string:', req.originalData)
    // }
    console.log('data len:', String(req.originalData).length)
    res.status(200).send('1'); // status code does not matter
});

export default router;