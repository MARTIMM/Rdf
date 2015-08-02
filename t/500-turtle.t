use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;


#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  EOTURTLE

  spurt( 'xyz.ttl', $content );

  my $status = $t.parse-file(:filename('xyz.ttl'));
  is ?$status, True, "Empty file parse ok";

  $status = $t.parse(:$content);
  is ?$status, True, "Empty content parse ok";

}, 'empty turtle';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;
  # Test van comments
  EOTURTLE

  my $status = $t.parse(:$content);
#say $status.perl;
  is ?$status, True, "Comments parse ok";

}, 'comment';



#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
