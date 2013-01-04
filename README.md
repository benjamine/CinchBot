CinchBot
=============

Hi, I'm the [CinchCast](https://github.com/cinchcast)'s [Hubot](http://hubot.github.com/)

![bot](http://1.bp.blogspot.com/_QEWhOURarSU/SHDopchJDkI/AAAAAAAABkU/BC-NOdPXOE4/s320/RabiscoBot1.jpg)

Installing
-----------

    git clone git@github.com:benjamine/CinchBot.git
    npm install

Ensure a local redis instance is available to store the robot brain.

For skype adapter follow instructions [here](https://github.com/benjamine/hubot-skype)

Running
------------

If using skype, before starting this bot, be sure the skype client is started and logged in with the bot's account.

Chat with the bot using the console:

    coffee cinchbot

Start using an adapter:

    coffee cinchbot -a skype

You can keep it running using forever:

	npm install -g forever
    cinchbot.bat

Updating or adding new scripts
---------

- Clone this repository in your machine
- Add new scripts in the /scripts folder
- Add any required dependency at package.json
- git commit, git push
- Add require environment variables at ```env.data``` file or at redis hash ```hubot:env``
- (the previous steps can be done using github website for simple changes)
- Tell hubot to update itself: ```hubot update``` (he will perform a ```git pull``` and ```npm update```)
- Tell hubot to restart: ```hubot die```
