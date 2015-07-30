# Turtle, the Terse RDF Triple Language. See also
# http://www.w3.org/TeamSubmission/turtle/#relativeURI
#
use v6;
use Rdf;
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
    method parse-file ( str :$filename ) {

      if $filename.IO ~~ :r {
        $!actions = Rdf::Turtle::Actions.new(:init);
        my $text = slurp($filename);
        self.parse(:content($text));
      }
      
      else {
        die "File $filename not found";
      }
    }

    #-----------------------------------------------------------------------------
    #
    method parse ( :$content is copy ) {

      # Remove comments, trailing and leading spaces
      #
  #    $content ~~ s:g/<-[\\]>\#.*?$$//;
  #    $content ~~ s/^\#.*?$$\n//;
  #say "\nContent;\n$content\n\n";
      $content ~~ s/^\s+//;
      $content ~~ s/\s+$//;

      # Parse the content. Parse can be recursively called
      #
      $!grammar .= new;
      $!actions .= new;
      if ! $!grammar.parse( $content, :actions($!actions)) {
        if $Rdf::seen-eol {
          die "Error parsing content";
        }
        
        else {
          die "Error parsing content, perhaps forgot to end the line with a '.'?";
        }
      }
    }
  }
}
