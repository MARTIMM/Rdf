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
    rule directive { <turtle-base> | <turtle-prefix> }
    
    # '@base' url .
    #
    rule turtle-base {
      
      '@base' { $Rdf::seen-eol = False }
      '<' ~ '>' <relative-uri>
    }
    
    # '@prefix' prefix-name ':' url .
    # '@prefix' ':' url .
    #
    rule turtle-prefix {
      
      '@prefix' { $Rdf::seen-eol = False } <prefix-id>? ':'
      <uri-ref>
    }
    

    rule prefix-id { <.ident> }
    rule relative-uri { <-[>]>* }

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
    
    # '<' url '>'
    # prefix ':' local-name
    # prefix ':'
    # ':'
    #
    rule uri-ref { '<' ~ '>' <relative-uri> }
    rule resource { ( <uri-ref> | <.ident>? ':' <.ident>? ) }

    # '_:' local-name
    #
    rule blank { '_:' <.ident> }

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
      ( '@' <language-string> )?
      | <datatype-string>
      | integer
      | double
      | decimal
      | boolean
    }
    
    rule datatype-string { <quoted-string> '^^' <resource> }
    rule integer { <[+-]>? \d+ }
    rule double { <[+-]>? ( \d+ '.' \d* | '.' \d+ | \d+ ) }
#    rule exponent 
  }
}



=finish
    rule literal { ( <lit-text> | <lit-other> ) }

    rule lit-text { ( <short-text> | <long-text> ) ( '@' <.ident> ) }
    rule short-text { '"' ~ '"' <data-content> }
    rule long-text { '"""' ~ '"""' <data-content> }
    rule data-content { <-["]>* }

    rule lit-other { ( <long-form> | <short-form> ) }
    rule short-form { <[+-]>? \d+ ( '.' \d+ )? ( 'e' \d+ )? }
    rule long-form { <short-text> '^^' <resource> }
