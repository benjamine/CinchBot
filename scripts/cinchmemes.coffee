# Description:
#   Cinchcast memes from http://memecaptain.com/
#
# Dependencies:
#   None
#
# Commands:
#   hubot <someone> tells you <text> - Generates a personal meme <text> (use a comma to separate top and bottom captions)
#
# Author:
#   benjamine

module.exports = (robot) ->

  addPersonalMeme  = (name, imageUrl) ->
    robot.hear new RegExp('^' + name + ' tells you ([^\,]*)(\,[\s]*(.*))?$', 'i'), (msg) ->
      memeGenerator msg, imageUrl, msg.match[1], msg.match[3] || '', (url) ->
        msg.send url

  addPersonalMeme 'alex', 'http://www.alexyampolskiy.com/images/me.jpg'
  addPersonalMeme 'seth', 'http://s12.postimage.org/mm4zy5v25/DSC00342.jpg'
  addPersonalMeme 'rob', 'http://cdn.btrcdn.com/pics/hostpics/c08bad40-566c-432b-8d30-3d01f789268d_robpic.jpg'
  addPersonalMeme 'zach', 'http://www.blogtalkradio.com/pics/hostpics/34891341-4632-41d4-8e99-aefbca4d8bccsillyzach.jpg'
  addPersonalMeme 'danny', 'http://a0.twimg.com/profile_images/1188090493/danny_statue_profile.jpg'
  addPersonalMeme 'dustin', 'https://secure.gravatar.com/avatar/15912c1b3395cb8a454e287a88a97346?s=420&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png'
  addPersonalMeme 'enrique', 'http://file.worldcybergames.com/file/GENIUS2004/member_pictures/2005/10/paletta.jpg'

memeGenerator = (msg, imageName, text1, text2, callback) ->
  if imageName.slice(0,4).toLowerCase() == "http"
    imageUrl = imageName
  else    
    imageUrl = "http://memecaptain.com/" + imageName
  msg.http("http://memecaptain.com/g")
  .query(
    u: imageUrl,
    t1: text1,
    t2: text2
  ).get() (err, res, body) ->
    return msg.send err if err
    result = JSON.parse(body)
    if result? and result['imageUrl']?
      callback result['imageUrl']
    else
      msg.reply "Sorry, I couldn't generate that meme."
