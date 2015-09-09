use v6;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Blank is Rdf::Node {

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( :$blank-node is copy ) {
      self.set-value($blank-node);
      self.set-short-value($blank-node);
    }
  }
}
