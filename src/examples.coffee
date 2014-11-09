
#===========================================================================================================
@video =

  #---------------------------------------------------------------------------------------------------------
  about: """The `video_extension` recognizes `%[title](href)` markup and turns it into `<video>` tag (note:
    if you you want this to work in your own code, you must correct the rendering output, which is more
    imaginary than correct right now—this is a MarkDown syntax plugin example, not an HTML5
    tutorial...)"""

  #---------------------------------------------------------------------------------------------------------
  _matcher: /^%\[([^\]]*)\]\s*\(([^)]+)\)/

  #---------------------------------------------------------------------------------------------------------
  parse: ( state, silent ) ->
    return false if state.src[ state.pos ] isnt '%'
    match = @_matcher.exec state.src[ state[ 'pos' ] .. ]
    return false unless match?
    unless silent
      description =
        type:   'video'
        title:  match[ 1 ]
        src:    match[ 2 ]
        level:  state.level
      state.push description
    # every rule should set state.pos to a position after token's contents:
    state.pos += match[ 0 ].length
    return true

  #---------------------------------------------------------------------------------------------------------
  render: ( tokens, idx ) -> # options
    { title, src, } = tokens[ idx ]
    return "<video href='#{src}'>#{title}</video>"

  #---------------------------------------------------------------------------------------------------------
  extend: ( self ) ->
    self.inline.ruler.after 'backticks', 'video', parse_video
    self.renderer.rules[ 'video' ] = render_video
    return null


#===========================================================================================================
@emphasis =

  #---------------------------------------------------------------------------------------------------------
  about: """Recognizes markup with `=equals signs=` and translates them into a pair of `<em>...</em>`
    tags."""

  #---------------------------------------------------------------------------------------------------------
  _chr: '='

  #---------------------------------------------------------------------------------------------------------
  parse: ( state, silent ) ->
    return false if state.src[ state.pos ] isnt @_chr
    start       = null
    max         = null
    match_start = null
    match_end   = null
    content     = null
    #.......................................................................................................
    { src, pos, posMax: pos_max, } = state
    return false if ( chr = src[ pos ] ) isnt @_chr
    #.......................................................................................................
    start       = pos
    pos        += 1
    pos        += 1 while pos < pos_max and src[ pos ] isnt @_chr
    stop        = pos
    #.......................................................................................................
    return false unless src[ pos ] is @_chr
    return false if stop is start + 1
    unless silent
      state.push
        type:     'emphasis'
        content:  src[ start + 1 ... stop ]
        block:    false
        level:    state.level
    #.......................................................................................................
    state.pos = stop + 1
    return true

  #---------------------------------------------------------------------------------------------------------
  render: ( tokens, idx ) -> # options
    { content, } = tokens[ idx ]
    return "<em>#{content}</em>"

  #---------------------------------------------------------------------------------------------------------
  extend: ( self ) ->
    self.inline.ruler.after 'backticks', 'emphasis', parse_emphasis
    self.renderer.rules[ 'emphasis' ] = render_emphasis
    return null


############################################################################################################
@emphasis2 =

  #---------------------------------------------------------------------------------------------------------
  about: """Recognizes markup with `=single=` and `==repeated==` `===equals signs===` and translates them
    into a pair of `<em>...</em>` tags."""

  #---------------------------------------------------------------------------------------------------------
  _chr: '='

  #---------------------------------------------------------------------------------------------------------
  parse: ( state, silent ) ->
    return false if state.src[ state.pos ] isnt @_chr
    start       = null
    max         = null
    match_start = null
    match_end   = null
    content     = null
    #.......................................................................................................
    { src, pos, posMax: pos_max, } = state
    return false if ( chr = src[ pos ] ) isnt @_chr
    #.......................................................................................................
    start       = pos
    pos        += 1
    pos        += 1 while pos < pos_max and src[ pos ] isnt @_chr
    stop        = pos
    #.......................................................................................................
    return false unless src[ pos ] is @_chr
    return false if stop is start + 1
    unless silent
      state.push
        type:     'emphasis'
        content:  src[ start + 1 ... stop ]
        block:    false
        level:    state.level
    #.......................................................................................................
    state.pos = stop + 1
    return true

  #---------------------------------------------------------------------------------------------------------
  render: ( tokens, idx ) -> # options
    { content, } = tokens[ idx ]
    return "<em>#{content}</em>"

  #---------------------------------------------------------------------------------------------------------
  extend: ( self ) ->
    self.inline.ruler.after 'backticks', 'emphasis', parse_emphasis
    self.renderer.rules[ 'emphasis' ] = render_emphasis
    return null
