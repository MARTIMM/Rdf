use v6;
use Rdf;
use Rdf::Node;
#use Rdf::Node-builder;
use Rdf::IRI;
use Rdf::Graph;
use Rdf::Blank;
use Rdf::Literal;


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
      :$subject,
      :$predicate,
      :$object
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
    # Create a 3-tuple of a subject - predicate - object relationship. For each
    # of the arguments this can be a string or a tuple. When it is a tuple, take
    # the subject from the tuple and use it as a string for the subject,
    # predicate or object.
    #
    sub tuple (
      $subject where $subject ~~ any( Str, Rdf::Rdf-tuple),
      Str $predicate is copy where $subject ~~ any( Str, Rdf::Rdf-tuple),
      $object where $object ~~ any( Str, Rdf::Rdf-tuple)
      --> Rdf::Rdf-tuple
    ) is export {

      # Get subject
      #
      my Rdf::Node $s = $subject ~~ Rdf::Rdf-tuple
        ?? $subject.get-subject
        !! create-node($subject);

      die "Node for $subject is not created" unless $s.defined;

      # Get predicate
      #
      my Rdf::Node $p = create-node($predicate);
      die "Node for $predicate is not created" unless $p.defined;

      # Get object
      #
      my Rdf::Node $o = $object ~~ Rdf::Rdf-tuple
        ?? $object.get-subject
        !! create-node($object);
      die "Node for $object is not created" unless $o.defined;

      # Test for proper classes for the 3 items.
      #
      unless $s ~~ any(Rdf::IRI|Rdf::Blank)
         and $p ~~ any(Rdf::IRI)
         and $o ~~ any(Rdf::IRI|Rdf::Blank|Rdf::Literal) {

        note "Tuple not filled according to rdf rules";
      }

      # Create and return new tuple
      #
      return Rdf::Rdf-tuple.new( :subject($s), :predicate($p), :object($o));
    }

    # Create literal node if fully specified string is given
    #
    sub create-node (
      Str $iri-string is copy where $iri-string.chars > 0
      --> Rdf::Node
    ) {

      my Rdf::Node $node;

      if $iri-string ~~ m/^ '_:' \w+/ {
        $node = Rdf::Blank.new(:blank-node($iri-string));
      }

      # Check if iri is a full iri..
      #
      elsif $iri-string ~~ m/^ '<' /
         or $iri-string ~~ m/ ':' /
         or $iri-string ~~ m:s/^ 'a' $/ {
        $node = Rdf::IRI.new(:iri($iri-string));
      }

      # The rest must be a literal
      #
      else {
        $node = Rdf::Literal.new(:literal($iri-string));
      }

      return $node;
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
