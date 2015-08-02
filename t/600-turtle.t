use v6;
use Test;

use Rdf;
use Rdf::Turtle;

my Rdf::Turtle $t .= new;

#-------------------------------------------------------------------------------
my $status = $t.parse-file(:filename('lib/Rdf/Turtle/Turtle Code/22-rdf-syntax-ns'));
is ?$status, True, "Parse 22-rdf-syntax-ns ok";

#-------------------------------------------------------------------------------
# Cleanup
#
done();
exit(0);
