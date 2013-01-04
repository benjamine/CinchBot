envLoader = require './envLoader'
envLoader.loadFromFileSync()
envLoader.loadFromRedis (err) =>
	if (err) 
		return
	process.argv.push '--name', 'cinch'
	process.argv.push '--alias', 'cinch'

	# for require() to work we need explicit .coffee extension
	bin = './node_modules/hubot/bin/hubot'
	binWithcoffee = bin+'.coffee'
	fs = require 'fs'
	fs.writeFileSync binWithcoffee, fs.readFileSync(bin)

	require binWithcoffee