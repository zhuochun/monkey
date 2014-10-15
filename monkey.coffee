utils =
  # Returns a random integer between min (included) and max (excluded)
  # Using Math.round() will give you a non-uniform distribution!
  randomInt: (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

  # Returns next integer after current + interval
  nextInterval: (interval, current = 0) ->
    if typeof interval == "function"
      interval(current)
    else if typeof interval == "number"
      interval + current
    else
      utils.randomInt(interval...) + current

# usage example:
#
# new Monkey().behaviour(new ClickBehaviour().getHandler()).run()
#
class Monkey
  constructor: (options = {}) ->
    @actions = []
    @history = []
    @round   = 0
    @cycles  = options.cycles || 10
    @initRegion(options.element)

  behaviour: (action, interval) ->
    interval = 1 unless interval
    next = utils.nextInterval(interval)
    @actions.push(run: action, interval: interval, next: next)
    return @

  run: ->
    return if @timeId

    round = 0
    @timeId = setInterval =>
                if round++ >= @cycles then @stop()
                else @doAction(round)
              , 50

  pause: -> # TODO

  stop: ->
    clearTimeout(@timeId) if @timeId

  reRun: (startIdx, endIdx) ->
    return unless history.length

    if startIdx and endIdx
      # TODO
    else
      # TODO

  doAction: (round) ->
    pos = x: utils.randomInt(@xRange...), y: utils.randomInt(@yRange...)

    @history.push pos

    console.log "Round #{round} -> x: #{pos.x}, y: #{pos.y}"

    for action in @actions
      if action.next == round
        action.run pos
        action.next = utils.nextInterval(action.interval, round)

  # Set x,y point range
  initRegion: (elem) ->
    if elem
      { top, bottom, left, right } = elem.getBoundingClientRect()

      @xRange = [ left | 0, right  | 0 ]
      @yRange = [ top  | 0, bottom | 0 ]
    else
      @xRange = [ 1, document.documentElement.clientWidth  ]
      @yRange = [ 1, document.documentElement.clientHeight ]

class ClickBehaviour
  constructor: ->
    @clickableTags = ['a', 'button', 'link', 'input']

  getHandler: -> @handler.bind(@)

  handler: ({ x, y }) ->
    elem = document.elementFromPoint(x, y)

    if elem and @isClickable(elem)
      console.log "Click on #{elem.innerHTML}"
      @clickOn elem

  clickOn: (elem) ->
    ev = new MouseEvent 'click',
                        'view': window,
                        'bubbles': true,
                        'cancelable': true
    elem.dispatchEvent(ev)

  isClickable: (elem) ->
    etag = a.tagName.toLowerCase()

    for tag in @clickableTags
      return true if etag == tag

    return false

class TypeBehaviour
  constructor: ->
    @chars = "abcdefghijklmnopqrstuvwxyz01234567890"

  getHandler: -> @handler.bind(@)

  handler: ->
    elems = document.querySelectorAll("input,textarea")
    return if elems.length == 0
    @typeIn elems[ utils.randomInt(0, elems.length) ]

  typeIn: (elem) ->
    nums = utils.randomInt(1, 5)
    elem.value += @chars[ utils.randomInt(0, @chars.length) ] while nums -= 1
