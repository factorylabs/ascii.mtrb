var tcp = require("net"),
	fs = require('fs'),
	sys = require('sys');
	
var server = tcp.createServer(function (socket) {
  socket.setEncoding("utf8");
  socket.addListener("connect", function () {
	var readStream = fs.createReadStream('videos/snowflake.ascii', { 'flags': 'r', 'encoding': 'ascii', 'bufferSize': (181 * 54) });
	readStream.addListener("data", function(str) {
		setTimeout(function() {
			sys.print(str);
			socket.write(str);
		}, 1000);
	});
	readStream.addListener("end", function(str) {
		socket.close();
	});
	// sys.pump(readStream, socket, function(err) {
	// 	sys.print("Done!",err);
	// });
  });
  socket.addListener("end", function () {
    socket.close();
  });
});
server.listen(7000, "localhost");