ordrin = require 'ordrin-api'

ordrinApi = new ordrin.APIs process.env.HUBOT_ORDRIN_API_KEY, ordrin.TEST

if process.argv.length isnt 13
  console.log 'Wrong number of arguments!'
  process.exit(1)

email = process.argv[2]
password = process.argv[3]
cardNumber = process.argv[4]
cardCvc = process.argv[5]
cardExpiry = process.argv[6]
billAddr = process.argv[7]
billCity = process.argv[8]
billState = process.argv[9]
billZip = process.argv[10]
billPhone = process.argv[11]
nick = process.argv[12]

ordrinApi.create_cc(
  email: email
  current_password: password
  nick: nick
  card_number: cardNumber
  card_cvc: cardCvc
  card_expiry: cardExpiry
  bill_addr: billAddr
  bill_city: billCity
  bill_state: billState
  bill_zip: billZip
  bill_phone: billPhone,
  (err, data) ->
    if err
      console.log err
      process.exit 1
    console.log 'Credit card created'
    console.log data
)
