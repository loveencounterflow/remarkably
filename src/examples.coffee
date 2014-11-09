

#===========================================================================================================
@emphasis =

  #---------------------------------------------------------------------------------------------------------
  name:   'emphasis'
  about:  """Recognizes markup with `=equals signs=` and translates them into a pair of `<em>...</em>`
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
        type:     @name
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
    self.inline.ruler.after 'backticks', @name, @parse
    self.renderer.rules[ @name ] = @render
    return null


############################################################################################################
@emphasis2 =


  #---------------------------------------------------------------------------------------------------------
  name:   'emphasis2'
  about:  """Recognizes markup with `=single=` and `==repeated==` `===equals signs===` and translates them
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
        type:     @name
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
    self.inline.ruler.after 'backticks', @name, @parse.bind @
    self.renderer.rules[ @name ] = @render.bind @
    return null
