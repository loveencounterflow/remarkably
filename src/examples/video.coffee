


#-----------------------------------------------------------------------------------------------------------
@about = """$name$ recognizes `%[title](href)` markup and turns it into `<video>` tag (note:
  if you you want this to work in your own code, you must correct the rendering output, which is more
  imaginary than correct right now—this is a MarkDown syntax plugin example, not an HTML5
  tutorial...)"""

#-----------------------------------------------------------------------------------------------------------
@_matcher = /^%\[([^\]]*)\]\s*\(([^)]+)\)/

#-----------------------------------------------------------------------------------------------------------
@parse = ( state, silent ) ->
  return false if state.src[ state.pos ] isnt '%'
  match = @_matcher.exec state.src[ state[ 'pos' ] .. ]
  return false unless match?
  unless silent
    description =
      type:   @name
      title:  match[ 1 ]
      src:    match[ 2 ]
      level:  state.level
    state.push description
  # every rule should set state.pos to a position after token's contents:
  state.pos += match[ 0 ].length
  return true

#-----------------------------------------------------------------------------------------------------------
@render = ( tokens, idx ) -> # options
  { title, src, } = tokens[ idx ]
  return "<video href='#{src}'>#{title}</video>"

#-----------------------------------------------------------------------------------------------------------
@extend = ( self ) ->
  self.inline.ruler.after 'backticks', @name, @parse
  self.renderer.rules[ @name ] = @render
  return null
