#!/usr/bin/env perl6

# See examples on https://code.google.com/p/tdwg-rdf/wiki/Beginners3RDFbasics
#
use v6;
use Rdf;
use Rdf::Rdf-tuple;

my Rdf::Rdf-tuple @tuples;

# Some prefixes
#
prefix(
  :prefix('kimage'),
  :local-name('http://bioimages.vanderbilt.edu/kirchoff/'));

prefix(
 :prefix('agents'),
 :local-name('http://bioimages.vanderbilt.edu/contact/'));

# The tuples
#
@tuples.push(
  my $agent = tuple( 'agents:kirchoff#cobles', $Rdf::TYPE, 'foaf:person'),
  tuple( $agent, 'foaf:name', 'Ashley Coble^^' ~ $Rdf::STRING),

  my $image = tuple( 'kimage:ac1490', $Rdf::TYPE, 'dcterms:StillImage'),
  tuple( $image, 'foaf:maker', $agent),
  tuple( $image, 'dcterms:created', '2010-09-01T03:41:31^^' ~ $Rdf::DATETIME),
  tuple( $image, 'dcterms:right', '(c) 2011 Bruce K. Kirchoff^^' ~ $Rdf::STRING),
);


say '';
for @tuples -> $tuple {
  say $tuple.subject.get-short-value.fmt('%-25s'),
      $tuple.predicate.get-short-value.fmt('%-20s'),
      $tuple.object.get-short-value.fmt('%-35s');
}
