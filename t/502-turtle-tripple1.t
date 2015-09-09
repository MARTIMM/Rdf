use v6;
use Test;

use Rdf;
use Rdf::Turtle;
use Rdf::Rdf-tuple;

my Rdf::Turtle $t .= new;


#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  <a1> <b1> <c1> .

  <a2> <b2> <c2> ;
       <b3> <c3> .

  <a4> a <c4> .

  <a4> a <c4>, <c4a>, <c4b> .

  EOTURTLE

  my Match $status = $t.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

  is get-tuple-count(), 7, "Number of 3-tuples found is {get-tuple-count()}";

}, 'default relative triple';

done();
exit(0);

=finish

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @prefix owl: <http://www.w3.org/2002/07/owl#> .

  <a1> <b1> <c1> .
  <a2> <http://example.org/ns/b2> <c2> .

  <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  a  owl:Ontology .

  EOTURTLE

  my Match $status = $t.parse(:$content);
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

  my Match $status = $t.parse(:$content);
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

  my Match $status = $t.parse(:$content);
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

  my Match $status = $t.parse(:$content);
  ok $status ~~ Match, "Parse tuple ok";

}, 'triple with long text """';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
