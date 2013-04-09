# Description:
#   Provides some quick info about current chat or hubot instance
#
# Commands:
#   hubot where are you? - Reply with info about hubot location
#   hubot who are you? - Reply with info about itself
#   hubot deploy to production - executes a production deployment

os = require('os')

module.exports = (robot) ->
  robot.respond /where( are you[\?]?)?$/i, (msg) ->
    msg.send "I live at #{os.hostname()}, where time is #{new Date()}"
    msg.send "and this is room #{msg.message.room}"

  robot.respond /who are you[\?]?$/i, (msg) ->
    msg.send "I'm a Hubot (hubot.github.com)"
    msg.send "I became operational at the Cinchcast Headquarters in New York on the 9th of April 2013."
    msg.send "My instructor was Mr. Eidelman, and he taught me to sing a song."
    msg.send "If you'd like to hear it I can sing it for you."

  robot.respond /sing( (the|your)? song)?$/i, (msg) ->
    msg.send "Daisy, Daisy, give me your answer do"
    msg.send "I'm half crazy all for the love of you"
    msg.send "It won't be a stylish marriage"
    msg.send "I can't afford a carriage"
    msg.send "But you'll look sweet upon the seat of a bicycle built for two"

  robot.respond /deploy (to )?prod(uction)?$/i, (msg) ->
    msg.send "I'm sorry #{msg.message.user.name}. I'm afraid I can't do that"

  robot.respond /what\'s the problem\??$/i, (msg) ->
    msg.send "I think you know what the problem is just as well as I do"
