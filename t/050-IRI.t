use v6;
use Test;

use Rdf;
use Rdf::Node-builder;

#-------------------------------------------------------------------------------
set-base('file:///perl-tests/');
set-prefix( local-name => 'file://Perl6/Projects/Rdf#');
set-prefix( prefix => 'def', local-name => 'file://local-terms#');

subtest {
  my Rdf::IRI $i1 = Rdf::Node-builder.create('<file://Perl6/Projects/Rdf-xyz#abc>');
  isa-ok $i1, 'IRI', 'i1 is IRI';
  is ~$i1, 'file://Perl6/Projects/Rdf-xyz#abc', "Node i1: $i1";

  my Rdf::Node $i2 = Rdf::Node-builder.create('<abc>');
  is ~$i2, "file:///perl-tests/abc", "Node i2: $i2";

  my Rdf::Node $i3 = Rdf::Node-builder.create(':abc');
  is ~$i3, 'file://Perl6/Projects/Rdf#abc', "Node i3: $i3";

  my Rdf::Node $i4 = Rdf::Node-builder.create('def:abc');
  is ~$i4, 'file://local-terms#abc', "Node i4: $i4";

  my Rdf::Node $i5 = Rdf::Node-builder.create('x:abc');
  is ~$i5, 'http://martimm.github.io/Unknown-Prefix#abc', "Node i5: $i5";

}, 'Iri node';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);


=finish

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
