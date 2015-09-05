use v6;
use Rdf;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Turtle::Actions {

    has Str $.iri;
    has Str $.blank;
    has Str $.literal;

    has Str $.subject;
    has Str $.predicate;
    has Str $.object;

    #---------------------------------------------------------------------------
    #
    method statement ( $match ) {
      say "\n", '-' x 80;
    }

    #---------------------------------------------------------------------------
    #
    method prefix-id ( $match ) {

      # Get the prefix name and uri from the match. Prefix name might be
      # undefined.
      #
      my $pname= $match<prefix-name> ?? ~$match<prefix-name> !! '';
      my $uri-ref = ~$match<uri-ref><relative-uri>;

      # Check if prefix name is defined. If not then its a default prefix
      #
      if ?$pname {
        set-prefix( :prefix($pname), :local-name($uri-ref));
      }

      else {
        set-prefix(:local-name($uri-ref));
      }
    }

    #---------------------------------------------------------------------------
    #
    method base-id ( $match ) {

      # Get the uri from the match.
      #
      my $uri-ref = ~$match<uri-ref><relative-uri>;

      # Check if absolute url. if not, append to base
      #
      set-base(
        $uri-ref ~~ m/ ^ \w+ '://' /
          ?? $uri-ref
          !! get-base() ~ $uri-ref
      );
    }

    #---------------------------------------------------------------------------
    #
    method subject-item ( $match ) {
      say "Subject:     $match";
    }

    #---------------------------------------------------------------------------
    #
    method predicate-item ( $match ) {
      say "Predicate:   $match";
    }

    #---------------------------------------------------------------------------
    #
    method object-item ( $match ) {
      say "Object:      $match";
    }

    #---------------------------------------------------------------------------
    #
#    method relative-uri ( $match ) {
#    }

    #---------------------------------------------------------------------------
    #
    method resource ( $match ) {

      my $uri-ref = $match<uri-ref> // '';
      my $qname= $match<qname> // '';
say "Resource u/q: $uri-ref/$qname";
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
        $s = get-base() ~ $!url;
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
        $p = get-base() ~ $!url;
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
        $o = get-base() ~ $!url;
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
