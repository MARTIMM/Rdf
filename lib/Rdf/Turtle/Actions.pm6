use v6;
use Rdf;
use Rdf::Triple;
use Rdf::Blank;

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

    has Str $.bn-name;

    constant $START-TRIPLE              = 0;
    constant $SEEN-SUBJECT              = 1;
    constant $SEEN-SUBJECT-BLANKNODE    = 2;
    constant $SEEN-OBJECT-BLANKNODE     = 3;
    my Int $triple-parse-phase          = $START-TRIPLE;

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
    method start-triple ( $m ) { $triple-parse-phase = $START-TRIPLE; }
    method seen-subject ( $m ) {
      $triple-parse-phase = $SEEN-SUBJECT
        unless $triple-parse-phase == $SEEN-SUBJECT-BLANKNODE;
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
say "Object:      $match, phase: $triple-parse-phase";
      my Rdf::Triple $t .= new;;
      $!object = ~$match;

      if $triple-parse-phase == $SEEN-SUBJECT-BLANKNODE {
say "Add tuple: $!bn-name, $!predicate, $!object";
        $t .= new( :subject($!bn-name), :$!predicate, :$!object);
      }

      elsif $triple-parse-phase == $SEEN-SUBJECT {
say "Add tuple: $!subject, $!predicate, $!object";
        $t .= new( :$!subject, :$!predicate, :$!object);
      }
    }

    #---------------------------------------------------------------------------
    #
    method blank-node ( $match ) {
say "Blank node:   $match";
    }

    #---------------------------------------------------------------------------
    #
    method gen-blank-node ( $match ) {
      my $bn = Rdf::Blank.new(blank => '[]');
say "Gen blank node: phase: $triple-parse-phase";

      if $triple-parse-phase == $START-TRIPLE {
say "\nSubject:     $bn";
        $!bn-name = $!subject = ~$bn;
        $triple-parse-phase = $SEEN-SUBJECT-BLANKNODE;
      }

      else {
say "Processing object";
        $!bn-name = $!object = ~$bn;
        $triple-parse-phase = $SEEN-OBJECT-BLANKNODE;
      }
    }
  }
}

