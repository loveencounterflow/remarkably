

- [ReMarkably](#remarkably)
	- [What is it for?](#what-is-it-for)

> **Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*


# ReMarkably

ReMarkably is a collection of MarkDown syntax extension to be used with [the truly remarkable Remarkable
MarkDown parser](https://github.com/jonschlinkert/remarkable).

## What is it for?

Finally, it's possible to easily extend your all-time favorite liteweight markup language, MarkDown.

Heretofore, it has been difficult to extend the syntax of markup languages because their parsers were not
often written with extensibility in mind—as in programming languages, many language designers are caught in
a frame of thinking that makes them want to create *the* best language with *the* best syntax.

> LISPers were never interested in syntax, because, hey, what can surpass a homoiconic language (yes, they
> call it that) with gazillions of brackets, right?
>
> In Python, extening syntax is seen as something dangerous,
> and given the very traditional Lex-YACC-Bison-ish tooling of the parser, you'd have to walk through like
> four or six files and make changes to add a trivial tidbit to the language, and then re-compile the entire
> thing, which makes development feel like you're back to mainframes and please come back tomorrow to pick up
> your printouts. Assuming a month-long upfront training phase so you sorta know-what'cherdoing. Sort of.
>
> ReStructuredText (also once known as ReStructuredTextNG) used to be a strong contender to MarkDown, but
> IMHO it lost out because it's just too complicated—too many rules. Is it extensible? Don't try at home.
>
> As Douglas [Crockford convincingly demonstrates in his 2013 MLOCJS *Syntaxation*
> talk](https://www.youtube.com/watch?v=9e_oEE72d3U), those times should be over. Languages should be
> extensible, and given the right tools, parsing can be much easier than it used to be.

Sadly, at the time of this writing (2014-11-09), there is very little documentation on how to extend
`remarkable`, so the foremost purpose of ReMarkably is filling that gap. Anyone interested can fork the
repo, develop their own extensions, and issue pull requests to make more syntax extensions available to
the masses.

