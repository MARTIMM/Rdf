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
    # Parse content and return a Match object always. When parsing fails,
    # the Match object is empty. Test for failure like '? $m<statement>:exists'.
    # The rule statement is noted in the Match object.
    #
    method parse ( :$content is copy --> Match ) {

      # Parse the content. Parse can be recursively called
      #
      $!grammar .= new;
      $!actions .= new;
      return $!grammar.parse(
               $content,
               :actions($!actions),
               :rule('RDF_1_0')
             ) // Match.new;
    }
  }
}
