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
      $subject.save-tuple(self);

      $!predicate = $predicate;
      $predicate.save-tuple(self);

      $!object = $object;
      $object.save-tuple(self);
    }

    #---------------------------------------------------------------------------
    #
    method get-subject ( ) { return $!subject; }
    method get-predicate ( ) { return $!predicate; }
    method get-object ( ) { return $!object; }
  }

  #-----------------------------------------------------------------------------
  #
  module Tuple-Tools {

    #---------------------------------------------------------------------------
    # Create a 3-tuple of a subject - predicate - object relationship
    #
    sub tuple (
      $subject where $subject ~~ any(Str,Rdf::Rdf-tuple),
      Str $predicate,
      $object where $object ~~ any(Str,Rdf::Rdf-tuple)
      --> Rdf::Rdf-tuple
    ) is export {

      my Rdf::Node $s = $subject ~~ Rdf::Rdf-tuple
        ?? $subject.get-subject
        !! Rdf::Node-builder.create($subject);

      my Rdf::Node $p = Rdf::Node-builder.create($predicate);

      my Rdf::Node $o = $object ~~ Rdf::Rdf-tuple
        ?? $object.get-subject
        !! Rdf::Node-builder.create($object);

      return Rdf::Rdf-tuple.new( :subject($s), :predicate($p), :object($o));
    }
  }
}
