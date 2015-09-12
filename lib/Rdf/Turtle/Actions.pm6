use v6;
use Rdf;
use Rdf::Triple;

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
      # undefined. If the url is relative, attach the previously defined
      # basename to it.
      #
      my $pname= $match<prefix-name> ?? ~$match<prefix-name> !! '';
      my $uri-ref = ~$match<uri-ref><relative-uri>;
      $uri-ref = $uri-ref ~~ m/ ^ \w+ '://' /
        ?? $uri-ref
        !! get-base() ~ $uri-ref;

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

      # Get the uri from the match. If the url is relative, attach the
      # previously defined basename to it.
      #
      my $uri-ref = ~$match<uri-ref><relative-uri>;
      $uri-ref = $uri-ref ~~ m/ ^ \w+ '://' /
        ?? $uri-ref
        !! get-base() ~ $uri-ref;

      # Check if absolute url. if not, append to base
      #
      set-base($uri-ref);
    }

    #---------------------------------------------------------------------------
    #
    method triples ( $match ) {
    }

    #---------------------------------------------------------------------------
    #
    method subject-item ( $match ) {
say "\nSubject:     $match";
      $!subject = ~$match;
    }

    #---------------------------------------------------------------------------
    #
    method predicate-item ( $match ) {
say "Predicate:   $match";
      $!predicate = ~$match;
    }

    #---------------------------------------------------------------------------
    #
    method object-item ( $match ) {
say "Object:      $match";
      $!object = ~$match;

say "Add tuple: $!subject, $!predicate, $!object";
      my Rdf::Triple $t .= new( :$!subject, :$!predicate, :$!object);
    }
  }
}

