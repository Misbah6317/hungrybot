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

  canJoinOrder = false
  HUBOT_APP = {}
  HUBOT_APP.state = 1 #1-listening, 2-gathering people, 3-Selecting a restaurant 4-gathering orders
  HUBOT_APP.rid = ""
  HUBOT_APP.users = []
  HUBOT_APP.leader = ''
  HUBOT_APP.restaurants = []

  # Listen for the start of an order.
  robot.respond /start order$/i, (msg) ->
    if HUBOT_APP.state is 1
      leader = msg.message.user.name
      HUBOT_APP.leader = leader
      HUBOT_APP.users.push leader
      HUBOT_APP.state = 2

      msg.send "#{leader} is the leader, and has started a group order. Reply \"I'm in\" to join."
      msg.send 'Reply "done" when everyone is in.'

  # Listen for the leader to say that everyone is in.
  robot.respond /done$/i, (msg) ->
    user = msg.message.user.name

    if user is HUBOT_APP.leader and HUBOT_APP.state is 2
      canJoinOrder = false
      msg.send 'Everyone is ready to order! Tell me "I\'m out" if you change your mind.'

      orderUtils.getUniqueList "ASAP", address, city, zip, 5, (err, data) ->
        if err
          msg.send err
        HUBOT_APP.restaurants = data
        restaurantsDisplay = ''
        for rest in data
          restaurantsDisplay += "#{rest.na}, "
        msg.send "Tell me a restaurant to choose from: #{restaurantsDisplay} (say \"more\" to see more restaurants)"
        HUBOT_APP.state = 3

  # Listen for users to join the order.
  robot.respond /I'm in$/i, (msg) ->
    user = msg.message.user.name
    if HUBOT_APP.state is 2 and user not in HUBOT_APP.users
      HUBOT_APP.users.push user

  # Listen for users who want to be removed from the order.
  robot.respond /I'm out$/i, (msg) ->
    if HUBOT_APP.state is 2
      user = msg.message.user.name
      HUBOT_APP.users = _.filter HUBOT_APP.users, (userInOrder) -> userInOrder isnt user

  # Listen for the leader to choose a restaurant.
  robot.respond /(.*)/i, (msg) ->
    if HUBOT_APP.state isnt 3 and msg.message.user.name isnt leader
      return

    restaurant = _.findWhere HUBOT_APP.restaurants, na: msg.match[1]
    msg.send "Is #{restaurant.na} the restaurant you want to order from?"

  # Listen for orders.
  robot.respond /I want (.*)/i, (msg) ->
    if HUBOT_APP.state isnt 4
      return

    order = escape(msg.match[1])

    orderUtils.getRelevantMenuItems(HUBOT_APP.rid, order,
      (err, data) ->
        msg.send "Did you mean... \"" + data[0].name + "\"?"
    )
