use v6;
use Rdf;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class IRI {

    # This objects IRI
    #
    has Str $.iri;


    #---------------------------------------------------------------------------
    #
    method prefix (
      Str :$prefix = ' ',
      Str :$local-name where $local-name.chars > 1
    ) {

      if ?$Rdf::prefixes{$prefix} {
        note "Prefix '$prefix' in use for $Rdf::prefixes{$prefix}";
      }

      else {
        $Rdf::prefixes{$prefix} = $local-name;
      }
    }

    #---------------------------------------------------------------------------
    # Returns an undefined object if iri representation is not known. An IRI
    # object is returned if a representation is found.
    #
    method check-iri ( Str $short-iri --> Rdf::IRI ) {

      my Rdf::IRI $iri;

      # Check if short iri is a full iri. Check <protocol://>.
      #
      if $short-iri ~~ m/^ \w+ '://' / {
        $iri .= new(:iri($short-iri));
      }

      else {

        # An iri can be a short iri of only the <local name> or a
        # <prefix:local name> combination. If split returns two results its the
        # second otherwise its the first.
        #
        ( my $prefix, my $local-name) = $short-iri.split(':');

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
          $iri .= new(:iri($site-iri ~ $local-name));
        }
      }
#say "CI 1: $site-iri, $iri" if ?$iri;
      return $iri;
    }

    #---------------------------------------------------------------------------
    #
    multi method Str (  ) { return $!iri; }

    #---------------------------------------------------------------------------
    # Getters
    #
    method get-iri ( ) { return $!iri; }
    method get-prefix ( Str $prefix = ' ' ) { return $Rdf::prefixes{$prefix}; }
  }
}
