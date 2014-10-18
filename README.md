# Monkey.js

_Naughty monkeys playing on your pages._

[Monkey.js](https://github.com/zhuochun/monkey) is a simple [monkey testing](http://en.wikipedia.org/wiki/Monkey_test) library for web pages.

It is inspired by [gremlins.js](https://github.com/marmelab/gremlins.js). Monkey.js is simpler, and supports restricting area, and action replays.

## Usage

Create a naughty monkey:

```js
<script src="../src/monkey.js"></script>
<script>
  var monkey = new Monkey().behaviour(new ClickBehaviour().getHandler());
  monkey.play();
  monkey.replay();
</script>
```

Add custom behaviours:

```js
var monkey = new Monkey();

monkey.behaviour(function(ev) {
  // ev.x    screen position x
  // ev.y    screen position y
  // ev.elem DOM element under position x,y

  // plot a circle at x, y position
  Monkey.utils.plotPoint(ev.x, ev.y);
});
```

Examples in `demo/demo.html`.

## License

MIT 2014 @ [Zhuochun](https://github.com/zhuochun).
