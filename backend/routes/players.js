const express = require('express');
const mysql = require('mysql');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'Cecio',
    password: 'password',
    database: 'fantainfo'
});

connection.connect();

const router = express.Router();


router.get('/', (req, res) => {
    let addQuery = '';

    if(req.query.position !== undefined)
        addQuery += `WHERE position='${req.query.position}'`;

    connection.query(`SELECT * FROM players ${addQuery} ORDER BY quotation DESC`, (error, result) => {
        if(error) throw error;

        res.json(result);
    });
});


router.get('/:id', (req, res) => {
    connection.query(`SELECT * FROM players WHERE id_player=${req.params.id}`, (error, result) => {
       if(error) throw error;
       
       res.json(result);
    });
});

module.exports = router;