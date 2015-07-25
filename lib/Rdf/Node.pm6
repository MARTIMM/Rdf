use v6;
use Rdf;

package Rdf {

  class Node {

    has Int $!type;

    #---------------------------------------------------------------------------
    #
    method get-type ( --> Int ) {
      return $!type;
    }

    #---------------------------------------------------------------------------
    #
    method set-type (
      Int $type where $type ~~ any(
        $Rdf::NODE-IRI, $Rdf::NODE-BLANK, $Rdf::NODE-LITERAL, $Rdf::NODE-GRAPH
      )
    ) {
      $!type = $type;
    }
  }
}


