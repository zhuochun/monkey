# Monkey.js

_Naughty monkeys playing on your pages._

[Monkey.js](https://github.com/zhuochun/monkey) is a simple [monkey testing](http://en.wikipedia.org/wiki/Monkey_test) library for web pages.

It is inspired by [gremlins.js](https://github.com/marmelab/gremlins.js). However, Monkey.js is simpler, supports restricting DOM element for test and replay the actions.

## Usage

Create a naughty monkey:

```html
<script src="../src/monkey.js"></script>
<script>
  var monkey = new Monkey().behaviour(new ClickBehaviour().getHandler());

  monkey.play();
  monkey.replay();
</script>
```

Fastest way to have a monkey on a page, open `Developer Tool`, copy and paste the following:

```js
function loadJS(src, cb) {
    var doc = document, tag = "script", script = doc.createElement(tag), ref = doc.getElementsByTagName(tag)[0];
    script.async = 1; script.src = src;
    ref.parentNode.insertBefore(script, ref);
    script.onload = cb;
}

loadJS('https://cdn.rawgit.com/zhuochun/monkey/master/src/monkey.js', function() {
  var monkey = new Monkey().behaviour(new ClickBehaviour().getHandler()); monkey.play();
});
```

To create a custom behaviour:

```js
var monkey = new Monkey();

monkey.behaviour(function(ev) {
  // ev.x      screen position x
  // ev.y      screen position y
  // ev.elem   DOM element under position x,y

  // plot a circle at x, y position
  Monkey.utils.plotPoint(ev.x, ev.y);
});
```

Examples in `demo/demo.html`.

## License

MIT 2014 @ [Zhuochun](https://github.com/zhuochun).
