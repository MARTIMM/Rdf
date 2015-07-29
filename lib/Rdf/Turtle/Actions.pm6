use v6;
use Rdf;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Turtle::Actions {

    has Str $.prefix;
    has Str $.url;


    #---------------------------------------------------------------------------
    #
    method turtle-prefix ( $match ) {
say "Set prefix for $!prefix";
      prefix( :prefix($!prefix), :local-name($!url));
    }

    #---------------------------------------------------------------------------
    #
    method prefix-id ( $match ) {

      $!prefix = ~$match;
    }

    #---------------------------------------------------------------------------
    #
    method prefix-url ( $match ) {

      $!url = ~$match;
    }
  }
}
