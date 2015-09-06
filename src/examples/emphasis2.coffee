
#-----------------------------------------------------------------------------------------------------------
@about = """$name$ recognizes markup with `=single=` and `==repeated==` `===equals signs===`
  and translates them into pairs of `<em>...</em>` tags."""

#-----------------------------------------------------------------------------------------------------------
@_chr = '='

#-----------------------------------------------------------------------------------------------------------
@parse = ( state, silent ) ->
  return false if state.src[ state.pos ] isnt @_chr
  start       = null
  max         = null
  match_start = null
  match_end   = null
  content     = null
  #.........................................................................................................
  { src, pos, posMax: pos_max, } = state
  return false if ( chr = src[ pos ] ) isnt @_chr
  #.........................................................................................................
  start_0     = pos
  pos        += 1 while pos < pos_max and src[ pos ] is @_chr
  start_1     = pos
  pos        += 1 while pos < pos_max and src[ pos ] isnt @_chr
  stop_0      = pos
  pos        += 1 while pos < pos_max and src[ pos ] is @_chr
  stop_1      = pos
  #.........................................................................................................
  return false unless ( count = start_1 - start_0 ) is ( stop_1 - stop_0 )
  unless silent
    state.push
      type:     @name
      count:    count
      content:  src[ start_1 ... stop_0 ]
      block:    false
      level:    state.level
  #.........................................................................................................
  state.pos = stop_1
  return true

#-----------------------------------------------------------------------------------------------------------
@render = ( tokens, idx ) -> # options
  { content, count, } = tokens[ idx ]
  return switch count
    when 1 then "<i>#{content}</i>"
    when 2 then "<b>#{content}</b>"
    else        "<b><i>#{content}</i></b>"

#-----------------------------------------------------------------------------------------------------------
@extend = ( self ) ->
  self.inline.ruler.before self.inline.ruler[ '__rules__' ][ 0 ][ 'name' ], @name, @parse
  self.renderer.rules[ @name ] = @render
  return null






