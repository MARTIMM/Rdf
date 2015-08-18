# W3C RDF

## Description

Package to define a RDF api to set prefixes and 3-tuples directly from the
program. Later, code is added to read and write several formats such as RDF/XML
a comparable interface in Semi-xml and turtle. Also it should be possible to
store the data in some way like in a NoSQL database like MongoDB. Of course it
should be able to search through the data to make conclusions about the data.
That last thing would prove to be difficult, but we'll see.

## Todo

* Programming Api

  * Rdf.pm6

    Package with variables and a module with some exported subs

    [x] Pre defined prefixes
    [ ] Caching of network data
    Module
    [x] prefix()
    [x] get-prefix()
    [x] short-iri()
    [x] full-iri()

  * Rdf/Blank.pm6
  * Rdf/Graph.pm6
  * Rdf/IRI.pm6
  * Rdf/Literal.pm6
  * Rdf/Node-builder.pm6
  * Rdf/Node.pm6
  * Rdf/Rdf-tuple.pm6
  * Rdf/Turtle.pm6

  * Rdf/Turtle/Actions.pm6
  * Rdf/Turtle/Grammar.pm6


## Possible extentions

* XML
* Semi-xml
* JSON-LD

* Turtle

  [x] empty turtle document
  [x] comment on top level
  [x] @base
  [x] @prefix
  [x] 3-tuple or subject predicate and objects

* Connecting to Nepomuk and Tracker

## Changes

* 0.1.0 Start

