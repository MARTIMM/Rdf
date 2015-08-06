use v6;
use Rdf;

package Rdf {

  our $base;

  #-----------------------------------------------------------------------------
  #
  class Turtle::Actions {

    has Str $.prefix-name;
    has Str $.relative-uri;

    has Str $.iri;
    has Str $.blank;
    has Str $.literal;

    has Str $.subject;
    has Str $.predicate;
    has Str $.object;


    #---------------------------------------------------------------------------
    #
    submethod BUILD (  ) {
      if !$Rdf::base.defined {
        $Rdf::base = 'file:///' ~ $*PROGRAM-NAME;
        $Rdf::base ~~ s/ '.' <-[.]>+ $ //;
        $Rdf::base ~= '#';
say "Base at start: $base";
      }
    }

    #---------------------------------------------------------------------------
    #
    method prefix-name ( $match ) {

      $!prefix-name = ~$match;
say "prefix-name: $!prefix-name";
    }

    #---------------------------------------------------------------------------
    #
    method relative-uri ( $match ) {
      $!relative-uri = ~$match;

      # When uri is without protocol part than prepend the base upon it
      #
      if $!relative-uri !~~ m/ ^ \w+ '://' / {
        $!relative-uri = $Rdf::base ~ $!relative-uri;
      }

say "relative-uri: $!relative-uri";
    }

    #---------------------------------------------------------------------------
    #
    method prefix-id ( $match ) {
      
      # When no prefix text is given, set it as a default
      #
say ? $!prefix-name
    ?? "Set prefix for $!prefix-name"
    !! "Set default prefix";

      # Check if prefix name is defined. If not then its a default prefix
      #
      if ?$!prefix-name {
        prefix( :prefix($!prefix-name), :local-name($!relative-uri));
      }

      else {
        prefix(:local-name($!relative-uri));
      }
      
      # Reset prefix to type object to recognize any default settings
      #
      $!prefix-name = Str;
    }

    #---------------------------------------------------------------------------
    #
    method base-id ( $match ) {
      # Check if absolute url. if not, append to base
      #
      $Rdf::base = $!relative-uri ~~ m/ ^ \w+ '://' /
               ?? $!relative-uri
               !! $Rdf::base ~ $!relative-uri;
say "Set base for productions to $Rdf::base";
    }
  }
}


=finish
    #---------------------------------------------------------------------------
    # Subject can be an iri or a blank iri
    #
    method subject ( $match ) {
      my Str $s;
      if ~$match ~~ m/ ^ '<' / {
        $s = $Rdf::base ~ $!url;
      }
      
      elsif ~$match ~~ m/ ^ ':' / {
        $s = $!iri;
        $s ~~ s/ ':' //;
      }
      
      elsif ~$match ~~ m/ ':' / {
        $s = $!iri;
      }
      
      
      
      $!subject = $s;
say "Subject ", full-iri($!subject);
    }

    #---------------------------------------------------------------------------
    #
    method predicate ( $match ) {
      my Str $p;
      if ~$match ~~ m/ ^ '<' / {
        $p = $Rdf::base ~ $!url;
      }
      
      elsif ~$match ~~ m/ ^ ':' / {
        $p = $!iri;
        $p ~~ s/ ':' //;
      }
      
      elsif ~$match ~~ m/ ':' / {
        $p = $!iri;
      }
      
      $!predicate = $p;
say "Predicate ", full-iri($!predicate);
    }

    #---------------------------------------------------------------------------
    #
    method object ( $match ) {
      my Str $o;
      if ~$match ~~ m/ ^ '<' / {
        $o = $Rdf::base ~ $!url;
      }
      
      elsif ~$match ~~ m/ ^ ':' / {
        $o = $!iri;
        $o ~~ s/ ':' //;
      }
      
      elsif ~$match ~~ m/ ':' / {
        $o = $!iri;
      }
      
      $!object = $o;
say "Object ", full-iri($!object);
    }

    #---------------------------------------------------------------------------
    #
    method resource ( $match ) {
      $!iri = ~$match;

say "Resource $match";
    }

    #---------------------------------------------------------------------------
    #
    method blank ( $match ) {
      $!blank = ~$match;
    }

    #---------------------------------------------------------------------------
    #
    method literal ( $match ) {
      $!literal = ~$match;
say "Literal ", ~$match;
    }
