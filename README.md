

- [ReMarkably](#remarkably)
	- [What is it for?](#what-is-it-for)
	- [Usage](#usage)
	- [Writing Your Own Extension](#writing-your-own-extension)
	- [`remarkable` Compatibility](#remarkable-compatibility)

> **Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*


# ReMarkably

ReMarkably is a collection of MarkDown syntax extension to be used with [the truly remarkable Remarkable
MarkDown parser](https://github.com/jonschlinkert/remarkable).

Install with

```bash
npm install --save remarkably
```

## What is it for?

Finally, it's possible to easily extend your all-time favorite liteweight markup language, MarkDown.

Heretofore, it has been difficult to extend the syntax of markup languages because their parsers were not
often written with extensibility in mind—as in programming languages, many markup designers are caught in
a frame of thinking that makes them want to create *the* best language with *the* best syntax, the *final*
one to rule them all.

> LISPers were never interested in syntax, because, hey, what can surpass a homoiconic language (yes, they
> really call it that) with gazillions of brackets, right?
>
> ReStructuredText (also once known as ReStructuredTextNG) used to be a strong contender to MarkDown, but
> IMHO it lost out because it's just too complicated—too many rules, and to setup a parser and *just parse*
> means jumping through too many Java-Enterprisy hoops (at least when i last checked five years ago). Is it
> extensible? Don't try at home.
>
> In the Python community, extending syntax is seen as something dangerous, as an activity that can't be left to users
> but must be firmely policed by an inner circle of senior contributors. Given
> the fairly traditional Lex-YACC-Bison-ish tooling of the parser, that's even true because you'd have to
> make changes in like
> four or six files to add a trivial tidbit to the language, and then re-compile the entire
> thing, which makes development feel like you're back to mainframes and please come back tomorrow to pick up
> your printouts. Assuming you took that month-long upfront training class so you sorta know-what'cherdoing.
> Sort of. It's really difficult. And, having done that, anyone interested in your extension must download
> the entire source tree and compile that themselves, or else you must provide binary packages. It's not
> least this factor that has caused a lot of digital rot in the Python world, because compiling C sources
> tends to be much more fragile than relying on an 'interpreted' (i.e. low-level-compilation-free) idiom.
> In order to implement the tiniest of changes, you have to submit to a month-long or year-long period of
> intense scrutiny and deliberation, and your proposal will likely get downvoted.

> Such strict procedures are
> necessary to uphold the quality of monolithic languages. After all, uncounted numbers of users will be confronted
> with your changes, and any addition to the language will likely be kept indefinitely because even correcting
> a mistake may break backward compatibility. JavaScript programmers know this very well: they have to live
> with lots of 'original sins' because their language was born under a very swiftly wandering star, and
> there was no time to correct oversights. Now those flaws are baked into the language, and any change for the
> better in JS core could potentially break many millions of websites.
>
> As Douglas [Crockford convincingly demonstrates in his 2013 MLOCJS *Syntaxation*
> talk](https://www.youtube.com/watch?v=9e_oEE72d3U), those times should be over. Languages should be
> extensible, and given the right tools, parsing can be much easier than it used to be.

Sadly, as of this writing (2014-11-09), there is very little documentation on how to extend `remarkable`, so
the foremost purpose of ReMarkably is filling that gap. Anyone interested can fork the repo, develop their
own extensions, and issue pull requests to make more syntax extensions available to the masses.

## Usage

It's quite simple (using CoffeeScript here):

```coffee
log         = console.log
RMY         = require 'remarkably'

enable      = 'full'
settings    =
  html:           yes,            # Enable HTML tags in source
  xhtmlOut:       no,             # Use '/' to close single tags (<br />)
  breaks:         no,             # Convert '\n' in paragraphs into <br>
  langPrefix:     'language-',    # CSS language prefix for fenced blocks
  linkify:        yes,            # Autoconvert URL-like text to links
  typographer:    yes,
  quotes:         '“”‘’'

RM                    = new RMY.ReMarkable enable, settings
RMY.use RM, video     = RMY.get.examples.video()
RMY.use RM, emphasis  = RMY.get.examples.emphasis()
RMY.use RM, emphasis2 = RMY.get.examples.emphasis2()
RMY.use RM, braces    = RMY.get.examples.brackets opener: '{',  closer: '}', arity: 2, name: 'braces'
RMY.use RM, angles    = RMY.get.examples.brackets opener: '<',  closer: '>', arity: 2, name: 'angles'
RMY.use RM, brackets  = RMY.get.examples.brackets opener: '[',  closer: ']', arity: 3, name: 'brackets-3'
RMY.use RM, smh       = RMY.get.examples.brackets opener: '《',  closer: '》', arity: 1, name: 'book-title'
source        = """
  =This= ==is== ===very=== _awesome_(c): %[example movie](http://example.com)
  *A* **B** ***C*** ****D****

  Here are
  * <<double pointy brackets>>,
  * {{double braces}},
  * [[[triple square brackets]]],
  * 也可以用 《中文書名号》 。
  """.trim()
log RM.render source

```

You can run the above with

```bash
remarkably/build && node remarkably/lib/main.js
```

which should output
```html
<p><i>This</i> <b>is</b> <b><i>very</i></b> <em>awesome</em>©: <video href='http://example.com'>example movie</video>
<em>A</em> <strong>B</strong> <strong><em>C</em></strong> ****D****</p>
<p>Here are</p>
<ul>
<li><span class='angles'>double pointy brackets</span>,</li>
<li><span class='braces'>double braces</span>,</li>
<li><span class='brackets-3'>triple square brackets</span>,</li>
<li>也可以用 <span class='book-title'>中文書名号</span> 。</li>
</ul>
```

## Writing Your Own Extension

Paste and copy one of the existing sources. A dynamic extension (one that accepts parameters) should return
an object with a `get` method. I'm in the middle of developing this, so details may change without notice;
you probably want to copy from the avaible sources.

Here is an example for a dynamic extension that accepts an opening and a closing bracket character,
an 'arity' (number of repetitions), and a rule name, and turns those into a rule to render
`markup like [[[this]]]` as `<span class='yournamehere'>this</span>`:

```coffee

#===========================================================================================================
@get = ( settings ) ->

  #---------------------------------------------------------------------------------------------------------
  rule                = {}
  rule._opener        = settings?[ 'opener'  ] ? '<'
  rule._closer        = settings?[ 'closer'  ] ? '>'
  rule.terminators    = rule._opener
  rule._arity         = settings?[ 'arity'   ] ? 2
  rule._class_name    = settings?[ 'name' ] ? 'angles'
  rule.name           = 'REMARKABLY/examples/' + rule._class_name

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
    { src, pos, }       = state
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
    return "<span class='#{rule._class_name}'>#{content}</span>"

  #---------------------------------------------------------------------------------------------------------
  rule.extend = ( self ) ->
    self.inline.ruler.before self.inline.ruler[ 'rules' ][ 0 ][ 'name' ], rule.name, rule.parse
    self.renderer.rules[ rule.name ] = rule.render
    return null

  #---------------------------------------------------------------------------------------------------------
  return rule
```

## `remarkable` Compatibility

ReMarkably is comaptible with `remarkable@1.4.0`.




