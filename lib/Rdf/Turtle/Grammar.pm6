use v6;
use Rdf;
#use Grammar::Tracer;

package Rdf {

  our $seen-eol = False;

  our $parse-subject-item;
  our $parse-predicate-item;
  our $parse-object-item;

  #-----------------------------------------------------------------------------
  #
  grammar Turtle::Grammar {

    #---------------------------------------------------------------------------
    #
    rule TOP { <statement>* }
    rule statement { (
          <directive> '.' { $Rdf::seen-eol = True; }
        | <triples> '.' { $Rdf::seen-eol = True; }
        | <white-space>
      )
    }

    rule directive { <prefix-id> | <base-id> }

    # '@prefix' prefix-name ':' url .
    # '@prefix' ':' url .
    #
    rule prefix-id {
      '@prefix' { $Rdf::seen-eol = False; }
      <white-space>* <prefix-name>? ':' <uri-ref>
    }

    # '@base' url .
    #
    rule base-id {
      '@base' { $Rdf::seen-eol = False; }
      <white-space>* <uri-ref>
    }

    # subject-item predicate object .
    #
    rule triples {
      <subject-item> { $Rdf::seen-eol = $parse-subject-item = False; }
      <predicateObjectList>
    }

    rule predicateObjectList {
      <verb> <objectList>
      ( ';' <verb> <objectList> )* ( ';' )?
    }

    rule objectList {
      <object-item> ( ',' <object-item> )* { $parse-object-item = False; }
    }

    rule verb { ( <predicate-item> | 'a' ) { $parse-predicate-item = False; } }

    # White space detection is more simple because the perl6 grammar system
    # skips this automatically in rules. \n will take care of all kinds of
    # newline characters depending on operating system.
    # (token ws is already declared by perl!!)
    #
    rule white-space { <comment> }
    rule comment { '#' <-[\n]>* }

    rule subject-item {
      { $parse-subject-item = True; }
      ( <resource> | <blank-node> )
    }
    rule predicate-item {
      { $parse-predicate-item = True; }
      <resource>
    }
    rule object-item {
      { $parse-object-item = True; }
      ( <resource> | <blank-node> | <literal> )
    }

    # '"' text '"'
    # '"""' long piece of text '"""'
    # '"' text '"' '@' language-code
    # '"""' long piece of text '"""' '@' language-code
    #
    # number '^^' data-type-iri
    # number '.' number '^^' data-type-iri
    # '"' text '"' '^^' data-type-iri
    #
    rule token {
        <quoted-string> ( '@' <language> )?
      | <datatype-string>
      | integer
      | double
      | decimal
      | boolean
    }

    token datatype-string { <quoted-string> '^^' <resource> }
    token integer { <[+-]>? \d+ }
    token double {
      <[+-]>? (
          \d+ '.' \d*
        | '.' \d+ <exponent>
        | \d+ <exponent>
      )
    }
    token exponent { <[eE]> <[+-]>? \d+ }
    token boolean { 'true' | 'false' }

    # '_:' local-name
    #
    rule blank-node {
        <node-id>
      | '[]'
      | '[' <predicateObjectList> ']'
      | <collection>
    }

    token node-id { '_:' <name> }

    rule collection { '(' <item-list>? ')' }
    rule item-list { <object-item>+ }

    # '<' url '>'
    # prefix ':' local-name
    # prefix ':'
    # ':'
    #
    token resource { ( <uri-ref> | <qname> ) }
    token uri-ref { '<' ~ '>' <relative-uri> }
    rule qname { <prefix-name>? ':' <name>? }
    token relative-uri { <u-character>* }

    token language { <[a..z]>+ ( '-' <[a..z0..9]>+ )* }

    token name-start-char {
        <[a..zA..Z]>
      | <[\x00c0..\x00d6]> | <[\x00d8..\x00f6]>
      | <[\x00f8..\x02ff]> | <[\x0370..\x037d]>
      | <[\x037f..\x1fff]> | <[\x200c..\x200d]>
      | <[\x2070..\x218f]> | <[\x2c00..\x2fef]>
      | <[\x3001..\xd7ff]> | <[\xf900..\xfdcf]>
      | <[\xfdf0..\xfffd]> | <[\x10000..\xeffff]>
    }

    token name-char {
        <name-start-char> | <[0..9\-\_]>
      | "\x00B7" | <[\x0300..\x036F]>
      | <[\x203F..\x2040]>
    }

    token name { (<name-start-char> | '_' ) <name-char>* }
    token prefix-name { <name-start-char> <name-char>* }

    rule quoted-string { <string> | <long-string> }
    token string { '"' ~ '"' <s-character> }
    token long-string { '"""' ~ '"""' <l-character> }

    token character {
        '\u' <hex>**4
      | '\U ' <hex>*8
      | '\\'
      | "\x20" | "\x21"                 # \x22 (") not for s-character
      | <[\x23..\x3d]>
      | <[\x3f..\x5b]>                  # \x3e (>) not for u-character
      | <[\x5d..\x10ffff]>
    }

    token e-character { <character> | <[\"\>\t\n]> }
    token u-character { <character> | '"' | '\>' }     # '>' must be escaped
    token s-character { <character> | '>' | '\"' }     # '"' must be escaped
    token l-character { <echaracter> | '\"' }

    token hex { <[0..9a..fA..F]> }
  }
}


