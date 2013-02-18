# Description:
#   Allow hubot answer skype calls, and play or record audio on them
#   Only works with the hubot-skype adapter.
#
# Dependencies:
#   None
#
# Commands:
#   hubot call - call people on current room
#   hubot answer - If a call is ringing, answers the call
#   hubot hangup - hang up current call
#   hubot play <filename>.wav - play a wav file on current call
#   hubot record call - starts recording the current call
#   hubot record stop - stops recording the current call
#   hubot call <user> and play <filename>.wav- calls a user (if not in a call already) and play audio file when s/he answers, the user audio response is recorded
#   hubot speak <text> - speaks on the current call
#   hubot call <user> and speak <text> - calls a user (if not in a call already), speak text when s/he answers, the user audio response is recorded
##
# Author:
#   benjamine

module.exports = (robot) ->

  path = require('path')
  audioFolder = process.env.HUBOT_SKYPE_AUDIO_FOLDER || 'audio'
  if audioFolder
    audioFolder = path.resolve(audioFolder)

  robot.respond /call/i, (msg) ->
    msg.send '[call-start]'

  robot.respond /answer call/i, (msg) ->
    msg.send '[call-answer]'

  robot.respond /hangup/i, (msg) ->
    msg.send '[call-finish]'

  robot.respond /record call/i, (msg) ->
    msg.send '[call-record]'

  robot.hear /^\[call\-recording:(.*)\]$/i, (msg) ->
    filename = path.relative(audioFolder, msg.match[1])
    msg.send 'I\'m recording at ' + filename + '...'

  robot.hear /^\[call\-recorded:(.*)\]$/i, (msg) ->
    filename = path.relative(audioFolder, msg.match[1])
    msg.send 'recording saved at ' + filename

  robot.respond /(record stop|stop recording)/i, (msg) ->
    msg.send '[call-record-stop]'

  robot.respond /play[ ]+([\S]*)\.wav/i, (msg) ->
    msg.send '[call-play:' + msg.match[1] + '.wav]'

  robot.respond /call ([\S]*) and play[ ]+([\S]*)\.wav/i, (msg) ->
    msg.send '[call-and-play:' + msg.match[1] + ',' + msg.match[2] + '.wav]'
  
  robot.respond /speak[ ]+(.*)/i, (msg) ->
    msg.send '[call-speak:' + msg.match[1] + ']'

  robot.respond /call ([\S]*) and speak[ ]+(.*)/i, (msg) ->
    msg.send '[call-and-speak:' + msg.match[1] + ',' + msg.match[2] + ']'
  