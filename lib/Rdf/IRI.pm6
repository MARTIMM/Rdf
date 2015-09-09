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
        my $uri = $r<uri-ref>:exists ?? ~$r<uri-ref> !! '';
        my $qnm = $r<qname>:exists ?? ~$r<qname> !! '';
        if ?$uri {

          # Prefix the base if the iri don't start with a protocol part
          #
          $uri ~~ s/^ '<' /{'<' ~ get-base()}/
               unless $uri ~~ m/^ '<' \w+ '://' /;

          self.set-value(self.full-iri(:short-iri($uri)));
          self.set-short-value(self.short-iri(:full-iri($uri)));
        }

        elsif ?$qnm {
          self.set-value(self.full-iri(:short-iri($qnm)));
          self.set-short-value(self.short-iri(:full-iri($qnm)));
        }
      }
    }
  }
}

