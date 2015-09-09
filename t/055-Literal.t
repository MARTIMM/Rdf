use v6;
use Test;

use Rdf;
use Rdf::Literal;

my Rdf::Literal $lit;

# See also http://www.w3.org/TR/rdf11-concepts/
#-------------------------------------------------------------------------------
subtest {
  $lit .= new(:literal('001.30e6'));
  is $lit.get-value(),
     '"1.3e6"^^<http://www.w3.org/2001/XMLSchema#double>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), '1.3e6', "Lit short: {$lit.get-short-value()}";

}, 'literal double';

#-------------------------------------------------------------------------------
subtest {
  $lit .= new(:literal('03.10'));
  is $lit.get-value(),
     '"3.1"^^<http://www.w3.org/2001/XMLSchema#decimal>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), '3.1', "Lit short: {$lit.get-short-value()}";

}, 'literal decimal';

#-------------------------------------------------------------------------------
subtest {
  $lit .= new(:literal('-0010'));
  is $lit.get-value(),
     '"-10"^^<http://www.w3.org/2001/XMLSchema#integer>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), '-10', "Lit: {$lit.get-short-value()}";

}, 'literal integer';

#-------------------------------------------------------------------------------
subtest {
  $lit .= new(:literal('true'));
  is $lit.get-value(),
     '"true"^^<http://www.w3.org/2001/XMLSchema#boolean>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), 'true', "Lit: {$lit.get-short-value()}";
  $lit .= new(:literal('false'));
  is $lit.get-value(),
     '"false"^^<http://www.w3.org/2001/XMLSchema#boolean>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), 'false', "Lit: {$lit.get-short-value()}";

}, 'literal boolean';

#-------------------------------------------------------------------------------
subtest {
  $lit .= new(:literal('"-03.10e50"^^xsd:double'));
  is $lit.get-value(),
     '"-3.1e50"^^<http://www.w3.org/2001/XMLSchema#double>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), '-3.1e50', "Lit short: {$lit.get-short-value()}";

}, 'literal datatype string';

#-------------------------------------------------------------------------------
subtest {
  $lit .= new(:literal('"abcdef"'));
  ok $lit.isa('Literal'), 'Test object type';
  is $lit.get-value(),
     '"abcdef"^^<http://www.w3.org/2001/XMLSchema#string>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), '"abcdef"', "Lit: {$lit.get-short-value()}";

  $lit .= new(:literal('"abcdef"@nl'));
  is $lit.get-value(),
     '"abcdef"@nl^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#langString>',
     "Lit: {$lit.get-value()}";
  is $lit.get-short-value(), '"abcdef"@nl', "Lit short: {$lit.get-short-value()}";

}, 'literal string';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);


=finish
#-------------------------------------------------------------------------------
subtest {
  my Rdf::Literal $l1 = Rdf::Node-builder.create('1920-10-23^^xsd:date');
  isa-ok $l1, 'Literal', 'l1 is Literal';
  is $l1.get-value,
     '1920-10-23^^<http://www.w3.org/2001/XMLSchema#date>',
     "IRI l1 = $l1";
  is $l1.get-type, $Rdf::NODE-LITERAL, "Type l1 = {$l1.get-type}";
}, 'Literal node';


