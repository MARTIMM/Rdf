use v6;
use Rdf;
use Rdf::Node;
use Rdf::IRI;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Graph is Rdf::Node {

    # This objects IRI
    #
    has Rdf::IRI $.graph;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( :$graph ) {
      $!graph = $graph;
    }
  }
}
