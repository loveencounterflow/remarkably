
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
  for [ collection_name, extension_name, route, ] in _me._discover()
    do ( collection_name, extension_name, route ) ->
      ( get[ collection_name ]?= {} )[ extension_name ] = ->
        extension = require route
        for name in [ 'parse', 'render', 'extend', ]
          extension[ name ] = method.bind extension if ( method = extension[ name ] )?
        R = extension.extend
        R[ 'name'   ] = "REMARKABLY/#{collection_name}/#{extension_name}"
        R[ 'about'  ] = extension.about ? "(no documentation)"
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
  enable    = 'full'
  settings  =
    html:         yes,            # Enable HTML tags in source
    xhtmlOut:     no,             # Use '/' to close single tags (<br />)
    breaks:       no,             # Convert '\n' in paragraphs into <br>
    langPrefix:   'language-',    # CSS language prefix for fenced blocks
    linkify:      yes,            # Autoconvert URL-like text to links
    typographer:  yes,
    quotes: '“”‘’'
  MD = new ( require 'remarkable' ) enable, settings
  debug @video
  debug @emphasis
  debug @emphasis2

  # MD.use emphasis_extension
  # MD.use    video_extension
  source = """
    This =is= 'awesome'(c): %[example movie](http://example.com)
    """
  ###
    ## helo world

    > Blockquotes become `<p>` tags
    > inside `<blockquote>` tags.
    >
    > Another
    > `<p>` within the same `<blockquote>`.

    H~2~O

    <!-- produces `<pre><code>...</code></pre>`: -->
    ```coffee
    f = ( x ) -> x * x
    g = ( x ) -> x + x

    ```
  ###
  info html = MD.render source
  # #.........................................................................................................
  # htmlparser = require 'htmlparser2'
  # #.........................................................................................................
  # settings =
  #   # 'xmlMode':                  # Special behavior for script/style tags (true by default)
  #   # 'lowerCaseAttributeNames':  # call .toLowerCase for each attribute name (true if xmlMode is `false`)
  #   # 'lowerCaseTags':            # call .toLowerCase for each tag name (true if xmlMode is `false`)
  # #.........................................................................................................
  # handler =
  #   #.......................................................................................................
  #   onopentag: ( name, attributes ) =>
  #     log TRM.green name, attributes
  #   #.......................................................................................................
  #   ontext: ( text ) =>
  #     log TRM.blue rpr text # if text.length > 0 and not /^\s+$/.test text
  #   #.......................................................................................................
  #   onclosetag: ( name ) =>
  #     log TRM.red name
  #   #.......................................................................................................
  #   onend: =>
  #     log TRM.red 'done.'
  #   #.......................................................................................................
  #   oncomment: ( text ) =>
  #     whisper rpr text
  #   # oncdataend:
  #   # oncdatastart:
  #   # oncommentend:  ( P ) => help P
  #   # onerror:
  #   # onprocessinginstruction:
  #   # onreset:
  # # handler = {}
  # #.........................................................................................................
  # parser = new htmlparser.Parser handler, settings
  # parser.write html
  # parser.done()

############################################################################################################
unless module.parent?
  @main()

