use v6;
use Test;

use Rdf;
use Rdf::Rdf-tuple;

set-prefix(local-name => 'file://Perl6/Projects/Rdf#');
set-base('http://example.com/');

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Rdf-tuple $t = tuple( '<a1>', '<b1>', '<c1>');
  is $t.subject.get-value, 'http://example.com/a1', $t.subject.get-value;
  is $t.subject.get-short-value,
     'http://example.com/a1',
     $t.subject.get-short-value;
  is $t.predicate.get-value,
     'http://example.com/b1',
     $t.predicate.get-value;
  is $t.object.get-value,
     'http://example.com/c1',
     $t.object.get-value;

}, 'tuple test base';

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Rdf-tuple $t = tuple( ':Mary', 'rdf:type', 'foaf:person');
  is $t.subject.get-value, 'file://Perl6/Projects/Rdf#Mary', $t.subject.get-value;
  is $t.subject.get-short-value, ':Mary', $t.subject.get-short-value;
  is $t.predicate.get-value,
     'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
     $t.predicate.get-value;
  is $t.object.get-value,
     'http://xmlns.com/foaf/0.1/person',
     $t.object.get-value;
  is $t.object.get-short-value, 'foaf:person', $t.object.get-short-value;

}, 'tuple test several kinds of prefix handling';

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Rdf-tuple $t = tuple( ':X', 'a', '<http://xmlns.com/foaf/0.1/person>');
  is $t.predicate.get-value,
     'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
     $t.predicate.get-value;
  is $t.predicate.get-short-value, 'rdf:type', $t.predicate.get-short-value;
  is $t.object.get-short-value, 'foaf:person', $t.object.get-short-value;

}, 'tuple test of predicate \'a\' and full iri usage';

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Rdf-tuple $t = tuple( '_:X', 'a', '_:Y');
  ok $t.subject.isa('Blank'), 'A blank node';

  is $t.subject.get-value, '_:X', $t.subject.get-value;
  is $t.object.get-value, '_:Y', $t.object.get-value;

}, 'tuple test blank nodes';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
