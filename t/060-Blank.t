use v6;
use Test;

use Rdf;
use Rdf::Blank;

my Rdf::Blank $b;

#-------------------------------------------------------------------------------
subtest {
  $b = Rdf::Blank.new(blank => '_:x');
  isa-ok $b, 'Blank', 'B is Blank';
  is ~$b, '_:x', "Blank node 1 = $b";

  $b = Rdf::Blank.new(blank => '[]');
  is ~$b, '_:BN_0001', "Anonymous blank node 1 = $b";

  $b = Rdf::Blank.new(blank => '[]');
  is ~$b, '_:BN_0002', "Anonymous blank node 1 = $b";
}, 'Test blank node';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);

