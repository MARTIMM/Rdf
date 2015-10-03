use v6;
use Rdf;
use Rdf::Triple;
use Rdf::Blank;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Turtle::Actions {

    # An array of triples to be processed in deeper levels when
    # blank nodes are processed.
    #
    my Array[Hash] $trs .= new({});
    my Int $bn-level = 0;

    constant $START-TRIPLE              = 0;
    constant $SEEN-SUBJECT              = 1;
    constant $PROC-SUBJECT-BLANKNODE    = 2;
    constant $PROC-OBJECT-BLANKNODE     = 3;
#    constant $SEEN-SUBJECT-BLANKNODE    = 4;
#    constant $SEEN-OBJECT-BLANKNODE     = 5;
    constant $SEEN-BLANKNODE            = 6;
    constant $PROC-COLLECTION           = 7;
    my Int $triple-parse-phase          = $START-TRIPLE;

    my $subject;
    my $predicate;
    my $object;

#    #---------------------------------------------------------------------------
#    #
#    method statement ( $match ) {
#say "\n", '-' x 80;
#    }

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
say "Seen-subject, phase: $triple-parse-phase";
      $triple-parse-phase = $SEEN-SUBJECT
        unless $triple-parse-phase == $PROC-SUBJECT-BLANKNODE;
    }

    #---------------------------------------------------------------------------
    #
    method subject-item ( $match ) {
say '=' x 80;
#say "SI: '{$match.made()}', '$match'";
#say "SI: {$match.perl()}";
      $subject = $match<blank-node>:exists
         ?? ~$match<blank-node>.made() // ~$match
         !! ~$match;

say "Subject: $subject";
#`{{
      if $triple-parse-phase !~~ $SEEN-BLANKNODE {
        my $s = ~$match;
#        $s ~~ s/\s* $//;
        $trs[$bn-level]<subject> = $s;
      }
say "\nSubject:     $trs[$bn-level]<subject>, phase: $triple-parse-phase, level: $bn-level";
}}
    }

    #---------------------------------------------------------------------------
    #
    method predicate-object-list ( $match ) {
#say "POI: {$match.perl()}";
say "POI: {$match<po-list><predicate-item>.perl}";
say "POI: {$match<po-list><object-list><object-item>.perl}";
      
    }

    #---------------------------------------------------------------------------
    #
    method predicate-item ( $match ) {
#say "PI: {$match.perl()}";
#say "PI: {$match.made() // '-'}";
      my $p = ~$match;
#      $p ~~ s/\s* $//;
#      $trs[$bn-level]<predicate> = $p;

#say "Predicate:   $trs[$bn-level]<predicate>, phase: $triple-parse-phase, level: $bn-level";

      $predicate = $p;
say "Predicate: $predicate";
    }

    #---------------------------------------------------------------------------
    #
    method object-item ( $match ) {
#say "OI: {$match.perl()}";
#say "OI: {$match.made() // '-'}";

      $object = $match<blank-node>:exists
         ?? ~$match<blank-node>.made() // ~$match
         !! ~$match;

say "Object: $object";

#`{{
      if $triple-parse-phase !~~ $SEEN-BLANKNODE {
        my $o = ~$match;
        $o ~~ s/\s* $//;
        $trs[$bn-level]<object> = $o;
      }
say "Object:      $trs[$bn-level]<object>, phase: $triple-parse-phase, level: $bn-level";
}}

      if ?$subject and ?$predicate and ?$object {
say "Add tuple: $subject, $predicate, $object";
        my Rdf::Triple $t .= new(
          :subject($subject),
          :predicate($predicate),
          :object($object)
        );
say "Triple count: {$t.get-triple-count()}";
      }

      else {
        note "One of the tuple arguments are not defined";
      }
    }

    #---------------------------------------------------------------------------
    #
    method blank-node ( $match ) {
      my $bn = ~$match.made() // ~$match;
say "Blank node:  $bn, $match, phase: $triple-parse-phase, level: $bn-level";
    }

    #---------------------------------------------------------------------------
    #
    method proc-blank-node ( $match ) {
      my $bn = Rdf::Blank.new(blank => '[]');
say "Proc blank node: phase: $triple-parse-phase, level: $bn-level";

      # When blank node group is found at the start of the triple, it is
      # positioned in place of a subject. All other nested groups of blank node
      # predicate-object lists are on the object.
      #
      if $triple-parse-phase == $START-TRIPLE {
#say "\nSubject\[GBN]:     $bn";
        $trs[$bn-level]<subject> = ~$bn;
        $triple-parse-phase = $PROC-SUBJECT-BLANKNODE;
      }

      # When blank node group is not found at the start of the triple, it is
      # positioned in place of an object.
      #
      else {
#say "Object\[GBN]:     $bn";
        $trs[$bn-level]<object> = ~$bn;
        $triple-parse-phase = $PROC-OBJECT-BLANKNODE;
      }

      $bn-level++;
      $trs[$bn-level] = {};

      # On next level subject always has same blank node
      #
      $trs[$bn-level]<subject> = ~$bn;
    }

    #---------------------------------------------------------------------------
    #
    method seen-blank-node ( $match ) {
say "Seen blank node:   $match, phase: $triple-parse-phase, level: $bn-level";
      if $triple-parse-phase
         ~~ any($PROC-SUBJECT-BLANKNODE | $PROC-OBJECT-BLANKNODE) {
        $triple-parse-phase = $SEEN-BLANKNODE;
      }

#      else {
#        note "In seen-blank-node: should not happen, phase $triple-parse-phase, level: $bn-level";
#      }

      $bn-level--;
    }

    #---------------------------------------------------------------------------
    #
    method collection ( $match ) {
#say "Seen collection:   $match, phase: $triple-parse-phase, level: $bn-level";
      
    }

    #---------------------------------------------------------------------------
    #
    method proc-collection ( $match ) {
#say "Seen collection:   $match, phase: $triple-parse-phase, level: $bn-level";
#      $triple-parse-phase = $PROC-COLLECTION;
    }
  }
}

