
############################################################################################################
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
@examples                 = require './examples'


# justify ∆<;
# size ∆2(...)
# brackets {}, [], [] (can't use <>, but <<>>, 《》 possible); should be turned into appropriate
#   punctuation, bylines, or boxes

############################################################################################################

@extend = ( remarkable_parser, extension ) -> remarkable_parser.use extension.extend



#===========================================================================================================
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