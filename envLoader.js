
fs = require('fs');

module.exports.loadFromFileSync = function(filename) {

	if (!fs.existsSync('env.data')){
		console.log('env.data file not found');
	} else {
		var vars = fs.readFileSync('env.data').toString().split('\n');
		var count = 0;
		vars.forEach(function(line){
			var key = line.split('=')[0];
			var value = line.slice(key.length+1);
			key = key.trim();
			if (key) {
			value = value.trim();
				process.env[key] = value;
				count++;
			}	
		});
		console.log(count+' key(s) loaded from env.data');
	}

}

module.exports.loadFromRedis = function(options, callback){

	if (typeof options === 'function') {
		callback = options;
		options = null;
	}

	options = options || {};

	var redis = require('redis');

	client = redis.createClient(options.port, options.host, options);
	client.on("error", function (err) {
	    console.log("Error " + err);
	});
	client.hgetall('hubot:env', function(err, reply){
		var count = 0;
		if (!err && reply) {
			for (var key in reply) {
				if (reply.hasOwnProperty(key)){
					process.env[key] = reply[key];
					count++;
				}
			}
		}
		console.log(count+' key(s) loaded from redis');
		client.quit();
		if (typeof callback === 'function') {
			callback(err);
		}
	});
}