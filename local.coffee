# An object mapping function names to ther listener regular expressions.
listeners =
  startOrder: [/start order(.*)$/i]
  more: [/more$/i]
  finishOrder: [/done$/i]
  exitOrder: [/I'm out$/i]
  select: [/(.*)/i]
  queryMenuItem: [/I want (.*)/i]
  confirm: [/yes/i]
  decline: [/no/i]
  placeOrder: [/place order/i]
  displayOrders: [/show orders$/i]

# An object containing strings that the bot uses for responding to users.
responses = {}

module.exports =
  listeners: listeners
  responses: responses
