

- [ReMarkably](#remarkably)
	- [What is it for?](#what-is-it-for)
	- [Usage](#usage)
	- [Writing Your Own Extension](#writing-your-own-extension)
	- [A Note on `remarkable` Version and How to Install It](#a-note-on-remarkable-version-and-how-to-install-it)

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
often written with extensibility in mind—as in programming languages, many language designers are caught in
a frame of thinking that makes them want to create *the* best language with *the* best syntax.

> LISPers were never interested in syntax, because, hey, what can surpass a homoiconic language (yes, they
> really call it that) with gazillions of brackets, right?
>
> In Python, extending syntax is seen as something dangerous,
> and given the very traditional Lex-YACC-Bison-ish tooling of the parser, you'd have to make changes in like
> four or six files to add a trivial tidbit to the language, and then re-compile the entire
> thing, which makes development feel like you're back to mainframes and please come back tomorrow to pick up
> your printouts. Assuming you took that month-long upfront training class so you sorta know-what'cherdoing.
> Sort of. It's really difficult.
>
> ReStructuredText (also once known as ReStructuredTextNG) used to be a strong contender to MarkDown, but
> IMHO it lost out because it's just too complicated—too many rules, and to setup a parser and *just parse*
> means jumping through too many loops (at least when i gave up on it five years ago). Is it extensible?
> Don't try at home.
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
ReMarkable  = require 'remarkable'

enable      = 'full'
settings    =
  html:           yes,            # Enable HTML tags in source
  xhtmlOut:       no,             # Use '/' to close single tags (<br />)
  breaks:         no,             # Convert '\n' in paragraphs into <br>
  langPrefix:     'language-',    # CSS language prefix for fenced blocks
  linkify:        yes,            # Autoconvert URL-like text to links
  typographer:    yes,
  quotes:         '“”‘’'

RM          = new Remarkable enable, settings
# same as `remarkable_parser.use extension.extend`:
RMY.extend RM, RMY.examples.emphasis
RMY.extend RM, RMY.examples.video

log ast     = MD.parse  source
log html    = MD.render source
log RMY.examples.video.about
```

## Writing Your Own Extension

Paste and copy one of the existing sources. A ReMarkably extension must be an object with up to four
public attributes, namely `about`, `parse`, `render`, and `extend`. `about` is optional and should
contain a short text explaining syntax, rendering, and possible options; `parse` is the parsing function;
optionally, `render` contains a rendering function (in case you do not use one of the existing renderers),
and `extend` contains the code expected by the `use` method of a `remarkable` parser instance.


## A Note on `remarkable` Version and How to Install It

As of now (2014-11-09), the `remarkable` version on npmjs.org does *not* work with ReMarkably; instead,
you'll have to clone the remarkly repo on GitHub with

```bash
cd node_modules
git clone https://github.com/jonschlinkert/remarkable.git
```

I guess this will not be an issue for much longer as the necessary code changes have been integrated into
`remarkable` very swiftly.





