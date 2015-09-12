use v6;
#use Rdf;
use Rdf::Node;
use Rdf::IRI;
use Rdf::Graph;
use Rdf::Blank;
use Rdf::Literal;


package Rdf {

  #-----------------------------------------------------------------------------
  # Triples or 3-tuples of Rdf::Triple
  #
  my Array $triples;

  #-----------------------------------------------------------------------------
  #
  class Triple {

    has Rdf::Node $.subject;
    has Rdf::Node $.predicate;
    has Rdf::Node $.object;
    has Int $!triples-idx;

    #---------------------------------------------------------------------------
    # Create a 3-tuple of a subject - predicate - object relationship. For each
    # of the arguments this can be a string or a tuple. When it is a tuple, take
    # the subject from the tuple and use it as a string for the subject,
    # predicate or object.
    #---------------------------------------------------------------------------
    # Empty triple to get to the methods.
    #
    multi submethod BUILD ( ) { }

    #---------------------------------------------------------------------------
    # Make triples based on strings
    #
    multi submethod BUILD (
      Str :$subject = '',
      Str :$predicate = '',
      Str :$object = ''
    ) {

      if ?$subject and ?$predicate and ?$object {
say '=' x 80;
say "TT: $subject $predicate $object";

        # Get subject
        #
        my Rdf::Node $s = self.create-node($subject);
        die "Node for $subject is not created" unless $s.defined;

        # Get predicate
        #
        my Rdf::Node $p = self.create-node($predicate);
        die "Node for $predicate is not created" unless $p.defined;

        # Get object
        #
        my Rdf::Node $o = self.create-node($object);
        die "Node for $object is not created" unless $o.defined;

        # Test for proper classes for the 3 items.
        #
        unless $s ~~ any(Rdf::IRI|Rdf::Blank)
           and $p ~~ any(Rdf::IRI)
           and $o ~~ any(Rdf::IRI|Rdf::Blank|Rdf::Literal) {

          note "Tuple not filled according to rdf rules";
        }

say "TT: ", $s.get-value, ', ', $p.get-value, ', ', $o.get-value;
        $!subject = $s;
        $!predicate = $p;
        $!object = $o;

        $triples.push(self);
      }
    }

    #---------------------------------------------------------------------------
    # Make triples based on Rdf::Node
    #
    multi submethod BUILD (
      Rdf::Node :$subject,
      Rdf::Node :$predicate,
      Rdf::Node :$object
    ) {
      $!subject = $subject;
      $!predicate = $predicate;
      $!object = $object;

      # Test for proper classes for the 3 items.
      #
      unless $subject ~~ any(Rdf::IRI|Rdf::Blank)
         and $predicate ~~ any(Rdf::IRI)
         and $object ~~ any(Rdf::IRI|Rdf::Blank|Rdf::Literal) {

        note "Tuple not filled according to rdf rules";
      }

      $triples.push(self);
    }

    #---------------------------------------------------------------------------
    #
    method get-subject ( ) { return $!subject; }
    method get-predicate ( ) { return $!predicate; }
    method get-object ( ) { return $!object; }

    #---------------------------------------------------------------------------
    #
    method init-triples ( ) {
      $triples = ();
      $!subject = $!predicate = $!object = Rdf::Node;
      $!triples-idx = -1;
    }

    #---------------------------------------------------------------------------
    #
    method get-triple-count ( --> Int ) {
      return $triples.elems;
    }

    #---------------------------------------------------------------------------
    # Set this objects values to the one stored at the index in the
    # triples array. This object is returned.
    #
    method get-triple-from-index (
      $index where (0 <= $index < $triples.elems)
      --> Rdf::Triple
    ) {
      my $t = $triples[$index];

      $!subject = $t.subject;
      $!predicate = $t.predicate;
      $!object = $t.object;
      $!triples-idx = $index;

      return self;
    }

    #---------------------------------------------------------------------------
    # Create literal node if fully specified string is given
    #
    method create-node (
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
  }
}
