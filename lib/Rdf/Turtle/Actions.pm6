use v6;
use Rdf;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Turtle::Actions {

    has Str $.base = 'file:///' ~ $*PROGRAM-NAME ~ '#';

    has Str $.prefix;
    has Str $.url;
    has Str $.iri;
    has Str $.blank;
    has Str $.literal;

    has Str $.subject;
    has Str $.predicate;
    has Str $.object;


    #---------------------------------------------------------------------------
    #
    method turtle-base ( $match ) {
      # Check if absolute url. if not, append to base
      #
      $!base = $!url ~~ m/ ^ \w+ '://' /
               ?? $!url
               !! $!base ~ $!url;
say "Set base for productions to $!base";
    }

    #---------------------------------------------------------------------------
    #
    method turtle-prefix ( $match ) {
      
      # When no prefix text is given, set it as a default
      #
say ?$!prefix
    ?? "Set prefix for $!prefix"
    !! "Set default prefix";

      if ?$!prefix {
        prefix( :prefix($!prefix), :local-name($!url));
      }
      
      else {
        prefix(:local-name($!url));
      }
      
      # Reset prefix to type object to recognize any default settings
      #
      $!prefix = Str;
    }

    #---------------------------------------------------------------------------
    #
    method prefix-id ( $match ) {

#say "Set prefix id: ", $match.perl;
      $!prefix = ~$match;
    }

    #---------------------------------------------------------------------------
    #
    method relative-uri ( $match ) {

      $!url = ~$match;
say "Set url: $!url";
    }

    #---------------------------------------------------------------------------
    # Subject can be an iri or a blank iri
    #
    method subject ( $match ) {
      my Str $s;
      if ~$match ~~ m/ ^ '<' / {
        $s = $!base ~ $!url;
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
        $p = $!base ~ $!url;
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
        $o = $!base ~ $!url;
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
  }
}
