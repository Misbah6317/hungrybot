ordrin = require 'ordrin-api'

ordrinApi = new ordrin.APIs process.env.HUBOT_ORDRIN_API_KEY, ordrin.TEST

if process.argv.length isnt 6
  console.log 'Wrong number of arguments!'
  process.exit(1)

email = process.argv[2]
password = process.argv[3]
firstName = process.argv[4]
lastName = process.argv[5]

ordrinApi.create_account(
  email: email
  pw: password
  first_name: firstName
  last_name: lastName,
  (err, data) ->
    console.log "User #{email} created"
    console.log data
)
