use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;


#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;
  @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  EOTURTLE

  my $status = $t.parse(:$content);
  is ?$status, True, "Parse prefixes ok";

}, 'prefix';

#-------------------------------------------------------------------------------
#subtest {
#}, 'base';



#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
