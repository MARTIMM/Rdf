use v6;
use Test;

use Rdf;
use Rdf::Literal;

#-------------------------------------------------------------------------------
subtest {
  my Rdf::Literal $lit;

  $lit .= new( :form('10'), :datatype('xsd:long'));
  is $lit.get-value,
     '10^^http://www.w3.org/2001/XMLSchema#long',
     "Value is '{$lit.get-value}'";

  $lit .= new( :form('78'), :datatype($Rdf::SHORT));
  is $lit.get-value,
     '78^^http://www.w3.org/2001/XMLSchema#short',
     "Value is '{$lit.get-value}'";

  $lit .= new( :form([~] '1957', '^^', $Rdf::GYEAR));
  is $lit.get-value,
     '1957^^http://www.w3.org/2001/XMLSchema#gYear',
     "Value is '{$lit.get-value}'";

  $lit .= new(:form(11));
  is $lit.get-value,
     '11^^http://www.w3.org/2001/XMLSchema#integer',
     "Value is '{$lit.get-value}'";

  $lit .= new( :form('hooperde poop'));
  is $lit.get-value,
     'hooperde poop^^http://www.w3.org/2001/XMLSchema#string',
     "Value is '{$lit.get-value}'";

  $lit .= new( :form('hoeperde poep'), :lang-tag('nl'));
  is $lit.get-form, 'hoeperde poep', "Form is '{$lit.get-form}'";
  is $lit.get-datatype.Str, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#langString', "Datatype is {$lit.get-datatype.Str}";
  is $lit.get-lang-tag, 'nl', 'Language tag is nl';
  is $lit.get-value, 'hoeperde poep@nl', "Value is '{$lit.get-value}'";

}, 'literal';

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
