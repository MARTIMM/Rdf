use v6;
use Test;

use Rdf;
use Rdf::Turtle;
use Rdf::Turtle::Grammar;

my Rdf::Turtle $turtle .= new;

#-------------------------------------------------------------------------------
subtest {

  my Rdf::Turtle::Grammar $grammar .= new;
  my $status = $grammar.parse( "\n", :rule('RDF_1_0'));
  is ?$status, True, "Raw parse empty text ok";

  $status = $grammar.parse( "# comment", :rule('comment'));
  ok ?$status.orig(), "Raw parse comment ok";

}, 'raw access';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  EOTURTLE

  spurt( 'xyz.ttl', $content );

  # With empty files the statement key must be tested. This is a top rule
  # which must be processed at least.
  #
  my $status = $turtle.parse-file(:filename('xyz.ttl'));
  ok $status<statement>:exists, "Empty file parse ok";

  $status = $turtle.parse(:$content);
  ok $status<statement>:exists, "Empty content parse ok";

}, 'empty turtle';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;
  # Test van comments
  EOTURTLE

  my $status = $turtle.parse(:$content);
  ok ?$status.orig(), "Comments parse ok";

}, 'comment';

#-------------------------------------------------------------------------------
# Cleanup
#
unlink 'xyz.ttl';
done();
exit(0);
