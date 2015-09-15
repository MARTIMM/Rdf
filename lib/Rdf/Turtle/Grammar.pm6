use v6;
use Rdf;
#use Grammar::Tracer;

package Rdf {


  #-----------------------------------------------------------------------------
  #
  grammar Turtle::Grammar {

    #---------------------------------------------------------------------------
    #
    rule RDF_1_0 { <statement>* }
    rule statement {
      <directive> '.' | <triples> '.' | <.white-space>
    }

    rule directive { <prefix-id> | <base-id> }

    # '@prefix' prefix-name ':' url .
    # '@prefix' ':' url .
    #
    rule prefix-id { '@prefix' <.white-space>* <prefix-name>? ':' <uri-ref> }

    # '@base' url .
    #
    rule base-id { '@base' <.white-space>* <uri-ref> }

    # subject-item predicate object .
    #
    rule triples {
      <.start-triple> <subject-item> <.seen-subject> <predicate-object-list>
    }
    
    token start-triple { <?> }
    token seen-subject { <?> }

    rule predicate-object-list {
      <predicate-item> <object-list>
      ( ';' <predicate-item> <object-list> )* ';'?
    }

    rule object-list { <object-item> ( ',' <object-item> )* }

    # White space detection is more simple because the perl6 grammar system
    # skips this automatically in rules. \n will take care of all kinds of
    # newline characters depending on operating system.
    # (token ws is already declared by perl!!)
    #
    rule white-space { <.comment> }
    token comment { '#' <-[\n]>* }

    token subject-item { ( <.resource> | <.blank-node> ) }

    # Turtle predicate 'a' is same as rdf:type. This also means that predicate
    # rdf must be declared as http://www.w3.org/1999/02/22-rdf-syntax-ns#
    # in Rdf.pm6.
    #
    token predicate-item {
      [ <.resource> <?before \s> ] |
      [ 'a' <?before \s> ]
    }

    token object-item { ( <.resource> | <.blank-node> | <.literal-text> ) }

    # '"' text '"'
    # '"""' long piece of text '"""'
    # '"' text '"' '@' language-code
    # '"""' long piece of text '"""' '@' language-code
    #
    # number '^^' data-type-iri
    # number '.' number '^^' data-type-iri
    # '"' text '"' '^^' data-type-iri
    #
    token literal-text {
      <double>          |
      <decimal>         |
      <integer>         |
      <boolean>         |
      <datatype-string> |
      <quoted-string> ( '@' <language> )?
    }

    token double {
      <[+-]>? [
        \d+ '.' \d* <.exponent> |
        '.' \d+ <.exponent> |
        \d+ <.exponent>
      ]
    }

    token datatype-string { <quoted-string> '^^' <resource> }
    token integer { <[+-]>? \d+ }

# Bug in the bnf rule 18 on page
# http://www.w3.org/TeamSubmission/turtle/#relativeURI
#    token decimal { <[+-]>? [ \d+ '.' \d* | '.' \d+ | \d+ ] }

    token decimal { <[+-]>? [ \d+ '.' \d* | '.' \d+ ] }
    token exponent { <[eE]> <[+-]>? \d+ }
    token boolean { 'true' | 'false' }

    # '_:' local-name
    #
    rule blank-node {
      <node-id> |
      '[]'      |
      [ '[' <.proc-blank-node> <predicate-object-list> ']' <.seen-blank-node> ] |
      <collection>
    }
    
    token proc-blank-node { <?> }
    token seen-blank-node { <?> }
    token node-id { '_:' <name> }

    rule collection { '(' <.proc-collection> <object-item>* ')' }
    token proc-collection { <?> }
#    rule collection { '(' <item-list>? ')' }
#    rule item-list { <object-item>+ }

    # '<' url '>'
    # prefix ':' local-name
    # prefix ':'
    # ':' local-name
    # ':'
    #
    token resource { <uri-ref> | <qname> }
    token uri-ref { '<' ~ '>' <relative-uri> }
    token qname { <prefix-name>? ':' <name>? }

    token language { <[a..z]>+ ( '-' <[a..z0..9]>+ )* }

    token name_start_char {
        <[a..z A..Z _]>
      | <[\x00c0..\x00d6]> | <[\x00d8..\x00f6]>
      | <[\x00f8..\x02ff]> | <[\x0370..\x037d]>
      | <[\x037f..\x1fff]> | <[\x200c..\x200d]>
      | <[\x2070..\x218f]> | <[\x2c00..\x2fef]>
      | <[\x3001..\xd7ff]> | <[\xf900..\xfdcf]>
      | <[\xfdf0..\xfffd]> | <[\x10000..\xeffff]>
    }

    token name-char {
        <.name_start_char> | <[0..9 -]>
      | "\x00B7" | <[\x0300..\x036F]>
      | <[\x203F..\x2040]>
    }

    token name { <.name_start_char> <.name-char>* }
    token prefix-name { <+ name_start_char - [_]> <.name-char>* }
    token relative-uri { <.u_character>* }
    token quoted-string { <.string> | <.long-string> }
    token string { '"' ~ '"' <.s_character>* }
    token long-string { '"""' ~ '"""' <.l_character>* }

    token character {
        '\u' <hex>**4
      | '\U ' <hex>*8
      | '\\'
      | <[\x20..\x5b]>
      | <[\x5d..\x10ffff]>
    }

    token e_character { <.character> | <[\t\n\r]> }
    token u_character { <+ character - [\x3e]> | '\>' }
    token s_character { <+ e_character - [\x22]> | '\"' }
    token l_character { <.e_character> | '\"' | \x9 | \xa | \xd }

    token hex { <[0..9 a..f A..F]> }
  }
}


