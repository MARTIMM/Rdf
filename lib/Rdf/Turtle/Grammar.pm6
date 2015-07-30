use v6;
use Rdf;
#use Grammar::Tracer;

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
    rule TOP { ( <turtle-base> | <turtle-prefix> | <turtle-rule> )* }

    rule turtle-base {
      
      '@base' { $Rdf::seen-eol = False }
      '<' ~ '>' <prefix-url>
      '.' { $Rdf::seen-eol = True; }
    }
    

    rule turtle-prefix {
      
      '@prefix' { $Rdf::seen-eol = False } <prefix-id>? ':'
      '<' ~ '>' <prefix-url>
      '.' { $Rdf::seen-eol = True; }
    }

    rule prefix-id { <.ident> }
    rule prefix-url { <-[>]>* }


    rule turtle-rule {
      <subject> { $Rdf::seen-eol = $parse-subject = False; }
      <predicate> { $parse-predicate = False; }
      <object> { $parse-object = False; }
      '.' { $Rdf::seen-eol = True; }
    }

    rule subject { { $parse-subject = True; } ( <iri> | <blank> ) }
    rule predicate { { $parse-predicate = True; } <iri> }
    rule object { { $parse-object = True; } ( <iri> | <blank> | <literal> ) }
    

    rule iri { (
        '<' ~ '>' <prefix-url> |
        <.ident>? ':' <.ident> |
        <.ident>
      )
    }


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
