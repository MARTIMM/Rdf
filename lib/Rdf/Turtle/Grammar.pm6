use v6;
use Rdf;
use Grammar::Tracer;

package Rdf {

  our $seen-eol = False;

  our $parse-subject;
  our $parse-predicate;
  our $parse-object;

  #-----------------------------------------------------------------------------
  #
  grammar Turtle::Grammar {
  
    #---------------------------------------------------------------------------
    #
    rule TOP { <statement>* }
    rule statement {
      ( <directive> '.' | <triples> '.' | <comment> ) { $Rdf::seen-eol = True; }
    }
    rule directive { <prefix-id> | <base> }
    
    # '@prefix' prefix-name ':' url .
    # '@prefix' ':' url .
    #
    rule prefix-id {
      
      '@prefix' { $Rdf::seen-eol = False }
      <comment>* <prefix-name>? ':' <uri-ref>
    }

    # '@base' url .
    #
    rule base {
      
      '@base' { $Rdf::seen-eol = False }
      <comment>* <uri-ref>
    }
    
    # subject predicate object .
    #
    rule triples {
      <subject> { $Rdf::seen-eol = $parse-subject = False; }
      <predicateObjectList>
    }

    rule predicateObjectList {
      <verb> <objectList>
      ( ';' <verb> <objectList> )* ( ';' )?
    }
    
    rule objectList {
      <object> ( ',' <object> )* { $parse-object = False; }
    }

    rule verb { ( <predicate> | 'a' ) { $parse-predicate = False; } }
    
    rule comment { '#' <-[\l\n]>* }

    rule subject { { $parse-subject = True; } ( <resource> | <blank> ) }
    rule predicate { { $parse-predicate = True; } <resource> }
    rule object { { $parse-object = True; } ( <resource> | <blank> | <literal> ) }

    # '"' text '"'
    # '"""' long piece of text '"""'
    # '"' text '"' '@' language-code
    # '"""' long piece of text '"""' '@' language-code
    #
    # number '^^' data-type-iri
    # number '.' number '^^' data-type-iri
    # '"' text '"' '^^' data-type-iri
    #
    rule literal {
      <quoted-string>
      ( '@' <language> )?
      | <datatype-string>
      | integer
      | double
      | decimal
      | boolean
    }
    
    rule datatype-string { <quoted-string> '^^' <resource> }
    rule integer { <[+-]>? \d+ }
    rule double {
      <[+-]>? (
        \d+ '.' \d*
        | '.' \d+ <exponent>
        | \d+ <exponent>
      )
    }
    rule exponent { <[eE]> <[+-]>? \d+ }
    rule boolean { 'true' | 'false' }
    
    # '_:' local-name
    #
    rule blank {
      <node-id>
      | '[]'
      | '[' <predicateObjectList> ']'
      | <collection>
    }
    
    rule item-list { <object>+ }
    rule collection { '(' <item-list>? ')' }
    
    # '<' url '>'
    # prefix ':' local-name
    # prefix ':'
    # ':'
    #
    rule resource { ( <uri-ref> | <qname>? ) }

    rule node-id { '_:' <name> }
    rule qname { <prefix-name>? ':' <name>? }
    rule uri-ref { '<' ~ '>' <relative-uri> }
    
    rule language { <[a..z]>+ ( '-' <[a..z0..9]>+ )* }
    rule name-start-char {
      <[A..Za..z]>
      | <[\x00c0..\x00d6]> | <[\x00d8..\x00f6]>
      | <[\x00f8..\x02ff]> | <[\x0370..\x037d]>
      | <[\x037f..\x1fff]> | <[\x200c..\x200d]>
      | <[\x2070..\x218f]> | <[\x2c00..\x2fef]>
      | <[\x3001..\xd7ff]> | <[\xf900..\xfdcf]>
      | <[\xfdf0..\xfffd]> | <[\x10000..\xeffff]>
    }
    
    rule name-char {
      <name-start-char> | <[0..9\-\_]>
      | \x00B7 | <[\x0300..\x036F]>
      | <[\x203F..\x2040]>
    }

    rule name { (<name-start-char> | '_' ) <name-char>* }
    rule prefix-name { <name-start-char> <name-char>* }
    
    rule relative-uri { <u-character>* }
    rule quoted-string { <string> | <long-string> }
    rule string { '"' ~ '"' <s-character> }
    rule long-string { '"""' ~ '"""' <l-character> }
    
    rule character {
      '\u' <hex>**4
      | '\U ' <hex>*8
      | '\\'
      | \x20 | \x21                     # \x22 (") not for s-character
      | <[\x23..\x3d]>
      | <[\x3f..\x5b]>                  # \x3e (>) not for u-character
      | <[\x5d..\x10ffff]>
    }

    rule e-character { <character> | <[\"\>\t\n\r]> }
    rule u-character { <character>  }
  }
}


