
fs = require('fs');
path = require('path');

var walk = function(dir, filter, done) {
  var results = [];
  fs.readdir(dir, function(err, list) {
    if (err) return done(err);
    var pending = list.length;
    if (!pending) return done(null, results);
    list.forEach(function(file) {
      file = dir + '/' + file;
      fs.stat(file, function(err, stat) {
        if (filter(file, stat)) {
          results.push(file);
        }
        if (stat && stat.isDirectory()) {
          walk(file, filter, function(err, res) {
            results = results.concat(res);
            if (!--pending) done(null, results);
          });
        } else {
          if (!--pending) done(null, results);
        }
      });
    });
  });
};

walk('.', function(file, stat){
	if (file=='./scripts') return false;
	return stat.isDirectory() && path.basename(file).toLowerCase()==='scripts';
}, function(error, scriptFolders){
	if (error){
		console.log(error);
	} else {

		var count = 0;
		console.log('\nscript sources:');
		console.log(scriptFolders);
		console.log();
		fs.readdir('./scripts', function(err, scripts){
	    	if (!err) {

	    		scripts.forEach(function(script) {
	    			var scriptPath = path.join('./scripts', script);
	    			scriptFolders.forEach(function(folder){
	    				var source = path.join(folder, path.basename(script));
	    				if (fs.existsSync(source)){
	    					var sourceStat = fs.statSync(source);
			    			var scriptStat = fs.existsSync(scriptPath) && fs.statSync(scriptPath);
	    					if (sourceStat.isFile() && (!scriptStat || sourceStat.mtime > scriptStat.mtime || process.argv.indexOf('--force') > -1)) {
		    					console.log('updating '+path.basename(script)+' from '+folder);
		    					fs.writeFileSync(scriptPath, fs.readFileSync(source));
		    					count++;
	    					}
	    				}
	    			});
	    		});
	    		if (count === 0) {
	    			console.log('Everything up-to-date');
	    		}
	    	}
		});
	}
});
