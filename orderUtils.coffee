ordrin = require 'ordrin-api'
request = require 'request'
_ = require 'underscore'

email = process.env.HUBOT_ORDRIN_EMAIL
password = process.env.HUBOT_ORDRIN_PASSWORD
firstName = process.env.HUBOT_ORDRIN_FIRST_NAME
lastName = process.env.HUBOT_ORDRIN_LAST_NAME

ordrinApi = new ordrin.APIs process.env.HUBOT_ORDRIN_API_KEY, ordrin.PRODUCTION

placeOrder = (params, cb) ->
  options =
    'rid': params.rid
    'email': email
    'current_password': password
    'tray': params.tray
    'tip': '10.00'
    'first_name': firstName
    'last_name': lastName
    'delivery_date': 'ASAP'
    'nick': 'groupLocation'
    'card_nick': 'groupCard'

  ordrinApi.order_user options, cb

getRelevantMenuItems = (rid, desc, cb) ->
  request "http://embarrassme.me:8000/TextSearch?rid=#{rid}&target=#{desc}&size=15",
    (err, res, body) ->
      if err
        console.log err
        return cb err

      cb null, JSON.parse(body)

getRelevantRestaurants = (name, limit, cb) ->
  ordrinApi.get_saved_addr
    email: email
    current_password: password
    nick: 'groupLocation',
    (err, result) ->
      if err
        console.log err
        return err
      ordrinApi.delivery_list(
        datetime: 'ASAP'
        addr: result.addr
        city: result.city
        zip: result.zip,

        (err, restaurants) ->
          if err
            console.log err
            return cb err
          name = name.toLowerCase()

          relevantRestaurants = []
          for restaurant in restaurants
            restContainsCuisine = _.contains _.map(restaurant.cu, (rest) -> rest.toLowerCase()), name
            restContainsName = restaurant.na.toLowerCase().indexOf(name) isnt -1
            if restContainsCuisine or restContainsName
              relevantRestaurants.push restaurant
            if relevantRestaurants.length > limit
              return cb null, relevantRestaurants

          cb null, relevantRestaurants
      )

getUniqueList = (size, cb) ->
  ordrinApi.get_saved_addr
    email: email
    current_password: password
    nick: 'groupLocation',
    (err, result) ->
      if err
        console.log err
        console.log err.stack
        return err
      ordrinApi.delivery_list(
        datetime: 'ASAP'
        addr: result.addr
        city: result.city
        zip: result.zip,

        (err, rest_list) ->
          if err
            console.log err
            return cb err

          unique_list = []
          cuisines = []

          for i in [1..size] by 1
            if(rest_list.length == 0)
              break

            # add rest whose cuisine is not yet listed
            random_i = Math.floor(Math.random() * rest_list.length)

            found = false
            while !found and rest_list.length > 0
              if(!rest_list[random_i].cu)
                rest_list.splice random_i, 1
                break

              for cuisine in rest_list[random_i].cu
                if((cuisines.indexOf cuisine) == -1)
                  unique_list.push rest_list[random_i]
                  cuisines = cuisines.concat rest_list[random_i].cu
                  found = true
                  rest_list.splice random_i, 1
                  break

              if not found
                rest_list.splice random_i, 1

          cb null, unique_list
      )

module.exports =
  placeOrder: placeOrder
  getRelevantMenuItems: getRelevantMenuItems
  getRelevantRestaurants: getRelevantRestaurants
  getUniqueList: getUniqueList
