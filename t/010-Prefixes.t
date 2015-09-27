use v6;
use Test;

use Rdf;
use Rdf::IRI;

#-------------------------------------------------------------------------------
subtest {
  is get-prefix('rdf'),
     'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
     'rdf prefix';

  set-prefix(local-name => 'file://Perl6/Projects/Rdf#');
  is get-prefix(), 'file://Perl6/Projects/Rdf#', 'default prefix';

}, 'Prefixes';

#-------------------------------------------------------------------------------
# Cleanup
#
done-testing();
exit(0);
