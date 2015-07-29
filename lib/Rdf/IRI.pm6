use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class IRI is Rdf::Node {

    # This objects IRI
    #
    has Str $.iri;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( Str :$iri where ?$iri ) {
      $!iri = $iri;
      self.set-value($iri);
      
      # Remove ' :' if it is a default prefix for the iri
      #
      my $si = short-iri($iri);
      $si ~~ s/^ ' :' //;
      self.set-short-value($si);

      self.set-type($Rdf::NODE-IRI);
    }
  }
}

