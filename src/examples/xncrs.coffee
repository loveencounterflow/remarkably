


############################################################################################################
TRM                       = require 'coffeenode-trm'
rpr                       = TRM.rpr.bind TRM
badge                     = 'REMARKABLY/examples/brackets'
log                       = TRM.get_logger 'plain',     badge
info                      = TRM.get_logger 'info',      badge
#...........................................................................................................
BNP                       = require 'coffeenode-bitsnpieces'
CHR                       = require 'coffeenode-chr'


#-----------------------------------------------------------------------------------------------------------
@about = """$name$ recognizes non-standard, extended HTML Numerical Character References (XNCRs)."""

#-----------------------------------------------------------------------------------------------------------
@_matcher     = /&([^#]+)#x([0-9a-f]+);/gi
# @terminators  = '&'

#-----------------------------------------------------------------------------------------------------------
@parse = ( state, silent ) ->
  { src, pos, }           = state
  return false unless src[ pos ] is '&'
  @_matcher.lastIndex     = pos
  match                   = @_matcher.exec src
  return false if ( not match? ) or match[ 'index' ] isnt pos
  [ all, csg, cid_hex, ]  = match
  unless silent
    description =
      type:   @name
      csg:    csg
      cid:    parseInt cid_hex, 16
      level:  state.level
    state.push description
  # every rule should set state.pos to a position after token's contents:
  state.pos += all.length
  return true

#-----------------------------------------------------------------------------------------------------------
@render = ( tokens, idx ) -> # options
  { csg, cid, } = tokens[ idx ]
  chr = CHR.as_uchr cid
  return "<span class='csg #{csg}' cid='#{cid}'>#{chr}</span>"

#-----------------------------------------------------------------------------------------------------------
@extend = ( self ) ->
  # last_idx = self.inline.ruler[ 'rules' ].length - 1
  # self.inline.ruler.after self.inline.ruler[ 'rules' ][ last_idx ][ 'name' ], @name, @parse
  self.inline.ruler.before self.inline.ruler[ 'rules' ][ 0 ][ 'name' ], @name, @parse
  self.renderer.rules[ @name ] = @render
  return null
