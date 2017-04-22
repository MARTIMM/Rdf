#!/usr/bin/env perl6

# See examples on https://code.google.com/p/tdwg-rdf/wiki/Beginners3RDFbasics
#
use v6;
use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;

$t.parse( content => qq:to/EOTURTLE/ );

<a1> <b1> <c1> .

@base <file://projects/rdf/> .

<a2> <b2> <c2> .

@prefix kimage:         <http://bioimages.vanderbilt.edu/kirchoff/> .
@prefix agents:         <http://bioimages.vanderbilt.edu/contact/> .

kimage:abc      rdf:type        foaf:person .

@prefix :               <file://test/rdf#> .
:abc            rdf:type        :def .

:length         rdf:isa         "10"^^rdf:integer .
:size           rdf:isa         2.2 .
:width          rdf:isa         25.345e10 .

EOTURTLE


say "\nDocument Base: $*PROGRAM-NAME\nP: ", get-prefix('kimage');

say "\nF1: ", full-iri('kimage:ac1490');
say "F2: ", full-iri('dcterms:created');
say "F3: ", full-iri('agents:kirchoff#cobles');
say "F4: ", full-iri('abc');
