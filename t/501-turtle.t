use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;


#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;
  @prefix : <local-path#> .
  @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  EOTURTLE

  my $status = $t.parse(:$content);
  is ?$status, True, "Parse prefixes ok";
  is get-prefix, 'local-path#', 'Default prefix';
  is get-prefix('rdf'),
    'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    'Default prefix'
    ;

  $content = qq:to/EOTURTLE/;
  @base <my-syntax-ns#> .
  @base <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  EOTURTLE

  $status = $t.parse(:$content);
  is ?$status, True, "Parse prefixes ok";

}, 'prefix and base';

#-------------------------------------------------------------------------------
#subtest {
#}, 'base';



#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
