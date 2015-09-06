


############################################################################################################
BNP                       = require 'coffeenode-bitsnpieces'
# #...........................................................................................................
# TRM                       = require 'coffeenode-trm'
# rpr                       = TRM.rpr.bind TRM
# badge                     = 'REMARKABLY/examples/brackets'
# log                       = TRM.get_logger 'plain',     badge
# info                      = TRM.get_logger 'info',      badge

###
active characters:
\`*_^[]!&<>{}$%@~+=:
###

#===========================================================================================================
@get = ( settings ) ->

  #---------------------------------------------------------------------------------------------------------
  rule                = {}
  rule._matcher       = settings?[ 'matcher'  ] ? '==='
  rule._chr_count     = rule._matcher.length
  rule.terminators    = rule._matcher[ 0 ]
  rule._class_name    = settings?[ 'name' ] ? 'fullwidth'
  rule.name           = 'REMARKABLY/examples/' + rule._class_name

  #---------------------------------------------------------------------------------------------------------
  rule.about = """$name$ recognizes a given markup and turns it into an HTML `<span class='fullwidth'>` tag."""

  #---------------------------------------------------------------------------------------------------------
  rule.parse = ( state, silent ) ->
    #.......................................................................................................
    { src, pos, }       = state
    return false unless src[ pos ... pos + rule._chr_count ] is rule._matcher
    unless silent
      state.push
        type:     rule.name
        matcher:  rule._matcher
        block:    false
        level:    state.level
    #.......................................................................................................
    state.pos += rule._chr_count
    return true

  #---------------------------------------------------------------------------------------------------------
  rule.render = ( tokens, idx ) -> # options
    return "<br>"

  #---------------------------------------------------------------------------------------------------------
  rule.extend = ( self ) ->
    self.inline.ruler.before self.inline.ruler[ '__rules__' ][ 0 ][ 'name' ], rule.name, rule.parse
    self.renderer.rules[ rule.name ] = rule.render
    return null

  #---------------------------------------------------------------------------------------------------------
  return rule


