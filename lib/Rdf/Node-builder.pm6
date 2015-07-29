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
      Str $iri-string where $iri-string.chars >= 1
      --> Rdf::Node
    ) {

      my Rdf::Node $node;

      # Check if short iri is a fully specified literal node.
      #
      if $iri-string ~~ m/ '^^' / {
        $node = Rdf::Literal.new(:lexical-form($iri-string));
      }

      # Check if short iri is a blank node. All blank nodes are written
      # like _:local-name
      #
      elsif $iri-string ~~ m/^ '_:' \w+/ {
        $node = Rdf::Blank.new(:blank-node($iri-string));
      }

      # Check if short iri is a full iri. Check <protocol://>.
      #
      elsif $iri-string ~~ m/^ \w+ '://' / {
        $node = Rdf::IRI.new(:iri($iri-string));
      }

      else {
        my $fi = full-iri($iri-string);
        $node = Rdf::IRI.new(:iri($fi)) if ?$fi;
      }

      return $node;
    }
  }
}
