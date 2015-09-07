use v6;
use Test;

use Rdf;
use Rdf::Node-builder;

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Blank $b1 = Rdf::Node-builder.create('_:x');
  isa-ok $b1, 'Blank', 'l1 is Blank';
  is ~$b1, '_:x', "Blank node 1 = $b1";
  is $b1.get-type, $Rdf::NODE-BLANK, "Type b1 = {$b1.get-type}";

}, 'Test blank node';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);

