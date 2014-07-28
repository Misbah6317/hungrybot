ordrin = require 'ordrin-api'
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

getRelevantMenuItems = (rid, desc, msg, cb) ->
  msg.http("http://embarrassme.me:8000/TextSearch?rid=#{rid}&target=#{desc}&size=5")
    .get() (err, res, body) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      cb JSON.parse(body)
