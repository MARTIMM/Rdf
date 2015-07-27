use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Blank is Rdf::Node {

    # This objects blank node
    #
    has Str $.blank-node;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( :$blank-node ) {
      $!blank-node = $blank-node;
      self.set-type($Rdf::NODE-BLANK);
    }

    #---------------------------------------------------------------------------
    #
    multi method Str ( --> Str ) { return $!blank-node; }
  }
}
