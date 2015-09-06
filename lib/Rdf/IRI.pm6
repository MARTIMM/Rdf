use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class IRI is Rdf::Node {

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( Str :$iri where ?$iri ) {
      self.set-value($iri);
      self.set-short-value(short-iri($iri));
      self.set-type($Rdf::NODE-IRI);
    }
  }
}

