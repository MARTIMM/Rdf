use v6;
use Rdf;

use Rdf::IRI;
use Rdf::Graph;
use Rdf::Blank;
use Rdf::Literal;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Node-builder {

    # Create literal node if fully specified string is given
    #
    method create (
      Str $iri-string is copy where $iri-string.chars >= 1
      --> Rdf::Node
    ) {

      my Rdf::Node $node;

      # Check if short iri is a blank node. All blank nodes are written
      # like _:local-name
      #
      if $iri-string ~~ m/^ '_:' \w+/ {
        $node = Rdf::Blank.new(:blank-node($iri-string));
      }

      # Check if iri is a full iri..
      #
      elsif $iri-string ~~ m/^ '<' / or $iri-string ~~ m/ ':' / {
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



=finish

      # Check if iri is a full iri..
      #
      elsif $iri-string ~~ m/^ '<' / {
        $iri-string ~~ s/^ '<'//;
        $iri-string ~~ s/'>' \s* $//;

        $iri-string = get-base() ~ $iri-string
          unless $iri-string ~~ m/^ \w+ '://' /;
#say "iri --> $iri-string";
        $node = Rdf::IRI.new(:iri($iri-string));
      }

      # Check if iri is a short iri..
      #
      elsif $iri-string ~~ m/ ':' / {
        my $fi = full-iri($iri-string);
#say "iri --> $fi";
        $node = Rdf::IRI.new(:iri($fi));
      }
