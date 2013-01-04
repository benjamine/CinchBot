# Description:
#   Looks up jira issues when they're mentioned in chat
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_JIRA_DOMAIN
#
# Commands:
# 
# Author:
#   stuartf

module.exports = (robot) ->
  cache = []
  jiraDomain = process.env.HUBOT_JIRA_DOMAIN
  jiraUrl = "https://" + jiraDomain
  http = require 'https'

  jiraPrefixes = ['BTR','AMS','INFRA']
  reducedPrefixes = jiraPrefixes.reduce (x,y) -> x + "-|" + y
  jiraPattern = "/([a-z][a-z][a-z][a-z]?-)(\\d+)/gi"

  robot.hear eval(jiraPattern), (msg) ->
    for i in msg.match
      issue = i.toUpperCase()
      now = new Date().getTime()
      if cache.length > 0
        cache.shift() until cache.length is 0 or cache[0].expires >= now
      if cache.length == 0 or (item for item in cache when item.issue is issue).length == 0
        cache.push({issue: issue, expires: now + 120000})
        msg.send "[" + i + "] " + ' looks a lot like a JIRA ticket id, but nobody has taught me how to access them :('
