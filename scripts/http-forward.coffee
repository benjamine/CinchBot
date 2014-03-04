# Description:
#   Listens for http POSTs and sends notifications. Send a POST to hubot/say indicating the room/user and message.
#
# Example:
#   curl http://<hubothost>/hubot/say -X POST -d room=#ROOMID -d message=Hello%20from%20curl
#
# Dependencies:
#   None
#
# Commands:
#   None
#
# Author:
#   benjamine
util = require('util')
http = require('http')
Robot = require('hubot').Robot

module.exports = (robot) ->

  robot.brain.on 'loaded', =>
    robot.brain.data.forward ||= {}
    robot.brain.data.forward.rooms ||= {}

  robot.respond /forward to ([^ ]+)(?: in ([^:]+)((?:\:)\d+)?)?$/i, (msg) ->
    robot.brain.data.forward.rooms[msg.message.room] = {
      room: msg.match[1]
      host: msg.match[2]
      port: msg.match[3]
    }
    msg.reply 'forwarding'

  robot.respond /stop forward(ing)?$/, (msg) ->
    if not robot.brain.data.forward.rooms[msg.message.room]
      msg.reply 'ok, I wasn\'t'
      return
    end
    robot.brain.data.forward.rooms[msg.message.room] = null
    msg.reply 'forwarding no more'

  robot.hear /^(.*)$/, (msg) ->
    return unless msg.message.user
    info = robot.brain.data.forward.rooms[msg.message.room]
    if info
      options = {
        hostname: info.host || 'localhost'
        port:  (info.port || process.env.PORT || 8081)
        path: '/hubot/say'
        method: 'POST'
        headers:
            'Content-Type': 'application/json'
      }
      req = http.request options, (res) ->
        console.log('msg forwarded')
      data = {
        room: info.room+''
        message: msg.message.user.name + '> ' + msg.message.text
      }
      req.write JSON.stringify(data)
      req.write '\n\n'
      req.end()
