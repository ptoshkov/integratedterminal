const net = require("net");
const pty = require("node-pty");
const os = require("os");
var shell = os.platform() === "win32" ? "powershell.exe" : "bash";

const server = net.createServer((socket) => {
  console.log("MATLAB connected.");

  var ptyProcess = pty.spawn(shell, [], {
    name: "xterm-color",
    cols: 100,
    rows: 40,
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
