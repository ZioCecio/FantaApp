const express = require("express");

const playersRouter = require("./routes/players");

const app = express();

const port = process.env.PORT || 3000;

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  next();
});

app.use("/players", playersRouter);

app.listen(port, () => console.log("In ascolto sulla porta " + port));
