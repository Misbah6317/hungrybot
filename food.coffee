# Description:
#   Commands for ordering food.
#
# Commands:

_ = require 'underscore'
orderUtils = require './orderUtils'

address = process.env.HUBOT_ADDRESS
city = process.env.HUBOT_CITY
state = process.env.HUBOT_STATE
zip = process.env.HUBOT_ZIP

module.exports = (robot) ->

  users = []
  canJoinOrder = false
  state = 1 #1-listening, 2-gathering people, 3-gathering orders



  # Listen for the start of an order.
  robot.respond /start order$/i, (msg) ->
    leader = msg.message.user.name

    users.push leader
    canJoinOrder = true

    msg.send "#{leader} is the leader, and has started a group order. Reply \"I'm in\" to join."
    msg.send 'Reply "done" when everyone is in.'

    # Listen for the leader to say that everyone is in.
    robot.respond /done$/i, (doneMsg) ->
      user = doneMsg.message.user.name

      if user is leader and canJoinOrder
        canJoinOrder = false
        doneMsg.send 'Everyone is ready to order! Tell me "I\'m out" if you change your mind.'

        orderUtils.getUniqueList "ASAP", "902 Broadway", "New York", "10010", 5, (err, data) ->
          if err
            doneMsg.send err
          doneMsg.send "#{data}"
          restaurantsDisplay = ''
          for rest in data
            restaurantsDisplay += "#{rest.na}, "
          doneMsg.send "#{restaurantsDisplay} (say \"more\" to see more restaurants)"

  # Listen for users to join the order.
  robot.respond /I'm in$/i, (msg) ->
    user = msg.message.user.name
    if canJoinOrder and user not in users
      users.push user

  # Listen for users who want to be removed from the order.
  robot.respond /I'm in$/i, (msg) ->
    user = msg.message.user.name
    users = _.filter users, (userInOrder) -> userInOrder isnt user


  # Listen for orders
  robot.respond /I want (.*)/i, (msg) ->
    if( state != 3)
      return

    order = escape(msg.match[1])

    msg.send(order)
