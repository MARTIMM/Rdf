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
  is ?$status, True, "Raw parse comment ok";

}, 'raw access';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  EOTURTLE

  spurt( 'xyz.ttl', $content );

  my $status = $turtle.parse-file(:filename('xyz.ttl'));
  is ?$status, True, "Empty file parse ok";

  $status = $turtle.parse(:$content);
  is ?$status, True, "Empty content parse ok";

}, 'empty turtle';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;
  # Test van comments
  EOTURTLE

  my $status = $turtle.parse(:$content);
#say $status.perl;
  is ?$status, True, "Comments parse ok";

}, 'comment';

#-------------------------------------------------------------------------------
# Cleanup
#
unlink 'xyz.ttl';
done();
exit(0);
