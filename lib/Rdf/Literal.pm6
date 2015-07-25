use v6;
use Rdf;
use Rdf::IRI;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    has Str $.form;
    has Rdf::IRI $.datatype;
    has Str $.lang-tag;

    #---------------------------------------------------------------------------
    #
    multi submethod BUILD ( Str :$form, Str :$datatype, Str :$lang-tag is copy ) {

      # Normalize to lowercase
      #
      $lang-tag.lc if $lang-tag.defined;

      my Rdf::IRI $dt .= check-iri($datatype) if $datatype.defined;
      $dt .= check-iri('xs:langString') if $lang-tag.defined;
      $dt .= check-iri('xs:string') unless $dt.defined;

      # Check data type

      # Check language tag

      $!form = $form;
      $!datatype = $dt;
      $!lang-tag = $lang-tag if $lang-tag.defined;

      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Shortcuts
    #
    multi submethod BUILD ( Int :$form ) {
      $!form = $form.fmt('%s');
      $!datatype .= check-iri('xs:integer');
    }

    #---------------------------------------------------------------------------
    #
    method get-form ( ) {
      return $!form;
    }

    #---------------------------------------------------------------------------
    #
    method get-datatype ( ) {
      return $!datatype;
    }

    #---------------------------------------------------------------------------
    #
    method get-lang-tag ( ) {
      return $!lang-tag;
    }

    #---------------------------------------------------------------------------
    #
    method get-value ( ) {

      my $value = $!form;
      if $!lang-tag.defined {
        $value ~= "\@$!lang-tag";
      }

      elsif $!datatype !~~ Rdf::IRI.check-iri('xs:string') {
        $value ~= "^^$!datatype";
      }

      return $value;
    }
  }
}
