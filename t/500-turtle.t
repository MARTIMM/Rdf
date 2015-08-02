use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;

my Str $content = qq:to/EOTURTLE/;

EOTURTLE

#-------------------------------------------------------------------------------
subtest {
  spurt( 'xyz.ttl', $content );

  my $status = $t.parse-file(:filename('xyz.ttl'));
  is ?$status, True, "Empty file parse ok";

  my $status = $t.parse(:$content);
  is ?$status, True, "Empty content parse ok";

}, 'empty turtle';

#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
