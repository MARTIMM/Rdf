use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;

#-------------------------------------------------------------------------------
my Match $status = $t.parse-file(
  :filename('lib/Rdf/Turtle/Turtle Code/22-rdf-syntax-ns')
);

ok $status.chunks.elems > 0,
   "Parse 22-rdf-syntax-ns matched elements {$status.list.elems}";

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
