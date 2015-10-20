callbacks = []

class Dispatcher

  @register: (callback) ->
    callbacks.push callback

  @dispatch: (data) ->
    callbacks.forEach (callback) ->
      callback(data)

module.exports = Dispatcher
