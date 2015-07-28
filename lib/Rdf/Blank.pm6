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
    submethod BUILD ( :$blank-node is copy ) {
      $blank-node ~~ s/^ '_:' //;
      self.set-value($blank-node);
      self.set-type($Rdf::NODE-BLANK);
    }

    #---------------------------------------------------------------------------
    #
    multi method Str ( --> Str ) { return "_:{self.get-value}"; }
  }
}
