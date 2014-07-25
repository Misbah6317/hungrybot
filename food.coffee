# Description:
#   Commands for ordering food delivery.
#
# Commands:

postData =
  headers:
    'content-type': 'application/x-www-form-urlencoded'

module.exports = (robot) ->
  robot.respond /Yo$/i, (msg) ->
    data =
      headers:
        'content-type': 'application/x-www-form-urlencoded'
    msg.http("http://headers.jsontest.com/")
      .post(JSON.stringify(data)) (err, res, body) ->
        if err
          msg.send "Encountered an error :( #{err}"
          return
        msg.send body
