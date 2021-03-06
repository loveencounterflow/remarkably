// Generated by CoffeeScript 1.9.1
(function() {
  this.about = "$name$ recognizes markup with `_underscores_` and translates them into\npairs of `<em>...</em>` tags.";

  this._chr = '_';

  this.parse = function(state, silent) {
    var content, match_end, match_start, max, pos, pos_max, src, start, stop;
    if (state.src[state.pos] !== this._chr) {
      return false;
    }
    start = null;
    max = null;
    match_start = null;
    match_end = null;
    content = null;
    src = state.src, pos = state.pos, pos_max = state.posMax;
    if (src[pos] !== this._chr) {
      return false;
    }
    start = pos;
    pos += 1;
    while (pos < pos_max && src[pos] !== this._chr) {
      pos += 1;
    }
    stop = pos;
    if (src[pos] !== this._chr) {
      return false;
    }
    if (stop === start + 1) {
      return false;
    }
    if (!silent) {
      state.push({
        type: this.name,
        content: src.slice(start + 1, stop),
        block: false,
        level: state.level
      });
    }
    state.pos = stop + 1;
    return true;
  };

  this.render = function(tokens, idx) {
    var content;
    content = tokens[idx].content;
    return "<em>" + content + "</em>";
  };

  this.extend = function(self) {
    self.inline.ruler.before(self.inline.ruler['__rules__'][0]['name'], this.name, this.parse);
    self.renderer.rules[this.name] = this.render;
    return null;
  };

}).call(this);
