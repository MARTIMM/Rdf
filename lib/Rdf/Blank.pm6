use v6;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Blank is Rdf::Node {
  
    my Int $anonymous-count = 1;

    #---------------------------------------------------------------------------
    #
    submethod BUILD ( Str :$blank is copy ) {
      if $blank eq '[]' {
        $blank = $anonymous-count.fmt('_:BN_%04d');
        $anonymous-count++;
      }

      self.set-value($blank);
      self.set-short-value($blank);
    }
  }
}
