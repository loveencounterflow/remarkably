// Generated by CoffeeScript 1.9.1
(function() {
  var BNP, TRM, badge, info, log, rpr;

  BNP = require('coffeenode-bitsnpieces');

  TRM = require('coffeenode-trm');

  rpr = TRM.rpr.bind(TRM);

  badge = 'REMARKABLY/examples/brackets';

  log = TRM.get_logger('plain', badge);

  info = TRM.get_logger('info', badge);

  this.get = function(settings) {
    var ref, ref1, ref2, ref3, rule;
    rule = {};
    rule._opener = (ref = settings != null ? settings['opener'] : void 0) != null ? ref : '<';
    rule._closer = (ref1 = settings != null ? settings['closer'] : void 0) != null ? ref1 : '>';
    rule.terminators = rule._opener;
    rule._arity = (ref2 = settings != null ? settings['arity'] : void 0) != null ? ref2 : 2;
    rule._class_name = (ref3 = settings != null ? settings['name'] : void 0) != null ? ref3 : 'angles';
    rule.name = 'REMARKABLY/examples/' + rule._class_name;
    rule.about = "$name$ recognizes text stretches enclosed by multiple brackets.";
    rule._get_multiple_bracket_pattern = function(opener, closer, arity, anchor) {
      var repeat_all, repeat_some;
      if (arity == null) {
        arity = 2;
      }
      if (anchor == null) {
        anchor = false;
      }
      opener = "(?:" + (BNP.escape_regex(opener)) + ")";
      closer = "(?:" + (BNP.escape_regex(closer)) + ")";
      anchor = anchor ? '^' : '';
      repeat_all = arity === 1 ? '' : "{" + arity + "}";
      repeat_some = arity === 1 ? '' : "{1," + arity + "}";
      return (anchor + "\n(" + opener + repeat_all + "(?!" + opener + "))\n  ((?:\n    \\\\" + closer + "|\n    [^" + closer + "]|\n    " + closer + repeat_some + "(?!" + closer + ")\n  )*)\n  (" + closer + repeat_all + ")(?!" + closer + ")").replace(/\n\s*/g, '');
    };
    rule._pattern = rule._get_multiple_bracket_pattern(rule._opener, rule._closer, rule._arity, false);
    rule._re = new RegExp(rule._pattern, 'g');
    rule.parse = function(state, silent) {
      var all, closer, content, match, opener, pos, src;
      src = state.src, pos = state.pos;
      rule._re.lastIndex = pos;
      if (((match = rule._re.exec(src)) == null) || match['index'] !== pos) {
        return false;
      }
      all = match[0], opener = match[1], content = match[2], closer = match[3];
      if (!silent) {
        state.push({
          type: rule.name,
          opener: opener,
          closer: closer,
          content: content,
          block: false,
          level: state.level
        });
      }
      state.pos += all.length;
      return true;
    };
    rule.render = function(tokens, idx) {
      var closer, content, opener, ref4;
      ref4 = tokens[idx], content = ref4.content, opener = ref4.opener, closer = ref4.closer;
      return "<span class='" + rule._class_name + "'>" + content + "</span>";
    };
    rule.extend = function(self) {
      self.inline.ruler.before(self.inline.ruler['__rules__'][0]['name'], rule.name, rule.parse);
      self.renderer.rules[rule.name] = rule.render;
      return null;
    };
    return rule;
  };

}).call(this);
