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
#  my Rdf::Triple @Triples;
  my @Triples;

  #-----------------------------------------------------------------------------
  #
  class Triple {

    has Rdf::Node $.subject;
    has Rdf::Node $.predicate;
    has Rdf::Node $.object;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( :$subject, :$predicate, :$object ) {
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
  module Triple-Tools {

    #---------------------------------------------------------------------------
    # Create a 3-tuple of a subject - predicate - object relationship. For each
    # of the arguments this can be a string or a tuple. When it is a tuple, take
    # the subject from the tuple and use it as a string for the subject,
    # predicate or object.
    #
    sub tuple (
      $subject where $subject ~~ any( Str, Rdf::Triple),
      Str $predicate is copy where $subject ~~ any( Str, Rdf::Triple),
      $object where $object ~~ any( Str, Rdf::Triple)
      --> Rdf::Triple
    ) is export {
#say '=' x 80;
#say "TT: $subject $predicate $object";
      # Get subject
      #
      my Rdf::Node $s = $subject ~~ Rdf::Triple
        ?? $subject.get-subject
        !! create-node($subject);

      die "Node for $subject is not created" unless $s.defined;

      # Get predicate
      #
      my Rdf::Node $p = create-node($predicate);
      die "Node for $predicate is not created" unless $p.defined;

      # Get object
      #
      my Rdf::Node $o = $object ~~ Rdf::Triple
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

#say "TT: ", $s.get-value, ', ', $p.get-value, ', ', $o.get-value;
      # Create and return new tuple
      #
      return Rdf::Triple.new( :subject($s), :predicate($p), :object($o));
    }

    #---------------------------------------------------------------------------
    # Create literal node if fully specified string is given
    #
    sub create-node (
      Str $iri-string is copy where $iri-string.chars > 0
      --> Rdf::Node
    ) {

      my Rdf::Node $node;

      if $iri-string ~~ m/^ '_:' | '[]' / {
        $node = Rdf::Blank.new(:blank($iri-string));
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
      @Triples = ();
    }

    #---------------------------------------------------------------------------
    #
    sub get-tuple-count ( --> Int ) is export {
      return @Triples.elems;
    }

    #---------------------------------------------------------------------------
    #
    sub get-tuple-from-index (
      $index where (0 <= $index < @Triples.elems)
      --> Rdf::Triple
    ) is export {
      return @Triples[$index];
    }

    #---------------------------------------------------------------------------
    #
    sub add-tuple ( Str $subject, Str $predicate, Str $object ) is export {
      my Rdf::Triple $t = tuple( $subject, $predicate, $object);
      @Triples.push($t);
    }
  }
}
