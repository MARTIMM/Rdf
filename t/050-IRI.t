use v6;
use Test;

use Rdf;
use Rdf::IRI;

#-------------------------------------------------------------------------------
set-base('file:///perl-tests/');
set-prefix( local-name => 'file://Perl6/Projects/Rdf#');
set-prefix( prefix => 'def', local-name => 'file://local-terms#');

subtest {
  my Rdf::IRI $i1 = Rdf::IRI.new(iri => '<file://Perl6/Projects/Rdf-xyz#abc>');
  isa-ok $i1, 'IRI', 'i1 is IRI';
  is ~$i1, '<file://Perl6/Projects/Rdf-xyz#abc>', "Node i1: $i1";
  is $i1.get-short-value(),
  'file://Perl6/Projects/Rdf-xyz#abc',
  "Node i1 short: {$i1.get-short-value()}";

  my Rdf::Node $i2 = Rdf::IRI.new(iri => '<abc>');
  is ~$i2, "<file:///perl-tests/abc>", "Node i2: $i2";
  is $i2.get-short-value(),
  'file:///perl-tests/abc',
  "Node i2 short: {$i2.get-short-value()}";

  my Rdf::Node $i3 = Rdf::IRI.new(iri => ':abc');
  is ~$i3, '<file://Perl6/Projects/Rdf#abc>', "Node i3: $i3";

  my Rdf::Node $i4 = Rdf::IRI.new(iri => 'def:abc');
  is ~$i4, '<file://local-terms#abc>', "Node i4: $i4";
  is $i4.get-short-value(), 'def:abc', "Node i4 short: {$i4.get-short-value()}";

  my Rdf::Node $i5 = Rdf::IRI.new(iri => 'x:abc');
  is ~$i5, '<http://martimm.github.io/Unknown-Prefix#abc>', "Node i5: $i5";
  is $i5.get-short-value(), 'x:abc', "Node i5 short: {$i5.get-short-value()}";

}, 'Iri node';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);

