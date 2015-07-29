use v6;
use Rdf;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  grammar Turtle::Grammar {

    #---------------------------------------------------------------------------
    #
    rule TOP { <turtle-prefix>* <turtle-rule>* }
    
    rule turtle-prefix { '@prefix' <prefix-id>? ':' '<' ~ '>' <prefix-url> '.' }
    rule prefix-id { <.ident> }
    rule prefix-url { <-[>]>* }


    rule turtle-rule { <subject> <predicate> <object> '.' }
    rule subject { ( <iri> | <blank> ) }
    rule predicate { <iri> }
    rule object { ( <iri> | <blank> | <literal> ) }
    

    rule iri { ( <prefix-url> | ( <.ident> ':' <.ident> ) ) }


    rule blank { '_:' <.ident> }


    rule literal { ( <lit-text> | <lit-other> ) }

    rule lit-text { ( <short-text> | <long-text> ) ( '@' <.ident> ) }
    rule short-text { '"' ~ '"' <data-content> }
    rule long-text { '"""' ~ '"""' <data-content> }

    rule lit-other { ( <short-form> | <long-form> ) }
    rule short-form { \d+ }
    rule long-form { <short-text> '^^' <iri> }
  }
}
