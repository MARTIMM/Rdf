use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    # This objects IRI
    #
    has $.literal;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( :$graph ) {
      $!graph = $graph;
      self.set-type($Rdf::NODE-GRAPH);
    }
  }
}
