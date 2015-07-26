use v6;
use Test;

use Rdf;
use Rdf::IRI;


#-------------------------------------------------------------------------------
subtest {
  is Rdf::IRI.get-prefix('rdf'), 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'rdf prefix';

  Rdf::IRI.prefix(local-name => 'file://Perl6/Projects/Rdf#');
  is Rdf::IRI.get-prefix(), 'file://Perl6/Projects/Rdf#', 'default prefix';
}, 'Prefixes';

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Node $i1 = Rdf::IRI.check-iri('abc');
  isa-ok $i1, 'IRI', 'i1 is IRI';
  is "$i1", 'file://Perl6/Projects/Rdf#abc', "IRI i1 = $i1";
  is $i1.get-type, $Rdf::NODE-IRI, "Iri type code is $Rdf::NODE-IRI";

  my Rdf::Node $i2 = Rdf::IRI.new(:iri('abc'));
  isa-ok $i2, 'IRI', 'i2 is IRI';
  is "$i2", 'abc', "IRI i2 = $i2";

  my Rdf::Node $i3 = Rdf::IRI.check-iri('file://Perl6/Projects/Rdf#abc');
  isa-ok $i3, 'IRI', 'i3 is IRI';
  is "$i3", 'file://Perl6/Projects/Rdf#abc', "IRI i3 = $i3";

  my Rdf::Node $i4 = Rdf::IRI.check-iri('def:abc');
  nok $i4, "IRI i4 = undefined";

  my Rdf::Node $i5 = Rdf::IRI.check-iri('_:abc');
  is $i5, '_:abc', "IRI i5 = $i5";

}, 'Set and test iri';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
