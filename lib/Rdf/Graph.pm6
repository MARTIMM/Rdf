use v6;
use Rdf;
use Rdf::Node;
use Rdf::IRI;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    # This objects IRI
    #
    has Rdf::IRI $.graph;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( :$graph ) {
      $!graph = $graph;
      self.set-type($Rdf::NODE-GRAPH);
    }
  }
}
