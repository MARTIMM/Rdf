use v6;

# Needed because of dependency on @prefixes defined in Rdf.pm6
#
use Rdf;

package Rdf {

  class Node {

    has Str $!value;
    has Str $!short-value;

    my Regex $r = token { ^ '<' };

    #---------------------------------------------------------------------------
    #
    method set-value (
      Str $value where $value.chars > 0
    ) {
      $!value = $value;
    }

    #---------------------------------------------------------------------------
    #
    method set-short-value (
      Str $short-value where $short-value.chars > 0
    ) {
      $!short-value = $short-value;
    }

    #---------------------------------------------------------------------------
    #
    method get-value ( --> Str ) { return $!value; }
    method get-short-value ( --> Str ) { return $!short-value; }
    multi method Str ( --> Str ) { return $!value; }

    #---------------------------------------------------------------------------
    # Convert short notation iri into full iri format
    # e.g. xsd:long --> http://www.w3.org/2001/XMLSchema#long
    #
    method full-iri ( Str :$short-iri where $short-iri.chars > 0 --> Str ) {

      # Return directly when '<' of the string, its already a full iri or a
      # wrong string altogether.
      #
      # Previously the test `if $short-iri ~~ m/^ '<' / { ... }' was used which
      # after a number of successful tests failed with the error;
      #   Invocant requires a type object of type Match, but an object instance
      #   was passed.  Did you forget a 'multi'?
      #
      if $short-iri ~~ $r {
        return $short-iri;
      }

      # An iri can be a short iri of only the <local name> or a
      # <prefix:local name> combination. If split returns two results its the
      # second otherwise its the first.
      #
      ( my $prefix, my $local-name) = $short-iri.split(':');
      # prefix and localname if there is a ':'
      #
      my Str $full-iri;
      if ?$prefix {
        my $iri = $Rdf::prefixes{$prefix} //
                  $Rdf::prefixes{'__Unknown_Prefix__'};
        $full-iri = $iri ~ $local-name;
      }

      # Only localname in prefix, prefix is default, use prefix ' '.
      #
      else {
        my $iri = $Rdf::prefixes{' '} //
                  $Rdf::prefixes{'__Unknown_Prefix__'};
        $full-iri = $iri ~ $local-name;
      }

      return '<' ~ $full-iri ~ '>';
    }

    #---------------------------------------------------------------------------
    # Convert full iri into a short one if local name is found in the prefixes
    # list.
    #
    method short-iri ( Str :$full-iri --> Str ) is export {

      my Str $short-iri = $full-iri;
      $short-iri ~~ s/^ '<' //;
      $short-iri ~~ s/ '>' $//;

      for $Rdf::prefixes.keys -> $k {
        my $uri = $Rdf::prefixes{$k};
        if $short-iri ~~ m/ $uri / {
          $short-iri ~~ s/ $uri /$k:/;
          last;
        }
      }

      # Remove leading space if default prefix is used
      #
      $short-iri ~~ s/^ ' :' /:/;

      return $short-iri;
    }
  }
}


