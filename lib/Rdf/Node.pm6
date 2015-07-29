use v6;
use Rdf;

package Rdf {

  class Node {

    has Int $!type;
    has Str $!value;
    has Str $!short-value;
    
    # Array of Rdf::Rdf-Tuple
    #
    has Array $tuples = [];

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

    #---------------------------------------------------------------------------
    #
    method set-value (
      Str $value where $value.chars > 0
    ) {
      $!value = $value;
    }

    #---------------------------------------------------------------------------
    #
    method set-short-value (
      Str $short-value where $short-value.chars > 0
    ) {
      $!short-value = $short-value;
    }

    #---------------------------------------------------------------------------
    # Saved tuples which are pointing to this node
    #
    method save-tuple ( $tuple where $tuple.isa('Rdf-tuple') ) {

      $tuples.push($tuple);
    }

    #---------------------------------------------------------------------------
    #
    method get-value ( --> Str ) { return $!value; }
    method get-short-value ( --> Str ) { return $!short-value; }
    multi method Str ( --> Str ) { return $!value; }
  }
}


