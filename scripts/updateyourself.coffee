# Description:
#   Allows hubot to update itself using git pull and npm update.
#
# Commands:
#   hubot update yourself - Performs a git pull and npm udate.
child_process = require 'child_process'

module.exports = (robot) ->
  robot.respond /update yourself$/i, (msg) ->
    msg.send "updating..."
    changes = false
    try 
        msg.send "pulling from git..."
        child_process.exec 'git pull', (error, stdout, stderr) ->
            if error
                msg.send "git pull failed: " + stderr
            else
                output = stdout+''
                if not /Already up\-to\-date/.test output
                    changes = true
                msg.send "git pull OK:\n" + output
            try 
                msg.send "updating dependencies..."
                child_process.exec 'npm update', (error, stdout, stderr) ->
                    if error
                        msg.send "npm update failed: " + stderr
                    else
                        output = stdout+''
                        msg.send "npm update OK:\n" + output
                        if /node_modules/.test output
                            changes = true
                    if changes
                        msg.send "I have pending updates, kill me please! (hint: hubot die)"
                    else
                        msg.send "I'm up-to-date!"
            catch error
                msg.send "npm update failed: " + error
    catch error
        msg.send "git pull failed: " + error


