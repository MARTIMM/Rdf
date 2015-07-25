use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    # This objects IRI
    #
    has Str $.literal;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( Str :$literal ) {
      $!literal = $literal;
      self.set-type($Rdf::NODE-LITERAL);
    }
  }
}
