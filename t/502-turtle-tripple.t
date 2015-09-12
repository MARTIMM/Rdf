use v6;
use Test;

use Rdf;
use Rdf::Turtle;
use Rdf::Triple;

my Rdf::Turtle $turtle .= new;
my Rdf::Triple $t .= new;

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://502-turtle-tripple/> .
  <a1> <b1> <c1> .

  <a2> <b2> <c2> ;
       <b3> <c3> .

  <a4> a <c4> .

  <a4> a <c4>, <c4a>, <c4b> .

  EOTURTLE

  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

  is $t.get-triple-count(),
     7,
     "Number of 3-tuples found is {$t.get-triple-count()}";

  $t.get-triple-from-index(2);
  is $t.subject.get-short-value(),
     'http://502-turtle-tripple/a2',
     "Subject: {$t.subject.get-short-value()}";
  is $t.predicate.get-short-value(),
     'http://502-turtle-tripple/b3',
     "Subject: {$t.predicate.get-short-value()}";
  is $t.object.get-short-value(),
     'http://502-turtle-tripple/c3',
     "Subject: {$t.object.get-short-value()}";
     
  $t.get-triple-from-index(6);
  is $t.subject.get-short-value(),
     'http://502-turtle-tripple/a4',
     "Subject: {$t.subject.get-short-value()}";
  is $t.predicate.get-short-value(),
     'rdf:type',
     "Subject: {$t.predicate.get-short-value()}";
  is $t.object.get-short-value(),
     'http://502-turtle-tripple/c4b',
     "Subject: {$t.object.get-short-value()}";

}, 'default relative triple';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://502-turtle-tripple/> .
  @prefix : <perl6#> .
  @prefix a: <local#> .

  <a1> a:b : .
  :t <http://example.org/ns/b2> a: .

  EOTURTLE

  # Init otherwise the number of triples will become 9 instead of two
  #
  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

  is $t.get-triple-count(),
     2,
     "Number of 3-tuples found is {$t.get-triple-count()}";

  $t.get-triple-from-index(0);
  is ~$t.predicate,
     '<http://502-turtle-tripple/local#b>',
     "Subject: {~$t.predicate}";
  is ~$t.object,
     '<http://502-turtle-tripple/perl6#>',
     "Subject: {~$t.object}";

  $t.get-triple-from-index(1);
  is ~$t.subject,
     '<http://502-turtle-tripple/perl6#t>',
     "Subject: {~$t.subject}";

}, 'prefix handling';

done();
exit(0);

=finish

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
