const net = require("net");
const pty = require("node-pty");
const fs = require("fs");
let connected = false;
const prefjson = process.argv[2];
const pref = JSON.parse(fs.readFileSync(prefjson));
const shell = pref["Shell Path"];
const args = pref["Shell Arguments"];
const cols = pref["cols"];
const rows = pref["rows"];
const ptyjson = process.argv[3];
const tmpfile = process.argv[4];

const server = net.createServer((socket) => {
  console.log("MATLAB connected.");
  connected = true;

  let ptyProcess = pty.spawn(shell, args, {
    name: "xterm-color",
    cols: cols,
    rows: rows,
    cwd: process.env.HOME,
    env: process.env,
  });

  ptyProcess.on("data", function (data) {
    socket.write(data + String.fromCharCode(0), "utf16le");
  });

  socket.on("data", (data) => {
    ptyProcess.write(data.toString());
  });

  socket.on("end", (data) => {
    console.log("MATLAB disconnected.");
    socket.destroy();
    server.close(() => {
      process.exit();
    });
  });
});

function handleConnectionTimeout() {
  if (!connected) {
    console.log("Timed out waiting for MATLAB to connect.");
    server.close(() => {
      process.exit(1);
    });
  }
}

// Grab an arbitrary unused port.
server.listen(0, "127.0.0.1", () => {
  let addr = server.address();
  console.log("Server listening on", addr);
  fs.writeFileSync(ptyjson, JSON.stringify(addr));

  // Decrement the latch so the MATLAB process will be unblocked.
  fs.unlinkSync(tmpfile);

  setTimeout(handleConnectionTimeout, 20000);
});
