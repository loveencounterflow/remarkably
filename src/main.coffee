
############################################################################################################
njs_path                  = require 'path'
#...........................................................................................................
TRM                       = require 'coffeenode-trm'
rpr                       = TRM.rpr.bind TRM
badge                     = 'REMARKABLY'
log                       = TRM.get_logger 'plain',     badge
info                      = TRM.get_logger 'info',      badge
whisper                   = TRM.get_logger 'whisper',   badge
alert                     = TRM.get_logger 'alert',     badge
debug                     = TRM.get_logger 'debug',     badge
warn                      = TRM.get_logger 'warn',      badge
help                      = TRM.get_logger 'help',      badge
urge                      = TRM.get_logger 'urge',      badge
echo                      = TRM.echo.bind TRM
TEXT                      = require 'coffeenode-text'
#...........................................................................................................
glob                      = require 'glob'


#-----------------------------------------------------------------------------------------------------------
@_discover = ->
  globber = njs_path.join __dirname, './*/*.js'
  R       = []
  #.........................................................................................................
  for route in glob.sync globber
    extension_name  = ( njs_path.basename route ).replace /\.js$/, ''
    collection_name = njs_path.basename njs_path.dirname route
    R.push [ collection_name, extension_name, route, ]
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
_me = @
get = @get = {}
do =>
  #.........................................................................................................
  for [ collection_name, extension_name, route, ] in _me._discover()
    #.......................................................................................................
    do ( collection_name, extension_name, route ) ->
      #.....................................................................................................
      ( get[ collection_name ]?= {} )[ extension_name ] = ->
        extension           = require route
        name                = extension[ 'name' ]?= extension_name
        #...................................................................................................
        for method_name in [ 'parse', 'render', 'extend', ]
          extension[ method_name ] = method.bind extension if ( method = extension[ method_name ] )?
        #...................................................................................................
        R             = extension.extend
        R[ 'name'   ] = full_name = "REMARKABLY/#{collection_name}/#{name}"
        R[ 'about'  ] = ( extension.about ? "(no documentation)" ).replace /\$name\$/g, full_name
        #...................................................................................................
        return R

#===========================================================================================================
# EXTEND
#-----------------------------------------------------------------------------------------------------------
@extend = ( remarkable_parser, extension ) ->
  return remarkable_parser.use extension


#===========================================================================================================
# MAIN
#-----------------------------------------------------------------------------------------------------------
@main = ->
  RMY         = require 'remarkably'
  # video_rmy   = require 'remarkably/lib/examples/video'
  ReMarkable  = require 'remarkable'
  #.........................................................................................................
  enable      = 'full'
  settings    =
    html:           yes,            # Enable HTML tags in source
    xhtmlOut:       no,             # Use '/' to close single tags (<br />)
    breaks:         no,             # Convert '\n' in paragraphs into <br>
    langPrefix:     'language-',    # CSS language prefix for fenced blocks
    linkify:        yes,            # Autoconvert URL-like text to links
    typographer:    yes,
    quotes:         '“”‘’'
  #.........................................................................................................
  RM          = new ReMarkable enable, settings
  # same as `remarkable_parser.use extension.extend`:
  # RMY.extend RM, RMY.examples.emphasis
  # RMY.extend RM, video_rmy
  RMY.extend RM, video      = RMY.get.examples.video()
  RMY.extend RM, emphasis   = RMY.get.examples.emphasis()
  RMY.extend RM, emphasis2  = RMY.get.examples.emphasis2()
  source        = """=This= ==is== ===very=== §awesome§(c): %[example movie](http://example.com)"""
  # whisper ast   = RM.parse  source
  info    html  = RM.render source
  help()
  help emphasis.about
  help()
  help emphasis2.about
  help()
  help video.about


############################################################################################################
unless module.parent?
  @main()

