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
      self.set-value($blank-node);
      self.set-short-value($blank-node);
      self.set-type($Rdf::NODE-BLANK);
    }
  }
}
