use v6;
use Rdf;
use Rdf::Node;
use Rdf::Node-builder;

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

    #---------------------------------------------------------------------------
    #
    method get-subject ( ) { return $!subject; }
    method get-predicate ( ) { return $!predicate; }
    method get-object ( ) { return $!object; }

#    method get-s-subject ( ) { return short-iri($!subject); }
#    method get-s-predicate ( ) { return short-iri($!predicate); }
#    method get-s-object ( ) { return short-iri($!object); }
  }

  #-----------------------------------------------------------------------------
  #
  module Tuple-Tools {

    #---------------------------------------------------------------------------
    #
    multi sub tuple (
      Str $subject,
      Str $predicate,
      Str $object
      --> Rdf::Rdf-tuple
    ) is export {
      return Rdf::Rdf-tuple.new(
        :subject(Rdf::Node-builder.create($subject)),
        :predicate(Rdf::Node-builder.create($predicate)),
        :object(Rdf::Node-builder.create($object))
      );
    }

    #---------------------------------------------------------------------------
    #
    multi sub tuple (
      Rdf::Rdf-tuple $tuple,
      Str $predicate,
      Str $object
      --> Rdf::Rdf-tuple
    ) is export {
      return Rdf::Rdf-tuple.new(
        :subject($tuple.get-subject),
        :predicate(Rdf::Node-builder.create($predicate)),
        :object(Rdf::Node-builder.create($object))
      );
    }
  }
}
