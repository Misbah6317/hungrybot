prompt = require 'prompt'
async = require 'async'
ordrin = require 'ordrin-api'

ordrinApi = new ordrin.APIs process.env.HUBOT_ORDRIN_API_KEY, ordrin.TEST

prompt.start()
async.waterfall [
  (asyncCb) ->
    prompt.get ['email', 'password', 'firstName', 'lastName'], (err, result) ->
      if err
        asyncCb err
      ordrinApi.create_account(
        email: result.email
        pw: result.password
        first_name: result.firstName
        last_name: result.lastName,
        (err, data) ->
          console.log "User #{result.email} created"
          asyncCb(null, result);
      )
  (createAccount, asyncCb) ->
    prompt.get ['address', 'city', 'state', 'zip', 'phone'], (err, result) ->
      ordrinApi.create_addr(
        email: createAccount.email
        current_password: createAccount.password
        nick: 'groupLocation'
        addr: result.address
        city: result.city
        state: result.state
        zip: result.zip
        phone: result.phone,
        (err, data) ->
          if err
            asyncCb err
          console.log 'Address created'
          asyncCb(null, createAccount, result);
      )
  (createAccount, createAddress, asyncCb) ->
    prompt.get ['cardNumber', 'cardCvc', 'cardExpirationDate', 'billingAddress', 'billingCity', 'billingState', 'billingZipCode', 'billingPhoneNumber'], (err, result) ->
      ordrinApi.create_cc(
        email: createAccount.email
        current_password: createAccount.password
        nick: 'groupCard'
        card_number: result.cardNumber
        card_cvc: result.cardCvc
        card_expiry: result.cardExpirationDate
        bill_addr: result.billingAddress
        bill_city: result.billingCity
        bill_state: result.billingState
        bill_zip: result.billingZipCode
        bill_phone: result.billingPhoneNumber,
        (err, data) ->
          if err
            asyncCb err
          console.log 'Credit card created'
          asyncCb()
      )
], (err, result) ->
  if err
    console.log "An error has occured"
    console.log err
    return
  console.log "Be sure to read the documentation to determine which environment variables you need to save."
