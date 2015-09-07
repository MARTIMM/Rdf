use v6;
use Rdf;
use Rdf::Node;
use Rdf::Turtle::Grammar;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class IRI is Rdf::Node {

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( Str :$iri is copy where ?$iri ) {

      if $iri ~~ m/ ^ <Rdf::Turtle::Grammar::resource> $ / {
        my $r = $/<Rdf::Turtle::Grammar::resource>;
        my $uri = $r<uri-ref>:exists ?? ~$r<uri-ref><relative-uri> !! '';
        my $qnm = $r<qname>:exists ?? ~$r<qname> !! '';
        if ?$uri {

          # Remove <> around the iri if they are there
          #
          $uri ~~ s/^ '<'//;
          $uri ~~ s/'>' \s* $//;

          $uri = get-base() ~ $uri unless $uri ~~ m/^ \w+ '://' /;
          self.set-value(self.full-iri(:short-iri($uri)));
          self.set-short-value(self.short-iri(:full-iri($uri)));
        }

        elsif ?$qnm {

          self.set-value(self.full-iri(:short-iri($qnm)));
          self.set-short-value(self.short-iri(:full-iri($qnm)));
        }
      }
    }

    #---------------------------------------------------------------------------
    # Convert short notation iri into full iri format
    # e.g. xsd:long --> http://www.w3.org/2001/XMLSchema#long
    #
    method full-iri ( Str :$short-iri --> Str ) {

      # Return directly when protocol is found at the beginning of the string
      #
      return $short-iri if $short-iri ~~ m/^ \w+ '://' /;

      # An iri can be a short iri of only the <local name> or a
      # <prefix:local name> combination. If split returns two results its the
      # second otherwise its the first.
      #
      ( my $prefix, my $local-name) = $short-iri.split(':');

      # prefix and localname if there is a ':'
      #
      my Str $site-iri;
      if ?$prefix {
        my $iri = $Rdf::prefixes{$prefix} //
                  $Rdf::prefixes{'__Unknown_Prefix__'};
        $site-iri = $iri ~ $local-name;
      }

      # Only localname in prefix, prefix is default, use prefix ' '.
      #
      else {
        my $iri = $Rdf::prefixes{' '} //
                  $Rdf::prefixes{'__Unknown_Prefix__'};
        $site-iri = $iri ~ $local-name;
      }

      return $site-iri;
    }

    #---------------------------------------------------------------------------
    # Convert full iri into a short one if local name is found in the prefixes
    # list.
    #
    method short-iri ( Str :$full-iri is copy --> Str ) is export {

      for $Rdf::prefixes.keys -> $k {
        my $uri = $Rdf::prefixes{$k};
        if $full-iri ~~ m/ $uri / {
          $full-iri ~~ s/ $uri /$k:/;
          last;
        }
      }

      # Remove leading space if default prefix is used
      #
      $full-iri ~~ s/^ ' :' /:/;

      return $full-iri;
    }
  }
}

