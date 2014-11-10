

#-----------------------------------------------------------------------------------------------------------
@about = """$name$ recognizes markup with `<<double angled brackets>>` and `《CJK angled brackets》` and
  translates them into pairs of `<span class='book-title'>...</span>` tags."""

#-----------------------------------------------------------------------------------------------------------
$.text_quoted_triple_heavy_matcher = /// ^  # A triple heavy-quoted text literal starts with
  <<                                     # three heavy quotes,
    (?:                                   # followed by
      \\<                |                # an escaped heavy quote, or
      [^<]               |                # anything but a quote, or
      >(?!>)                         # one or two heavy quotes not followed by yet another heavy quote
    )*                                    # repeated any number of times
    >>                                   # and, finally, three heavy quotes.
  ///

@_openers = [ /<</, /《/, ]
@_closers = [ />>/, /》/, ]

#-----------------------------------------------------------------------------------------------------------
@_test_opener = ( src, pos ) -> @_test src, pos, @_openers
@_test_closer = ( src, pos ) -> @_test src, pos, @_closers

#-----------------------------------------------------------------------------------------------------------
@_test = ( src, pos, matchers ) ->
  for matcher, idx in matchers
    ### TAINT any way to avoid building (many) substrings here? ###
    return idx if matcher.test src[ pos .. ]
  return null

#-----------------------------------------------------------------------------------------------------------
@parse = ( state, silent ) ->
  { src, pos, posMax: pos_max, } = state
  return false unless opener_idx = @_test_opener src, pos
  start       = null
  max         = null
  match_start = null
  match_end   = null
  content     = null
  #.........................................................................................................
  return false if src[ pos ] isnt @_matcher
  #.........................................................................................................
  start       = pos
  pos        += 1
  pos        += 1 while pos < pos_max and src[ pos ] isnt @_matcher
  stop        = pos
  #.........................................................................................................
  return false unless src[ pos ] is @_matcher
  return false if stop is start + 1
  unless silent
    state.push
      type:     @name
      content:  src[ start + 1 ... stop ]
      block:    false
      level:    state.level
  #.........................................................................................................
  state.pos = stop + 1
  return true

#-----------------------------------------------------------------------------------------------------------
@render = ( tokens, idx ) -> # options
  { content, } = tokens[ idx ]
  return "<span class='book-title'>#{content}</span>"

#-----------------------------------------------------------------------------------------------------------
@extend = ( self ) ->
  self.inline.ruler.before self.inline.ruler[ 'rules' ][ 0 ][ 'name' ], @name, @parse
  self.renderer.rules[ @name ] = @render
  return null
