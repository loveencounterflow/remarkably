


############################################################################################################
BNP = require 'coffeenode-bitsnpieces'

#===========================================================================================================
@get = ( settings ) ->
  rule         = {}
  rule._opener = settings?[ 'opener' ] ? '<'
  rule._closer = settings?[ 'closer' ] ? '>'
  rule._arity  = settings?[  'arity' ] ? 2
  rule._name   = settings?[  'name'  ] ? 'angles'

  #---------------------------------------------------------------------------------------------------------
  rule.about = """$name$ recognizes text stretches enclosed by multiple brackets."""

  #---------------------------------------------------------------------------------------------------------
  rule._get_multiple_bracket_pattern = ( opener, closer, arity = 2, anchor = no ) ->
    opener      = "(?:#{BNP.escape_regex opener})"
    closer      = "(?:#{BNP.escape_regex closer})"
    anchor      = if anchor then '^' else ''
    repeat_all  = if arity is 1 then '' else "{#{arity}}"
    repeat_some = if arity is 1 then '' else "{1,#{arity}}"
    #.......................................................................................................
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

  #---------------------------------------------------------------------------------------------------------
  rule._pattern = rule._get_multiple_bracket_pattern rule._opener, rule._closer, rule._arity, no
  rule._re      = new RegExp rule._pattern, 'g' # need `g` for `lastIndex`

  #---------------------------------------------------------------------------------------------------------
  rule.parse = ( state, silent ) ->
    #.......................................................................................................
    { src, pos, }   = state
    rule._re.lastIndex  = pos
    return false if ( not ( match = rule._re.exec src )? ) or match[ 'index' ] isnt pos
    [ all, opener, content, closer, ] = match
    unless silent
      state.push
        type:     rule.name
        opener:   opener
        closer:   closer
        content:  content
        block:    false
        level:    state.level
    #.......................................................................................................
    state.pos += all.length
    return true

  #---------------------------------------------------------------------------------------------------------
  rule.render = ( tokens, idx ) -> # options
    { content, opener, closer, } = tokens[ idx ]
    console.log '©4g6', opener, closer, rule._name
    return "<em class='#{rule._name}'>#{content}</em>"

  #---------------------------------------------------------------------------------------------------------
  rule.extend = ( self ) ->
    self.inline.ruler.before self.inline.ruler[ 'rules' ][ 0 ][ 'name' ], rule.name, rule.parse
    self.renderer.rules[ rule.name ] = rule.render
    return null

  #---------------------------------------------------------------------------------------------------------
  return rule

