# Turtle, the Terse RDF Triple Language. See also
# http://www.w3.org/TeamSubmission/turtle/#relativeURI
#
use v6;
use Rdf;                        # Load first!
use Rdf::Turtle::Grammar;
use Rdf::Turtle::Actions;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Turtle {

    has Rdf::Turtle::Grammar $.grammar;
    has Rdf::Turtle::Actions $.actions;

    #---------------------------------------------------------------------------
    #
    method parse-file ( str :$filename where $filename.IO ~~ :r --> Match) {

      $!actions = Rdf::Turtle::Actions.new(:init);
      my $text = slurp($filename);
      return self.parse(:content($text));
    }

    #-----------------------------------------------------------------------------
    #
    method parse ( :$content is copy --> Match ) {

      # Parse the content. Parse can be recursively called
      #
      $!grammar .= new;
      $!actions .= new;
      return $!grammar.parse( $content, :actions($!actions)) // Match.new;
    }
  }
}
