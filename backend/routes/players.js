const express = require("express");
const mysql = require("mysql");

const connection = mysql.createConnection({
  host: "localhost",
  user: "Cecio",
  password: "password",
  database: "fantainfo"
});

connection.connect();

const router = express.Router();

router.get("/", (req, res) => {
  let addQuery = "";

  if (req.query.position !== undefined && req.query.position !== "T")
    addQuery += `WHERE position='${req.query.position}'`;
  else if (req.query.position === "T") addQuery += `WHERE playmaker=1`;

  connection.query(
    `SELECT * FROM players ${addQuery} ORDER BY quotation DESC`,
    (error, result) => {
      if (error) throw error;

      res.json(result);
    }
  );
});

router.get("/:id", (req, res) => {
  connection.query(
    `SELECT * FROM players WHERE id_player=${req.params.id}`,
    (error, result) => {
      if (error) throw error;

      res.json(result);
    }
  );
});

module.exports = router;
