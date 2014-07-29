ordrin = require 'ordrin-api'
request = require 'request'
ordrinApi = new ordrin.APIs process.env.HUBOT_ORDRIN_API_KEY, ordrin.TEST

placeOrder = (params, msg) ->
  options =
    'rid': params.rid
    'em': params.email
    'tray': params.tray
    'tip': '0.00'
    'first_name': params.first_name
    'last_name': params.last_name
    'phone': params.phone
    'zip': params.zip
    'addr': params.addr
    'city': params.city
    'state': params.state
    'delivery_date': 'ASAP'
    'card_name': process.env.HUBOT_CARD_NAME
    'card_number': process.env.HUBOT_CARD_NUMBER
    'card_cvc': process.env.HUBOT_CARD_CVC
    'card_expiry': process.env.HUBOT_CARD_EXPIRY
    'card_bill_addr': process.env.HUBOT_CARD_BILL_ADDR
    'card_bill_city': process.env.HUBOT_CARD_BILL_CITY
    'card_bill_state': process.env.HUBOT_CARD_BILL_STATE
    'card_bill_zip': process.env.HUBOT_CARD_BILL_ZIP
    'card_bill_phone': process.env.HUBOT_CARD_BILL_PHONE

  ordrinApi.order_guest(options, (err, data) ->
    if err
      console.log err
      return err
    msg.send "Order placed: #{data}"
  )

getRelevantMenuItems = (rid, desc, cb) ->
  request "http://embarrassme.me:8000/TextSearch?rid=#{rid}&target=#{desc}&size=5",
    (err, res, body) ->
      if err
        console.log "Encountered an error :( #{err}"
        return cb err

      cb null, JSON.parse(body)

getUniqueList = (datetime, addr, city, zip, size, cb) ->
  ordrinApi.delivery_list(
    datetime: datetime
    addr: addr
    city: city
    zip: zip,

    (err, rest_list) ->
      if err
        return cb err

      unique_list = []
      cuisines = []
      
      for i in [1..size] by 1
        if(rest_list.length == 0)
          break

        #add rest whose cuisine is not yet listed
        random_i = Math.floor(Math.random() * rest_list.length)

        if(!rest_list[random_i])
          console.log random_i
          console.log rest_list.length

        found = false
        while !found and rest_list.length > 0
          for cuisine in rest_list[random_i].cu
            if((cuisines.indexOf cuisine) == -1)
              unique_list.push rest_list[random_i]
              cuisines = cuisines.concat rest_list[random_i].cu
              found = true
              rest_list.splice random_i, 1
              break
          if !found
            rest_list.splice random_i, 1

      cb null, unique_list
  )

getUniqueList "ASAP", "855 Grove Ave", "Edison", "08820", 20,
  (err, data) ->
    if err
      console.log err

    for rest in data
      console.log rest.na
      console.log rest.cu
