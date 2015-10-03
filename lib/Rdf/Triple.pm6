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
  my Array $triples = [];

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
    # Make triples based on strings. Arguments can be absent to return an
    # empty object.
    #
    multi submethod BUILD ( :$subject, :$predicate, :$object ) {

      if ?$subject and ?$predicate and ?$object {

        my Rdf::Node $s;
        my Rdf::Node $p;
        my Rdf::Node $o;

        # Get subject
        #
        if $subject ~~ Rdf::Node {
          $s = $subject;
        }

        elsif $subject ~~  Str {
          $s = self.create-node($subject);
          die "Subject node $subject not created" unless $s.defined;
        }

        # Get predicate
        #
        if $predicate ~~ Rdf::Node {
          $p = $predicate;
        }

        elsif $predicate ~~ Str {
          $p = self.create-node($predicate);
          die "Predicate node $predicate not created" unless $p.defined;
        }

        # Get object
        #
        if $object ~~ Rdf::Node {
          $o = $object;
        }

        elsif $object ~~ Str {
          $o = self.create-node($object);
          die "Object node $object not created" unless $o.defined;
        }

#say "Triple: $subject $predicate $object";
#say "TT: ", $s.get-value, ', ', $p.get-value, ', ', $o.get-value;
        # Test for proper classes for the 3 items.
        #
        unless $s ~~ any(Rdf::IRI|Rdf::Blank)
           and $p ~~ any(Rdf::IRI)
           and $o ~~ any(Rdf::IRI|Rdf::Blank|Rdf::Literal) {

          note "Tuple not filled according to rdf rules";
        }

        $!subject = $s;
        $!predicate = $p;
        $!object = $o;

        $triples.push: self;
        $!triples-idx = $triples.end;
      }

      else {
        # Try other BUILD() method
        #
        callsame;
      }
    }

    #---------------------------------------------------------------------------
    # Default init where object is initialized with an entry from the triples
    # array if any. The default data comes from the first entry.
    # method get-triple-from-index() is not used here because it can crash when
    # there are no entries.
    #
    multi submethod BUILD ( Int :$index = 0 ) {
      if 0 <= $index < $triples.elems {
        my $t = $triples[$index];
        $!subject = $t.subject;
        $!predicate = $t.predicate;
        $!object = $t.object;
        $!triples-idx = $index;
      }
    }

    #---------------------------------------------------------------------------
    #
    method get-subject ( ) { return $!subject; }
    method get-predicate ( ) { return $!predicate; }
    method get-object ( ) { return $!object; }

    #---------------------------------------------------------------------------
    #
    method init-triples ( ) {
      $triples = Array;
      $!subject = $!predicate = $!object = Rdf::Node;
      $!triples-idx = -1;
      init-blank-node-count();
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
