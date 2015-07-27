use v6;
use Rdf;
#use Rdf::Node;
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
        $node = Rdf::Literal.new(:form($iri-string));
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

    # Create blank node if prefix is '_'
    #
    multi method Ycreate (
      Str $iri-string where $iri-string ~~ m/ ^ '_:' \w+ /
      --> Rdf::Blank
    ) {
      return Rdf::Literal.new(:form($iri-string));
      return Rdf::Blank.new(:blank-node($iri-string));
    }

    #---------------------------------------------------------------------------
    # Returns an undefined object if iri representation is not known. An IRI
    # or Blank node object is returned if a representation is found.
    #
    multi method Xcreate ( Str $iri-string where ?$iri-string --> Rdf::Node ) {

      my Rdf::Node $iri;

      # Check if short iri is a fully specified literal node.
      #
      if $iri-string ~~ m/ '^^' / {
        $iri = Rdf::Literal.new($iri-string);
      }

      # Check if short iri is a blank node. All blank nodes are written
      # like _:local-name
      #
      elsif $iri-string ~~ m/^ '_:' \w+/ {
        $iri = Rdf::Blank.new(:blank-node($iri-string));
      }

      # Check if short iri is a full iri. Check <protocol://>.
      #
      elsif $iri-string ~~ m/^ \w+ '://' / {
        $iri = Rdf::IRI.new(:iri($iri-string));
      }

      else {

        # An iri can be a short iri of only the <local name> or a
        # <prefix:local name> combination. If split returns two results its the
        # second otherwise its the first.
        #
        ( my $prefix, my $local-name) = $iri-string.split(':');

        # prefix and localname if there is a ':'
        #
        my Str $site-iri;
        if ?$local-name {
#say "CI 0: $prefix, $local-name";
          $site-iri = $Rdf::prefixes{$prefix} if $Rdf::prefixes{$prefix}:exists;
        }

        # Only localname in prefix, prefix is default use prefix ' '.
        #
        else {
          $site-iri = $Rdf::prefixes{' '} if $Rdf::prefixes{' '}:exists;
          $local-name = $prefix;
        }

        if ?$site-iri {
          $iri = Rdf::IRI.new(:iri($site-iri ~ $local-name));
        }
      }
#say "CI 1: $site-iri, $iri" if ?$iri;
      return $iri;
    }

  }
}
