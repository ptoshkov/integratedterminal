const net = require("net");
const pty = require("node-pty");
const fs = require("fs");
const jsonpath = process.argv[2];
const json = JSON.parse(fs.readFileSync(jsonpath));
const shell = json["Shell Path"];
const args = json["Shell Arguments"];
const cols = json["cols"];
const rows = json["rows"];

const server = net.createServer((socket) => {
  console.log("MATLAB connected.");

  let ptyProcess = pty.spawn(shell, args, {
    name: "xterm-color",
    cols: cols,
    rows: rows,
    cwd: process.env.HOME,
    env: process.env,
  });

  ptyProcess.on("data", function (data) {
    socket.write(data);
  });

  socket.on("data", (data) => {
    ptyProcess.write(data.toString());
  });

  socket.on("end", (data) => {
    console.log("MATLAB disconnected.");
    socket.destroy();
    server.close();
    process.exit(0);
  });
});

server.listen(8080, () => console.log("Server listening on port 8080."));
