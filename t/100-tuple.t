use v6;
use Test;

use Rdf;
use Rdf::Triple;

set-prefix(local-name => 'file://Perl6/Projects/Rdf#');
set-base('http://example.com/');

my Rdf::Triple $t;

#-------------------------------------------------------------------------------
subtest {
  $t .= new( subject => '<a1>', predicate => '<b1>', object => '<c1>');
  is ~$t.subject, '<http://example.com/a1>', ~$t.subject;
  is $t.subject.get-short-value,
     'http://example.com/a1',
     $t.subject.get-short-value;
  is ~$t.predicate, '<http://example.com/b1>', ~$t.predicate;
  is ~$t.object, '<http://example.com/c1>', ~$t.object;

}, 'triple test base';

#-------------------------------------------------------------------------------
subtest {
  $t .= new( subject => ':Mary', predicate => 'rdf:type', object => 'foaf:person');
  is ~$t.subject, '<file://Perl6/Projects/Rdf#Mary>', ~$t.subject;
  is $t.subject.get-short-value, ':Mary', $t.subject.get-short-value;
  is ~$t.predicate,
     '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>',
     ~$t.predicate;
  is ~$t.object, '<http://xmlns.com/foaf/0.1/person>', ~$t.object;
  is $t.object.get-short-value, 'foaf:person', $t.object.get-short-value;

}, 'triple test several kinds of prefix handling';

#-------------------------------------------------------------------------------
subtest {
  $t .= new( subject => ':X', predicate => 'a', object => '<http://xmlns.com/foaf/0.1/person>');
  is ~$t.predicate,
     '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>',
     ~$t.predicate;
  is $t.predicate.get-short-value, 'rdf:type', $t.predicate.get-short-value;
  is $t.object.get-short-value, 'foaf:person', $t.object.get-short-value;

}, 'triple test of predicate \'a\' and full iri usage';

#-------------------------------------------------------------------------------
subtest {
  $t .= new( subject => '_:X', predicate => 'a', object => '_:Y');
  ok $t.subject.isa('Blank'), 'A blank node';

  is ~$t.subject, '_:X', ~$t.subject;
  is ~$t.object, '_:Y', ~$t.object;

  $t .= new( subject => '[]', predicate => 'a', object => '_:Y');
  is ~$t.subject, '_:BN_0001', ~$t.subject;
  
}, 'triple test blank nodes';

#-------------------------------------------------------------------------------
# Cleanup
#
done-testing();
exit(0);
