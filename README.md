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

  * [x] Pre defined prefixes
  * [ ] Caching of network data 
  
  Module
  * [x] prefix()
  * [x] get-prefix()
  * [x] short-iri()
  * [x] full-iri()

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

### Sources

* XML
* Semi-xml
* JSON-LD
* Turtle
  [x] Grammar
  [ ] Store


### Storage

* MongoDB


### Search

* 


### Other programs and environments

* Connecting to Virtuoso, Nepomuk and Tracker



## Changes
* 0.3.3
  * Tests of nested blank nodes
* 0.3.2
  * Grammar rdf 1.0 ok
  * Rename of modules
  * bugfixes
  * more tests

* 0.3.1
  * Grammar modifications. Remove verb and brought rules into <predicate-item>

* 0.3.0
  * Turtle grammar installed. Works ok on turtle file from
    http://www.w3.org/1999/02/22-rdf-syntax-ns#
  * Problems are found xcaused by perl6. E.g. the line
    ```token prefix-name { <+ name-start-char - [_]> <name-char>* }```
    had to be rewritten because the id name-start-char was accidently recognized
    as 3 subrules with substraction operators in between.

* 0.2.0
  * Caching of sources in prefix rules

* 0.1.0 Start

