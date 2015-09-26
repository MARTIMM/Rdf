use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;


#-------------------------------------------------------------------------------
subtest {

  ok get-base() ~~ m/ '501-turtle-prefix/' $$ /, "Init base name {get-base()}";

  my Str $content = qq:to/EOTURTLE/;
  @base <my-syntax-ns/> .
  @base <http://www.w3.org/1999/02/22-rdf-syntax-ns/> .
  EOTURTLE

  my Match $status = $t.parse(:$content);
  ok $status ~~ Match, "Parse bases ok";

  is get-base(),
     'http://www.w3.org/1999/02/22-rdf-syntax-ns/',
     "Last change to {get-base()}";

}, 'parse base';

#-------------------------------------------------------------------------------
subtest {

  is get-prefix(), '', 'No default prefix';
  is get-prefix('rdf'),
     'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
     "rdf defined as {get-prefix('rdf')}";

  my Str $content = qq:to/EOTURTLE/;
  @prefix : <relative-path#> .
  @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
  @prefix pf1: <http://no-special-site.com> .
  EOTURTLE

  my Match $status = $t.parse(:$content);
  ok $status ~~ Match, "Parse prefixes ok";

  is get-prefix(),
     'http://www.w3.org/1999/02/22-rdf-syntax-ns/relative-path#',
     "Default prefix {get-prefix()}";
  is get-prefix('pf1'),
     'http://no-special-site.com',
     "pf1 defined as {get-prefix('pf1')}";

}, 'parse prefix';

#-------------------------------------------------------------------------------
# Cleanup
#
done-testing();
exit(0);
