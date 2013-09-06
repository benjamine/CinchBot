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
Robot = require('hubot').Robot

module.exports = (robot) ->
  robot.router.post "/hubot/say", (req, res) ->
    message = req.body.message
    if !message
      res.writeHead 400, {'Content-Type': 'text/plain'}
      res.end 'message is required'
      return
    if req.body.user
      user = robot.brain.userForId req.body.user
      robot.logger.info "Message '#{message}' received for user #{req.body.user}"
    else
      if !req.body.room
        res.writeHead 400, {'Content-Type': 'text/plain'}
        res.end 'user or room is required'
        return
      user = robot.brain.userForId 'broadcast'
      user.room = req.body.room
      user.type = 'groupchat'
      robot.logger.info "Message '#{message}' received for room #{req.body.room}"

    robot.send user, "#{message}"
    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Message received'
