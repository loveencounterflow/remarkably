// Generated by CoffeeScript 1.8.0
(function() {
  this.about = "The `video_extension` recognizes `%[title](href)` markup and turns it into `<video>` tag (note:\nif you you want this to work in your own code, you must correct the rendering output, which is more\nimaginary than correct right now—this is a MarkDown syntax plugin example, not an HTML5\ntutorial...)";

  this._matcher = /^%\[([^\]]*)\]\s*\(([^)]+)\)/;

  this.parse = function(state, silent) {
    var description, match;
    if (state.src[state.pos] !== '%') {
      return false;
    }
    match = this._matcher.exec(state.src.slice(state['pos']));
    if (match == null) {
      return false;
    }
    if (!silent) {
      description = {
        type: this.name,
        title: match[1],
        src: match[2],
        level: state.level
      };
      state.push(description);
    }
    state.pos += match[0].length;
    return true;
  };

  this.render = function(tokens, idx) {
    var src, title, _ref;
    _ref = tokens[idx], title = _ref.title, src = _ref.src;
    return "<video href='" + src + "'>" + title + "</video>";
  };

  this.extend = function(self) {
    var name;
    for (name in this) {
      console.log(name);
    }
    self.inline.ruler.after('backticks', this.name, this.parse.bind(this));
    self.renderer.rules[this.name] = this.render.bind(this);
    return null;
  };

}).call(this);