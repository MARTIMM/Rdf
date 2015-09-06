use v6;
use Test;

use Rdf;
use Rdf::Rdf-tuple;

set-prefix(local-name => 'file://Perl6/Projects/Rdf#');

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Rdf-tuple $t = tuple( ':Mary', 'rdf:type', 'foaf:person');
  is $t.subject.get-value, 'file://Perl6/Projects/Rdf#Mary', $t.subject.get-value;
  is $t.subject.get-short-value, 'Mary', $t.subject.get-short-value;

say "T: ", $t.perl;
}, 'tuple';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
