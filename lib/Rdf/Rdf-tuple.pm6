use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Rdf-tuple {

    has Rdf::Node $.subject;
    has Rdf::Node $.predicate;
    has Rdf::Node $.object;

    #---------------------------------------------------------------------------
    #
    submethod BUILD (
      :$subject where $subject.get-type ~~ any($Rdf::NODE-IRI,$Rdf::NODE-BLANK),
      :$predicate where $predicate.get-type eq $Rdf::NODE-IRI,
      :$object wher $object.get-type ~~ any($Rdf::NODE-Literal,$Rdf::NODE-IRI,$Rdf::NODE-BLANK)
    ) {
      $!subject = $subject;
      $!predicate = $predicate;
      $!object = $object;
    }
  }
}
