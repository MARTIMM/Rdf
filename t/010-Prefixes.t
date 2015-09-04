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
subtest {
  is full-iri('xsd:string'),
     'http://www.w3.org/2001/XMLSchema#string',
     "{full-iri('xsd:string')}";

  is full-iri('abc'),
     'file://Perl6/Projects/Rdf#abc',
     "{full-iri('abc')}";

  is full-iri('xyz:abc'),
     Str,
     "'xyz:abc' not translated";

  set-prefix(
    prefix => 'xyz',
    local-name => 'file://Perl6/Projects/Rdf-xyz#'
  );
  is full-iri('xyz:abc'),
     'file://Perl6/Projects/Rdf-xyz#abc',
     "{full-iri('xyz:abc')}";
}, 'convert iri';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
