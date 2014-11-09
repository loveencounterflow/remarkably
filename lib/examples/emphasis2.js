// Generated by CoffeeScript 1.8.0
(function() {
  this.about = "$name$ recognizes markup with `=single=` and `==repeated==` `===equals signs===`\nand translates them into pairs of `<em>...</em>` tags.";

  this._chr = '=';

  this.parse = function(state, silent) {
    var chr, content, count, match_end, match_start, max, pos, pos_max, src, start, start_0, start_1, stop_0, stop_1;
    if (state.src[state.pos] !== this._chr) {
      return false;
    }
    start = null;
    max = null;
    match_start = null;
    match_end = null;
    content = null;
    src = state.src, pos = state.pos, pos_max = state.posMax;
    if ((chr = src[pos]) !== this._chr) {
      return false;
    }
    start_0 = pos;
    while (pos < pos_max && src[pos] === this._chr) {
      pos += 1;
    }
    start_1 = pos;
    while (pos < pos_max && src[pos] !== this._chr) {
      pos += 1;
    }
    stop_0 = pos;
    while (pos < pos_max && src[pos] === this._chr) {
      pos += 1;
    }
    stop_1 = pos;
    if ((count = start_1 - start_0) !== (stop_1 - stop_0)) {
      return false;
    }
    if (!silent) {
      state.push({
        type: this.name,
        count: count,
        content: src.slice(start_1, stop_0),
        block: false,
        level: state.level
      });
    }
    state.pos = stop_1;
    return true;
  };

  this.render = function(tokens, idx) {
    var content, count, _ref;
    _ref = tokens[idx], content = _ref.content, count = _ref.count;
    switch (count) {
      case 1:
        return "<i>" + content + "</i>";
      case 2:
        return "<b>" + content + "</b>";
      default:
        return "<b><i>" + content + "</i></b>";
    }
  };

  this.extend = function(self) {
    self.inline.ruler.before(self.inline.ruler['rules'][0]['name'], this.name, this.parse);
    self.renderer.rules[this.name] = this.render;
    return null;
  };

}).call(this);