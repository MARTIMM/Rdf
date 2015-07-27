use v6;
use Rdf;
use Rdf::IRI;
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
      :$object where $object.get-type ~~ any($Rdf::NODE-Literal,$Rdf::NODE-IRI,$Rdf::NODE-BLANK)
    ) {
      $!subject = $subject;
      $!predicate = $predicate;
      $!object = $object;
    }
  }

  module Tuple-Tools {
    sub tuple (
      Rdf::Node $subject,
      Rdf::Node $predicate,
      Rdf::Node $object
      --> Rdf::Tuple
    ) is export {
      return Rdf::Tuple.new(
        Rdf::IRI.check-iri($subject),
        Rdf::IRI.check-iri($predicate),
        Rdf::IRI.check-iri($object)
      );
    } 
  }
}
