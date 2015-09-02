use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;


#-------------------------------------------------------------------------------
subtest {

  my Str $content = qq:to/EOTURTLE/;
  @base <my-syntax-ns#> .
  @base <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  EOTURTLE

  my Match $status = $t.parse(:$content);
  ok $status ~~ Match, "Parse bases ok";

}, 'parse base';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;
  @prefix : <local-path#> .
  @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  EOTURTLE

  my Match $status = $t.parse(:$content);
  ok $status ~~ Match, "Parse prefixes ok";

}, 'parse prefix';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
