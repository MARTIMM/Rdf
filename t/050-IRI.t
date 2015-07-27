use v6;
use Test;

use Rdf;
use Rdf::Node-builder;

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Literal $l1 = Rdf::Node-builder.create('1920-10-23^^' ~ $Rdf::DATE);
  isa-ok $l1, 'Literal', 'l1 is Literal';
  is $l1.get-value,
     '1920-10-23^^http://www.w3.org/2001/XMLSchema#date',
     "IRI l1 = $l1";
  is $l1.get-type, $Rdf::NODE-LITERAL, "Type l1 = {$l1.get-type}";
}, 'Literal node';

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Blank $b1 = Rdf::Node-builder.create('_:x');
  isa-ok $b1, 'Blank', 'l1 is Blank';
  is "$b1", '_:x', 'Blank node 1 = _:x';
}, 'Blank node';

#-------------------------------------------------------------------------------
subtest {
  my Rdf::IRI $i1 = Rdf::Node-builder.create('file://Perl6/Projects/Rdf-xyz#abc');
  isa-ok $i1, 'IRI', 'i1 is IRI';
  is "$i1", 'file://Perl6/Projects/Rdf-xyz#abc', "{$i1.perl}";

  my Rdf::Node $i2 = Rdf::Node-builder.create('abc');
  nok ?$i2, "Node i2 not defined";

  prefix( local-name => 'file://Perl6/Projects/Rdf#' );
  $i2 = Rdf::Node-builder.create('abc');
  is "$i2", 'file://Perl6/Projects/Rdf#abc', "IRI i2 = $i2";

say "I: {$i2.perl}";
}, 'Iri node';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);


=finish
#-------------------------------------------------------------------------------
subtest {


  my Rdf::Node $i1 = Rdf::Node-builder.check-iri('abc');
say "$1";
  isa-ok $i1, 'IRI', 'i1 is IRI';
  is "$i1", 'file://Perl6/Projects/Rdf#abc', "IRI i1 = $i1";
  is $i1.get-type, $Rdf::NODE-IRI, "Iri type code is $Rdf::NODE-IRI";


  my Rdf::Node $i3 = Rdf::Node-builder.check-iri('file://Perl6/Projects/Rdf#abc');
  isa-ok $i3, 'IRI', 'i3 is IRI';
  is "$i3", 'file://Perl6/Projects/Rdf#abc', "IRI i3 = $i3";

  my Rdf::Node $i4 = Rdf::Node-builder.check-iri('def:abc');
  nok $i4, "IRI i4 = undefined";

  my Rdf::Node $i5 = Rdf::Node-builder.check-iri('_:abc');
  is $i5, '_:abc', "IRI i5 = $i5";

  my Rdf::Node $i6 = Rdf::Node-builder.check-iri('1920-10-23^^' ~ $Rdf::DATE);
  is $i6.get-value, '1920-10-23^^xsd:date', "IRI i6 = $i6";
  is $i6.get-type, '', "Type i6 = {$i6.get-type}";

}, 'Set and test iri';
