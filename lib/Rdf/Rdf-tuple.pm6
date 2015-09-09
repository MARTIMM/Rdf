use v6;
use Rdf;
use Rdf::Node;
use Rdf::Node-builder;

package Rdf {

  #-----------------------------------------------------------------------------
  # Triples or 3-tuples
  #
#  my Rdf::Rdf-tuple @rdf-tuples;
  my @rdf-tuples;

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
      Str $predicate is copy where $subject ~~ any(Str,Rdf::Rdf-tuple),
      $object where $object ~~ any(Str,Rdf::Rdf-tuple)
      --> Rdf::Rdf-tuple
    ) is export {

      my Rdf::Node $s = $subject ~~ Rdf::Rdf-tuple
        ?? $subject.get-subject
        !! Rdf::Node-builder.create($subject);
#say "TT: Subject: $s";

      die "Node for $subject is not created" unless $s.defined;

      # Turtle predicate 'a' is same as rdf:type. This also means that predicate
      # rdf must be declared as http://www.w3.org/1999/02/22-rdf-syntax-ns#
      # in Rdf.pm6.
      #
      $predicate = 'rdf:type' if $predicate eq 'a';
      my Rdf::Node $p = Rdf::Node-builder.create($predicate);
      die "Node for $predicate is not created" unless $p.defined;

      my Rdf::Node $o = $object ~~ Rdf::Rdf-tuple
        ?? $object.get-subject
        !! Rdf::Node-builder.create($object);
      die "Node for $object is not created" unless $o.defined;

      # Test for proper classes for the 3 items.
      #
say "Subject test: ", $subject.isa('IRI') or $subject.isa('Blank');
say "Predicate test: ", $predicate.isa('IRI');
say "Subject test: ", $object.isa('IRI') or $object.isa('Blank')
        or $object('Literal');
#      if !$subject.isa('IRI'|'Blank') {
      
#      }

      return Rdf::Rdf-tuple.new( :subject($s), :predicate($p), :object($o));
    }

    #---------------------------------------------------------------------------
    #
    sub init-tuples ( ) is export {
      @rdf-tuples = ();
    }

    #---------------------------------------------------------------------------
    #
    sub get-tuple-count ( --> Int ) is export {
      return @rdf-tuples.elems;
    }

    #---------------------------------------------------------------------------
    #
    sub get-tuple-from-index (
      $index where (0 <= $index < @rdf-tuples.elems)
      --> Rdf::Rdf-tuple
    ) is export {
      return @rdf-tuples[$index];
    }

    #---------------------------------------------------------------------------
    #
    sub add-tuple ( Str $subject, Str $predicate, Str $object ) is export {
      my Rdf::Rdf-tuple $t = tuple( $subject, $predicate, $object);
      @rdf-tuples.push($t);
    }
  }
}
