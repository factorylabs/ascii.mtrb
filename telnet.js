var tcp = require("net"),
fs = require('fs'),
sys = require('sys');

function randInt(size) {
    var rNum = Math.floor(Math.random() * size);
    return rNum;
}

var videos = ['headphones',
'powder',
'snowflake',
'on-time',
'leader'];

var server = tcp.createServer(function(socket) {
    socket.setEncoding("utf8");

    socket.on("connect",
    function() {
        sys.log('connected!');

				socket.interval = null;

        socket.write('\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n     *****                                          ASCII.FACTORYLABS.COM                                           *****     \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n');
        socket.write('\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n     *****     Resize your terminal to 180x55 or larger and strap yourself in.  Things are about to get Orange.     *****     \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n');

        setTimeout(function() {
            var dataChunks = [];
            var videoName = videos[randInt(videos.length)];
            var readStream = fs.createReadStream(__dirname + '/videos/' + videoName + '.ascii', {
                'flags': 'r',
                'encoding': 'ascii',
                'bufferSize': 55 * 180
            });
            readStream.on("data",
            function(str) {
                dataChunks.push(str);
            });

            socket.interval = setInterval(function() {
                var chunk = dataChunks.shift();
                if (chunk) {
                    socket.write(chunk);
                } else {
                    clearInterval(socket.interval);
                    setTimeout(function() {
                        socket.write('rnrnrnrnrnrnrnrn     *****     Why not check out another video?  Telnet to ascii.factorylabs.com, port 5000     *****     rnrnrnrnrnrnrnrn');
                        socket.end();
                    },
                    10000);
                }
            },
            40);
        },
        10000);
    });

    socket.on("end",
    function() {
        socket.end();
        clearInterval(socket.interval);
    });

});
server.listen(5000);
