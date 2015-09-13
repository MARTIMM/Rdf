use v6;
use Test;

use Rdf;
use Rdf::Turtle;
use Rdf::Triple;

my Rdf::Turtle $turtle .= new;
my Rdf::Triple $t .= new;

#-------------------------------------------------------------------------------
if 0 {
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://503-turtle-tripple/> .
  @prefix : <perl6#> .

  [] <b1> <c1> .

  EOTURTLE

  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

  is $t.get-triple-count(),
     1,
     "Number of 3-tuples found is {$t.get-triple-count()}";

  $t.get-triple-from-index(0);
  is $t.subject.get-short-value(),
     '_:BN_0001',
     "Subject: {$t.subject.get-short-value()}";

}, 'simple blank node in triples';
}
#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://503-turtle-tripple/> .
  @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  @prefix : <perl6#> .

  [ a foaf:Person ; foaf:name "Alice" ] foaf:knows _:b .

  EOTURTLE

  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

  is $t.get-triple-count(),
     3,
     "Number of 3-tuples found is {$t.get-triple-count()}";

  for ^3 -> $idx {
    $t.get-triple-from-index($idx);
    is ~$t.subject, '_:BN_0001', "Subject: {~$t.subject}";
  }

}, 'complex blank nodes';

done();
exit(0);

=finish

  is $t.get-triple-count(),
     1,
     "Number of 3-tuples found is {$t.get-triple-count()}";

  $t.get-triple-from-index(0);
  is $t.subject.get-short-value(),
     'http://502-turtle-tripple/a2',
     "Subject: {$t.subject.get-short-value()}";
  is $t.predicate.get-short-value(),
     'http://502-turtle-tripple/b3',
     "Subject: {$t.predicate.get-short-value()}";
  is $t.object.get-short-value(),
     'http://502-turtle-tripple/c3',
     "Subject: {$t.object.get-short-value()}";

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @prefix owl: <http://www.w3.org/2002/07/owl#> .

  <a1> <b1> <c1> .
  <a2> <http://example.org/ns/b2> <c2> .

  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  a  owl:Ontology .

  EOTURTLE

  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

}, 'simple triples';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @prefix owl: <http://www.w3.org/2002/07/owl#> .

  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  a  owl:Ontology ;
	dc:title "The RDF Concepts Vocabulary (RDF)" ;
	dc:description "This is the RDF Schema for the RDF vocabulary terms in the RDF Namespace, defined in RDF 1.1 Concepts." .

  EOTURTLE

  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

}, 'triple with \';\'';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @prefix owl: <http://www.w3.org/2002/07/owl#> .

  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  a  owl:Ontology ,
                                                    <test-case>;
	dc:title "The RDF Concepts Vocabulary (RDF)" ;
	dc:description "This is the RDF Schema for the RDF vocabulary terms in the RDF Namespace, defined in RDF 1.1 Concepts." .

  EOTURTLE

  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

}, 'triple with \',\'';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @prefix owl: <http://www.w3.org/2002/07/owl#> .

  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  a  owl:Ontology ,
                                                    <test-case>;
	dc:title "The RDF Concepts Vocabulary (RDF)" ;
	dc:description
          """This is the RDF Schema for the RDF vocabulary terms in the RDF
          Namespace, defined in RDF 1.1 Concepts.""" .

  EOTURTLE

  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

}, 'triple with long text """';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
