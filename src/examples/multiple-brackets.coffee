
############################################################################################################
BNP = require 'coffeenode-bitsnpieces'

#-----------------------------------------------------------------------------------------------------------
@about = """$name$ recognizes text stretches enclosed by multiple brackets."""

#-----------------------------------------------------------------------------------------------------------
@_get_multiple_bracket_pattern = ( opener, closer, arity = 2, anchor = no ) ->
  opener      = "(?:#{BNP.escape_regex opener})"
  closer      = "(?:#{BNP.escape_regex closer})"
  anchor      = if anchor then '^' else ''
  repeat_all  = if arity is 1 then '' else "{#{arity}}"
  repeat_some = if arity is 1 then '' else "{1,#{arity}}"
  #.........................................................................................................
  return """
    #{anchor}
    (#{opener}#{repeat_all}(?!#{opener}))
      ((?:
        \\\\#{closer}|
        [^#{closer}]|
        #{closer}#{repeat_some}(?!#{closer})
      )*)
      (#{closer}#{repeat_all})(?!#{closer})
    """.replace /\n\s*/g, ''

#-----------------------------------------------------------------------------------------------------------
@_pattern = @_get_multiple_bracket_pattern '<', '>', 2, yes
@_re      = new RegExp @_pattern, 'g' # need `g` for lastIndex

#-----------------------------------------------------------------------------------------------------------
@parse = ( state, silent ) ->
  #.........................................................................................................
  { src, pos, }   = state
  @_re.lastIndex  = pos
  return false if ( not ( match = @_re.exec src )? ) or match[ 'index' ] isnt pos
  [ all, opener, content, closer, ] = match
  unless silent
    state.push
      type:     @name
      opener:   opener
      closer:   closer
      content:  content
      block:    false
      level:    state.level
  #.........................................................................................................
  state.pos += all.length
  return true

#-----------------------------------------------------------------------------------------------------------
@render = ( tokens, idx ) -> # options
  { content, opener, closer, } = tokens[ idx ]
  d = opener.length
  return "<em class='angled-#{d}'>#{content}</em>"

#-----------------------------------------------------------------------------------------------------------
@extend = ( self ) ->
  self.inline.ruler.before self.inline.ruler[ 'rules' ][ 0 ][ 'name' ], @name, @parse
  self.renderer.rules[ @name ] = @render
  return null
