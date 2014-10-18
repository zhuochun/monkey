// Generated by CoffeeScript 1.8.0
var ClickBehaviour, Monkey, TypeBehaviour;

Monkey = (function() {
  function Monkey(options) {
    if (options == null) {
      options = {};
    }
    this.actions = [];
    this.history = [];
    this.setPlace(options.element);
    this.cycles = options.cycles || 10;
    this.round = 0;
    this.speed = options.speed || 50;
  }

  Monkey.prototype.behaviour = function(action, interval) {
    var next;
    if (!interval) {
      interval = 1;
    }
    next = Monkey.utils.nextInterval(interval);
    this.actions.push({
      run: action,
      interval: interval,
      next: next
    });
    return this;
  };

  Monkey.prototype.reset = function() {
    var action, _i, _len, _ref;
    this.round = 0;
    _ref = this.actions;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      action = _ref[_i];
      action.next = Monkey.utils.nextInterval(action.interval, 0);
    }
    return this.history.length = 0;
  };

  Monkey.prototype.stop = function() {
    clearTimeout(this.timeId);
    return this.timeId = null;
  };

  Monkey.prototype.play = function() {
    this.stop();
    return this.timeId = setInterval(((function(_this) {
      return function() {
        return _this.action();
      };
    })(this)), this.speed);
  };

  Monkey.prototype.replay = function(startIdx, endIdx) {
    if (startIdx == null) {
      startIdx = 0;
    }
    if (endIdx == null) {
      endIdx = this.history.length;
    }
    this.stop();
    if (endIdx === 0 || startIdx > endIdx) {
      return;
    }
    return this.timeId = setInterval((function(_this) {
      return function() {
        var act, action, _i, _len, _ref;
        startIdx += 1;
        if (startIdx > endIdx) {
          return _this.stop();
        }
        act = _this.history[startIdx - 1];
        _ref = act.actions;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          action = _ref[_i];
          action.run(act);
        }
      };
    })(this), this.speed);
  };

  Monkey.prototype.action = function() {
    var act, x, y, _ref, _ref1, _ref2;
    this.round += 1;
    if (this.round > this.cycles) {
      return this.stop();
    }
    _ref2 = [(_ref = Monkey.utils).randomInt.apply(_ref, this.xRange), (_ref1 = Monkey.utils).randomInt.apply(_ref1, this.yRange)], x = _ref2[0], y = _ref2[1];
    act = {
      x: x,
      y: y,
      elem: document.elementFromPoint(x, y),
      idx: this.round + 0
    };
    return this.execute(act);
  };

  Monkey.prototype.execute = function(act) {
    var action, _i, _len, _ref;
    act.actions = [];
    _ref = this.actions;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      action = _ref[_i];
      if (action.next === act.idx) {
        action.next = Monkey.utils.nextInterval(action.interval, act.idx);
        action.run(act);
        act.actions.push(action);
      }
    }
    return this.history.push(act);
  };

  Monkey.prototype.setPlace = function(elem) {
    var bottom, left, right, top, _ref;
    if (elem) {
      _ref = elem.getBoundingClientRect(), top = _ref.top, bottom = _ref.bottom, left = _ref.left, right = _ref.right;
      this.xRange = [left | 0, right | 0];
      return this.yRange = [top | 0, bottom | 0];
    } else {
      this.xRange = [1, document.documentElement.clientWidth];
      return this.yRange = [1, document.documentElement.clientHeight];
    }
  };

  Monkey.utils = {
    randomInt: function(min, max) {
      return Math.floor(Math.random() * (max - min)) + min;
    },
    nextInterval: function(interval, current) {
      var _ref;
      if (current == null) {
        current = 0;
      }
      if (typeof interval === "function") {
        return interval(current);
      } else if (typeof interval === "number") {
        return current + interval;
      } else {
        return (_ref = Monkey.utils).randomInt.apply(_ref, interval) + current;
      }
    },
    style: function(elem, styles) {
      var attr, val;
      for (attr in styles) {
        val = styles[attr];
        attr = attr.replace(/-([a-z])/g, function(match, c) {
          return c.toUpperCase();
        });
        elem.style[attr] = val;
      }
    },
    plotPoint: function(x, y, css) {
      var point;
      if (css == null) {
        css = {};
      }
      point = document.createElement("div");
      Monkey.utils.style(point, {
        "z-index": 9999,
        "border": "3px solid " + (css.color || "red"),
        "border-radius": "50%",
        "width": "20px",
        "height": "20px",
        "position": "absolute",
        "top": (y - 10) + "px",
        "left": (x - 10) + "px",
        "transition": "opacity 1s ease-out"
      });
      point = document.body.appendChild(point);
      setTimeout((function() {
        return document.body.removeChild(point);
      }), 1000);
      return setTimeout((function() {
        return Monkey.utils.style(point, {
          opacity: 0
        });
      }), 500);
    }
  };

  return Monkey;

})();

ClickBehaviour = (function() {
  function ClickBehaviour() {
    this.clickableTags = ["a", "button", "link", "input"];
  }

  ClickBehaviour.prototype.getHandler = function() {
    return this.handler.bind(this);
  };

  ClickBehaviour.prototype.handler = function(_arg) {
    var elem, x, y;
    x = _arg.x, y = _arg.y, elem = _arg.elem;
    if (elem && this.isClickable(elem)) {
      this.clickOn(elem);
      return Monkey.utils.plotPoint(x, y, {
        color: "green"
      });
    } else {
      return Monkey.utils.plotPoint(x, y);
    }
  };

  ClickBehaviour.prototype.clickOn = function(elem) {
    var ev;
    ev = new MouseEvent("click", {
      view: window,
      bubbles: true,
      cancelable: true
    });
    return elem.dispatchEvent(ev);
  };

  ClickBehaviour.prototype.isClickable = function(elem) {
    var etag, tag, _i, _len, _ref;
    etag = elem.tagName.toLowerCase();
    _ref = this.clickableTags;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tag = _ref[_i];
      if (etag === tag) {
        return true;
      }
    }
    return false;
  };

  return ClickBehaviour;

})();

TypeBehaviour = (function() {
  function TypeBehaviour() {
    this.chars = "abcdefghijklmnopqrstuvwxyz01234567890";
  }

  TypeBehaviour.prototype.getHandler = function() {
    return this.handler.bind(this);
  };

  TypeBehaviour.prototype.handler = function(_arg) {
    var elem, elems;
    elem = _arg.elem;
    elems = document.querySelectorAll("input,textarea");
    if (elems.length === 0) {
      return;
    }
    return this.typeIn(elems[Monkey.utils.randomInt(0, elems.length)]);
  };

  TypeBehaviour.prototype.typeIn = function(elem) {
    var charsToEnter;
    charsToEnter = Monkey.utils.randomInt(1, 9);
    while (charsToEnter -= 1) {
      elem.value += this.chars[Monkey.utils.randomInt(0, this.chars.length)];
    }
  };

  return TypeBehaviour;

})();