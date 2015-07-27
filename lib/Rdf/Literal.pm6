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
    # Explicit datatype
    #
    multi submethod BUILD (
      Str :$form,
      Str :$datatype where $datatype ~~ any(@Rdf::RDF-TYPES),
    ) {
      my Rdf::IRI $dt .= check-iri($datatype);

      # Check data type

      # Check language tag

      $!form = $form;
      $!datatype = $dt;

      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Implicit datatype(xsd:string) or datatype('rdf:langString')
    #
    multi submethod BUILD ( Str :$form, Str :$lang-tag is copy ) {

      # Normalize to lowercase
      #
      $lang-tag.lc if $lang-tag.defined;
      my Rdf::IRI $dt .= check-iri($Rdf::LANGSTRING) if $lang-tag.defined;
      $dt .= check-iri($Rdf::STRING) unless $dt.defined;

      $!form = $form;
      $!datatype = $dt;
      $!lang-tag = $lang-tag if $lang-tag.defined;

      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Shortcuts
    # new( :$form, :datatype('xsd:integer'))
    #
    multi submethod BUILD ( Int :$form ) {
      $!form = $form.fmt('%s');
      $!datatype .= check-iri('xsd:integer');

      self.set-type($Rdf::NODE-LITERAL);
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

      elsif $!datatype !~~ Rdf::IRI.check-iri('xsd:string') {
        $value ~= "^^$!datatype";
      }

      return $value;
    }
  }
}
