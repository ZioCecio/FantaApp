const express = require("express");
const http = require("http");
const socketIO = require("socket.io");

const playersRouter = require("./routes/players");

const app = express();
const server = http.createServer(app);
const io = socketIO(server);

const port = process.env.PORT || 3000;

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  next();
});

app.use("/players", playersRouter);

io.on("connection", socket => {
  console.log(socket.client.id);

  socket.on("changePage", data => {
    io.sockets.emit("changePage", data);
  });

  socket.on("doOffer", data => {
    io.sockets.emit("onOffer", { user: data.user, offer: data.offer });
  });
});

server.listen(port, () => console.log(`In ascolto sulla porta ${port}`));
