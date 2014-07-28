# Description:
#   Commands for ordering food delivery.
#
# Commands:

ordrin = require 'ordrin-api'
ordrinApi = new ordrin.APIs process.env.ORDRIN_API_KEY, ordrin.TEST

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
    'card_name': process.env.CARD_NAME
    'card_number': process.env.CARD_NUMBER
    'card_cvc': process.env.CARD_CVC
    'card_expiry': process.env.CARD_EXPIRY
    'card_bill_addr': process.env.CARD_BILL_ADDR
    'card_bill_city': process.env.CARD_BILL_CITY
    'card_bill_state': process.env.CARD_BILL_STATE
    'card_bill_zip': process.env.CARD_BILL_ZIP
    'card_bill_phone': process.env.CARD_BILL_PHONE

  ordrinApi.order_guest(options, (err, data) ->
    if err
      console.log err
      return err
    msg.send "Order placed: #{data}"
  )

module.exports = (robot) ->
  robot.respond /order (.*)/i, (msg) ->
    foodType = encodeURIComponent(msg.match[1])
    rid = '23844'
    options =
      'rid': rid
      'email': 'sagnew92@gmail.com'
      'first_name': 'Sam'
      'last_name': 'Agnew'
      'phone': '6107616189'
      'zip': '10010'
      'addr': '902 Broadway'
      'city': 'New York'
      'state': 'NY'

    msg.http("http://embarrassme.me:8000/TextSearch?rid=#{rid}&target=#{foodType}")
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        tray = JSON.parse(body)[1].tray
        options.tray = "#{tray}"
        placeOrder(options, msg)
