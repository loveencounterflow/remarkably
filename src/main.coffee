
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
TYPES                     = require 'coffeenode-types'
#...........................................................................................................
glob                      = require 'glob'
@ReMarkable               = require 'remarkable'
# @ReMarkable               = require 'remarkable-dev'
@_terminator_chrs         = ( require 'remarkable-dev/lib/rules_inline/text' )[ 'terminatorChrs' ]


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
@_extend = ( collection_name, extension_name, route ) ->
  #.........................................................................................................
  getter = ( settings ) =>
    extension       = require route
    R               = if extension.get? then extension.get settings else extension
    name            = R[ 'name'   ]?= "REMARKABLY/#{collection_name}/#{extension_name}"
    about           = R[ 'about'  ]?= "(no documentation for $name$)"
    R[ 'about'  ]   = about.replace /\$name\$/g, name
    #.......................................................................................................
    if ( terminators = R.terminators )?
      chrs = if TYPES.isa_list terminators then terminators else TEXT.split terminators
      # debug '©kR6ej', name, chrs
      @_terminator_chrs[ chr ] = true for chr in chrs
    #.......................................................................................................
    for method_name in [ 'parse', 'render', 'extend', ]
      R[ method_name ] = method.bind R if ( method = R[ method_name ] )?
    #.......................................................................................................
    return R
  #.........................................................................................................
  target                    = @get[ collection_name ]?= {}
  target[ extension_name ]  = getter
  return null

#-----------------------------------------------------------------------------------------------------------
@get  = {}

#-----------------------------------------------------------------------------------------------------------
do =>
  for [ collection_name, extension_name, route, ] in @_discover()
    @_extend collection_name, extension_name, route


#===========================================================================================================
# USE
#-----------------------------------------------------------------------------------------------------------
@use = ( remarkable_parser, extension ) ->
  return remarkable_parser.use extension.extend

#===========================================================================================================
# INSTANTIATION
#-----------------------------------------------------------------------------------------------------------
@new_parser = ( P... ) ->
  return new @ReMarkable P...


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
  RM                    = RMY.new_parser enable, settings
  RMY.use RM, video     = RMY.get.examples.video()
  RMY.use RM, emphasis  = RMY.get.examples.emphasis()
  RMY.use RM, emphasis2 = RMY.get.examples.emphasis2()
  RMY.use RM, braces    = RMY.get.examples.brackets opener: '{',  closer: '}', arity: 2, name: 'braces'
  RMY.use RM, angles    = RMY.get.examples.brackets opener: '<',  closer: '>', arity: 2, name: 'angles'
  RMY.use RM, brackets  = RMY.get.examples.brackets opener: '[',  closer: ']', arity: 3, name: 'brackets-3'
  RMY.use RM, smh       = RMY.get.examples.brackets opener: '《',  closer: '》', arity: 1, name: 'book-title'
  RMY.use RM,             RMY.get.examples.brackets opener: '+',  closer: '+', arity: 1, name: 'plus-1'
  RMY.use RM,             RMY.get.examples.brackets opener: '+',  closer: '+', arity: 2, name: 'plus-2'
  RMY.use RM,             RMY.get.examples.brackets opener: '+',  closer: '+', arity: 3, name: 'plus-3'
  RMY.use RM,             RMY.get.examples.brackets opener: '+',  closer: '+', arity: 4, name: 'plus-4'
  RMY.use RM,             RMY.get.examples.newline matcher: '$$'
  RMY.use RM,             RMY.get.examples.xncrs()
  debug @_terminator_chrs
  # debug '©5t2', angles
  # debug '©5t2', braces
  # debug '©5t2', braces is angles
  source        = """
    =This= ==is== ===very=== _awesome_(c): %[example movie](http://example.com)
    *A* **B** ***C*** ****D****

    A line$$with a newline.

    A non-standard, namespaced XNCR: &jzr#xe100;

    Here are
    * <<double pointy brackets>>,
    * {{double braces}},
    * [[[triple square brackets]]],
    * +single plus signs+,
    * ++double plus signs++,
    * +++triple plus signs+++,
    * ++++quadruple plus signs++++,
    * 也可以用 《中文書名号》 。
    """.trim()
  whisper source
  info html = RM.render source
  # help()
  # help emphasis.about
  # help()
  # help emphasis2.about
  # help()
  # help video.about


############################################################################################################
unless module.parent?
  @main()

