# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  saludosReplies = ['Weeena CTM', 'Holi!', 'Hola', 'Wasaaaaaaap', 'Ke pa!', 'Wena weeeena!']
  robot.hear /hola/i, (res) ->
    res.send res.random saludosReplies

  robot.hear /diplomado/i, (res) ->
    res.send "DevOps 2022"
  robot.hear /CI/i, (res) ->
    res.send "Integración Continua"
  robot.hear /CD/i, (res) ->
    res.send "Despliegue Contínuo / Desarrollo Contínuo"
  robot.hear /lenguaje/i, (res) ->
    res.send "Java"
  robot.hear /OS/i, (res) ->
    res.send "Linux"
  robot.hear /SCM/i, (res) ->
    res.send "GitHub"
  robot.hear /cloud/i, (res) ->
    res.send "Azure"
  robot.hear /chat/i, (res) ->
    res.send "Slack"
  robot.hear /metodologia/i, (res) ->
    res.send "Ágil"
  robot.hear /devops/i, (res) ->
    res.send "Desarrollo y Operaciones"

  {WebClient} = require "@slack/client"
  module.exports = (robot) ->
  web = new WebClient robot.adapter.options.token

  # When the script starts up, there is no notification room
  notification_room = undefined

  # Immediately, a request is made to the Slack Web API to translate a default channel name into an ID
  default_channel_name = "general"
  web.channels.list()
    .then (api_response) ->
      # List is searched for the channel with the right name, and the notification_room is updated
      room = api_response.channels.find (channel) -> channel.name is default_channel_name
      notification_room = room.id if room?

    # NOTE: for workspaces with a large number of channels, this result in a timeout error. Use pagination.
    .catch (error) -> robot.logger.error error.message

  # Any message that says "send updates here" will change the notification room
  robot.hear /send updates here/i, (res) ->
    notification_room = res.message.rawMessage.channel.id
    res.send res.message.rawMessage.channel.id

  # Any message that says "my update" will cause Hubot to echo that message to the notification room
  robot.hear /my update/i, (res) ->
    if notification_room?
      robot.messageRoom(notification_room, "An update from: <@#{res.message.user.id}>: '#{res.message.text}'")


  
  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
