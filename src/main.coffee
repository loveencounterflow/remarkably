
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
@ReMarkable               = require 'remarkable'


#-----------------------------------------------------------------------------------------------------------
@_discover = ->
  globber = njs_path.join __dirname, './*/*.js'
  R       = []
  #.........................................................................................................
  for route in glob.sync globber
    extension_name  = ( ( njs_path.basename route ).replace /\.js$/, '' ).replace /-/g, '_'
    collection_name = ( njs_path.basename njs_path.dirname route        ).replace /-/g, '_'
    R.push [ collection_name, extension_name, route, ]
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
@get  = {}
_me   = @
do =>
  #.........................................................................................................
  for [ collection_name, extension_name, route, ] in _me._discover()
    #.......................................................................................................
    do ( collection_name, extension_name, route ) ->
      #.....................................................................................................
      ( _me.get[ collection_name ]?= {} )[ extension_name ] = ( settings ) ->
        R               = require route
        R               = R.get settings if R.get?
        full_name       = "REMARKABLY/#{collection_name}/#{extension_name}"
        R[ 'name'   ]   = full_name
        R[ 'about'  ]  ?= ( R[ 'about' ] ? "(no documentation for $name$)" ).replace /\$name\$/g, full_name
        #...................................................................................................
        for method_name in [ 'parse', 'render', 'extend', ]
          R[ method_name ] = method.bind R if ( method = R[ method_name ] )?
        #...................................................................................................
        return R

#===========================================================================================================
# EXTEND
#-----------------------------------------------------------------------------------------------------------
@use = ( remarkable_parser, extension ) ->
  return remarkable_parser.use extension.extend


#===========================================================================================================
# MAIN
#-----------------------------------------------------------------------------------------------------------
@main = ->
  RMY         = @
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
  RM                      = new RMY.ReMarkable enable, settings
  RMY.use RM, video       = RMY.get.examples.video()
  RMY.use RM, emphasis    = RMY.get.examples.emphasis()
  RMY.use RM, emphasis2   = RMY.get.examples.emphasis2()
  RMY.use RM, angles      = RMY.get.examples.brackets opener: '<', closer: '>', arity: 2, name: 'angles'
  RMY.use RM, braces      = RMY.get.examples.brackets opener: '{', closer: '}', arity: 2, name: 'braces'
  debug '©5t2', angles
  debug '©5t2', braces
  debug '©5t2', braces is angles
  source        = """=This= ==is== ===very=== _awesome_(c): %[example movie](http://example.com)
    *A* **B** ***C*** ****D****

    these are <<angle brackets>> and {{braces}}.

    ***E**** [link \\[title\\]](link-URL)

    ****F***"""
  whisper source
  info    html  = RM.render source
  # help()
  # help emphasis.about
  # help()
  # help emphasis2.about
  # help()
  # help video.about


############################################################################################################
unless module.parent?
  @main()

