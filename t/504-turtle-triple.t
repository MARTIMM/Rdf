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

  @base <http://503-turtle-tripple/> .
  @prefix : <perl6#> .

  (:a :b) <b1> <c1> .

  EOTURTLE

  my Array $short-names = [
    [<_:BN_0001 http://503-turtle-tripple/b1 http://503-turtle-tripple/c1>],
  ];

  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status.orig(), "Parse tuple ok";

  test-triples( 1, $t, $short-names);

}, 'simple blank node in triples';


done();
exit(0);

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://503-turtle-tripple/> .
  @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  @prefix : <perl6#> .

  [ a foaf:Person ; foaf:name "Alice" ] foaf:knows _:b .

  EOTURTLE

  my Array $short-names = [
    [<_:BN_0001         rdf:type        foaf:Person>],
    [<_:BN_0001         foaf:name       "Alice">],
    [<_:BN_0001         foaf:knows      _:b>],
  ];

  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status.orig(), "Parse tuple ok";

  test-triples( 3, $t, $short-names);

}, 'complex blank nodes on subject';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://503-turtle-tripple/> .
  @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  @prefix : <perl6#> .

  _:a foaf:knows [ a foaf:Person ; foaf:name "Alice" ] .

  EOTURTLE

  my Array $short-names = [
    [<_:BN_0001         rdf:type        foaf:Person>],
    [<_:BN_0001         foaf:name       "Alice">],
    [<_:a               foaf:knows      _:BN_0001>],
  ];

  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status.orig(), "Parse tuple ok";

  test-triples( 3, $t, $short-names);

}, 'complex blank nodes on object';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://503-turtle-tripple/> .
  @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  @prefix : <perl6#> .

  # _:BN_0001   foaf:name       "Tom" .
  # _:BN_0002   foaf:name       "Mary" .
  # _:BN_0001   foaf:knows      _:BN_0002 .
  # _:BN_0001   foaf:knows      _:a .
  #
  [ foaf:name "Tom";
    foaf:knows [ foaf:name "Mary" ]
  ] foaf:knows _:a .

  EOTURTLE

  my Array $short-names = [
    [<_:BN_0001   foaf:name       "Tom">],
    [<_:BN_0002   foaf:name       "Mary">],
    [<_:BN_0001   foaf:knows      _:BN_0002>],
    [<_:BN_0001   foaf:knows      _:a>],
  ];
  
  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status.orig(), "Parse tuple ok";

  test-triples( 4, $t, $short-names);

}, 'nested blank nodes on subject';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://503-turtle-tripple/> .
  @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  @prefix : <perl6#> .

  _:x foaf:knows [ foaf:name "Tom";
                   foaf:knows [ foaf:name "Mary" ]
                 ] .

  EOTURTLE

  my Array $short-names = [
    [<_:BN_0001   foaf:name       "Tom">],
    [<_:BN_0002   foaf:name       "Mary">],
    [<_:BN_0001   foaf:knows      _:BN_0002>],
    [<_:x         foaf:knows      _:BN_0001>],
  ];
  
  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status.orig(), "Parse tuple ok";

  test-triples( 4, $t, $short-names);

}, 'nested blank nodes on object';

#-------------------------------------------------------------------------------
subtest {
  my Str $content = qq:to/EOTURTLE/;

  @base <http://503-turtle-tripple/> .
  @prefix foaf: <http://xmlns.com/foaf/0.1/> .
  @prefix : <perl6#> .

  [ foaf:name "Chris" ;
    foaf:knows [ foaf:name "Mary" ]
  ] foaf:knows [ foaf:name "Tom";
                 foaf:knows [ foaf:name "Mary" ]
               ] .

  EOTURTLE

  my Array $short-names = [
    [<_:BN_0001   foaf:name       "Chris">],
    [<_:BN_0002   foaf:name       "Mary">],
    [<_:BN_0001   foaf:knows      _:BN_0002>],
    [<_:BN_0003   foaf:name       "Tom">],
    [<_:BN_0004   foaf:name       "Mary">],
    [<_:BN_0003   foaf:knows      _:BN_0004>],
    [<_:BN_0001   foaf:knows      _:BN_0003>],
  ];

  $t.init-triples;
  my Match $status = $turtle.parse(:$content);
  ok $status.orig(), "Parse tuple ok";

  test-triples( 7, $t, $short-names);

}, 'nested blank nodes on subject and object';


#-------------------------------------------------------------------------------
# Test triples
#
sub test-triples ( Int $n-triples, Rdf::Triple $t, Array $short-names ) {

  is $t.get-triple-count(),
     $n-triples,
     "Number of 3-tuples found is {$t.get-triple-count()}";

  for ^ $t.get-triple-count() -> $idx {
    $t.get-triple-from-index($idx);

    is $t.subject.get-short-value(),
       $short-names[$idx][0],
       "Subject: {~$t.subject}";

    is $t.predicate.get-short-value(),
       $short-names[$idx][1],
       "Predicate: {~$t.predicate}";

    is $t.object.get-short-value(),
       $short-names[$idx][2],
       "Object: {~$t.object}";
  }
}

#-------------------------------------------------------------------------------
# Cleanup
#
done-testing();
exit(0);

=finish

  my Array $short-names = [
    [<>],
    [<>],
    [<>],
    [<>],
  ];
