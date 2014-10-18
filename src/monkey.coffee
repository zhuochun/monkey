# Monkey.js
# MIT 2014 @ Zhuochun <zhuochun@hotmail.com>
#
# Usage:
#
#   new Monkey().behaviour(new ClickBehaviour().getHandler()).play()
#
class Monkey
  # constructor
  #
  # @params options
  #   - element: restrict the place monkeys play (default is `document`)
  #   - cycles: number of cycles to run all actions (default is `10`)
  #   - speed: speed of cyles in ms (default is `50`)
  constructor: (options = {}) ->
    @actions = []
    @history = []
    @setPlace options.element
    @cycles  = options.cycles || 10
    @round   = 0
    @speed   = options.speed  || 50

  # behaviour: define an action to do
  #
  # @params action function that accepts { x, y, elem }
  # @params interval number or function that adjust the action execution.
  #                  default is 1, which means the action runs at every cycle.
  behaviour: (action, interval) ->
    interval = 1 unless interval
    next = Monkey.utils.nextInterval(interval)
    @actions.push(run: action, interval: interval, next: next)
    return @

  reset: ->
    @round = 0
    for action in @actions
      action.next = Monkey.utils.nextInterval(action.interval, 0)
    @history.length = 0

  stop: ->
    clearTimeout(@timeId)
    @timeId = null

  play: ->
    @stop()
    @timeId = setInterval (=> @action()), @speed

  replay: (startIdx = 0, endIdx = @history.length) ->
    @stop()
    return if endIdx == 0 || startIdx > endIdx

    @timeId = setInterval =>
      startIdx += 1
      return @stop() if startIdx > endIdx

      act = @history[startIdx - 1]
      action.run(act) for action in act.actions

      return # prevent array
    , @speed

  action: ->
    @round += 1
    return @stop() if @round > @cycles

    [ x, y ] = [ Monkey.utils.randomInt(@xRange...),
                 Monkey.utils.randomInt(@yRange...) ]
    act = x: x, y: y, elem: document.elementFromPoint(x, y), idx: @round + 0

    @execute(act)

  execute: (act) ->
    act.actions = []

    for action in @actions
      if action.next == act.idx
        action.next = Monkey.utils.nextInterval(action.interval, act.idx)
        action.run(act)
        act.actions.push action

    @history.push act

  setPlace: (elem) ->
    if elem
      { top, bottom, left, right } = elem.getBoundingClientRect()
      @xRange = [ left | 0, right  | 0 ]
      @yRange = [ top  | 0, bottom | 0 ]
    else
      @xRange = [ 1, document.documentElement.clientWidth  ]
      @yRange = [ 1, document.documentElement.clientHeight ]

  @utils:
    # Returns a random integer between min (included) and max (excluded)
    # Using Math.round() will give you a non-uniform distribution!
    randomInt: (min, max) ->
      Math.floor(Math.random() * (max - min)) + min

    # Returns next integer after current number based on interval
    nextInterval: (interval, current = 0) ->
      if typeof interval == "function"
        interval(current)
      else if typeof interval == "number"
        current + interval
      else
        Monkey.utils.randomInt(interval...) + current

    # Apply CSS style to a DOM element
    style: (elem, styles) ->
      for attr, val of styles
        attr = attr.replace /-([a-z])/g, (match, c) -> c.toUpperCase()
        elem.style[attr] = val
      return

    # Plot a point at (x, y)
    plotPoint: (x, y, css = {}) ->
      point = document.createElement "div"

      Monkey.utils.style point,
        "z-index": 9999,
        "border": "3px solid " + (css.color || "red"),
        "border-radius": "50%",
        "width": "20px",
        "height": "20px",
        "position": "absolute",
        "top": (y - 10)+ "px",
        "left": (x - 10) + "px",
        "transition": "opacity 1s ease-out"

      point = document.body.appendChild point

      setTimeout (-> document.body.removeChild(point)), 1000
      setTimeout (-> Monkey.utils.style(point, opacity: 0)), 500

# A sample click behaviour
class ClickBehaviour
  constructor: ->
    @clickableTags = ["a", "button", "link", "input"]

  getHandler: -> @handler.bind(@)

  handler: ({ x, y, elem }) ->
    if elem and @isClickable(elem)
      @clickOn(elem)
      Monkey.utils.plotPoint(x, y, color: "green")
    else
      Monkey.utils.plotPoint(x, y)

  clickOn: (elem) ->
    ev = new MouseEvent "click", view: window, bubbles: true, cancelable: true
    elem.dispatchEvent(ev)

  isClickable: (elem) ->
    etag = elem.tagName.toLowerCase()
    for tag in @clickableTags
      return true if etag == tag
    return false

# A sample type behaviour
class TypeBehaviour
  constructor: ->
    @chars = "abcdefghijklmnopqrstuvwxyz01234567890"

  getHandler: -> @handler.bind(@)

  handler: ({ elem }) ->
    elems = document.querySelectorAll("input,textarea")
    return if elems.length == 0
    @typeIn elems[ Monkey.utils.randomInt(0, elems.length) ]

  typeIn: (elem) ->
    charsToEnter = Monkey.utils.randomInt(1, 9)
    while charsToEnter -= 1
      elem.value += @chars[ Monkey.utils.randomInt(0, @chars.length) ]
    return
