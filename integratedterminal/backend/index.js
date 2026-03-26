const net = require("net");
const pty = require("node-pty");
const fs = require("fs");
const terminator = String.fromCharCode(0);
const prefjsonpath = process.argv[2];
const prefjson = JSON.parse(fs.readFileSync(prefjsonpath));
const shell = prefjson["Shell Path"];
const args = prefjson["Shell Arguments"];
const cols = prefjson["cols"];
const rows = prefjson["rows"];
const ptyjsonpath = process.argv[3];
const ptyjsonpathtmp = ptyjsonpath + "tmp";

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
    socket.write(data + terminator);
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

// Grab an arbitrary unused port.
server.listen(0, "127.0.0.1", () => {
  let addr = server.address();
  console.log("Server listening on", addr);
  fs.writeFileSync(ptyjsonpathtmp, JSON.stringify(addr));
  fs.copyFileSync(ptyjsonpathtmp, ptyjsonpath);
  fs.unlinkSync(ptyjsonpathtmp);
});
