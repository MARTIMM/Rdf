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

      # Turtle predicate 'a' is same as
      #.http://www.w3.org/1999/02/22-rdf-syntax-ns#type
      #
      if $iri eq 'a' {
        $iri = '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>';
      }

      if $iri ~~ m/ ^ <Rdf::Turtle::Grammar::resource> $ / {
        my $r = $/<Rdf::Turtle::Grammar::resource>;
        my $uri = $r<uri-ref>:exists ?? ~$r<uri-ref> !! '';
        my $qnm = $r<qname>:exists ?? ~$r<qname> !! '';

        # Matched a uri-ref
        #
        if ?$uri {

          # Prefix the base if the iri don't start with a protocol part
          #
          $uri ~~ s/^ '<' /{'<' ~ get-base()}/
               unless $uri ~~ m/^ '<' \w+ '://' /;

          self.set-value(self.full-iri(:short-iri($uri)));
          self.set-short-value(self.short-iri(:full-iri($uri)));
        }

        # Matched a qname
        #
        elsif ?$qnm {
          self.set-value(self.full-iri(:short-iri($qnm)));
          self.set-short-value(self.short-iri(:full-iri($qnm)));
        }
      }
    }
  }
}

