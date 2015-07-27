use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    has Str $.form;
    has Str $.datatype;
    has Str $.lang-tag;

    #---------------------------------------------------------------------------
    # Explicit datatype
    #
    multi submethod BUILD (
      Str :$form,
      Str :$datatype where $datatype ~~ any(@Rdf::RDF-TYPES),
    ) {
      $!form = $form;
      $!datatype = full-iri($datatype);

      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Implicit datatype(xsd:string)
    #
    multi submethod BUILD ( Str :$form is copy ) {

      # Check if this is a full specification of a literal
      #
      if $form ~~ m/ '^^' / {
        ( my $lform, my $datatype ) = $form.split(/'^^'/);
        if $lform ~~ m/ '@\w+' $ / {
          ( $lform, my $ltag) = split(/'@'/);
          $!lang-tag = $ltag.lc;
          if $datatype !~~ m/ 'http://www.w3.org/1999/02/22-rdf-syntax-ns#langString' / {
            die "Datatype wrong for language tagged strings";
          }
        }
        
        $!form = $lform;
        $!datatype = full-iri($datatype);
      }

      else {
        $!form = $form;
        $!datatype = full-iri($Rdf::STRING);
      }

      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Implicit datatype(xsd:string) or datatype('rdf:langString')
    #
    multi submethod xBUILD ( Str :$form is copy, Str :$lang-tag is copy ) {

      my Rdf::IRI $dt;
      
      # Check if this is a full specification of a literal
      #
      if $form ~~ m/ '^^' / and ! $lang-tag.defined {
        ( my $lform, my $datatype ) = $form.split(/'^^'/);
        if $lform ~~ m/ '@\w+' $ / {
          ( $lform, my $ltag) = split(/'@'/);
          $!lang-tag = $ltag.lc;
        }

        $!form = $lform;
        $!datatype .= check-iri($datatype);
      }

      else {
        # Normalize to lowercase
        #
        $lang-tag.lc if $lang-tag.defined;
        $dt .= check-iri($Rdf::LANGSTRING) if $lang-tag.defined;
        $dt .= check-iri($Rdf::STRING) unless $dt.defined;

        $!form = $form;
        $!datatype = $dt;
        $!lang-tag = $lang-tag if $lang-tag.defined;
      }

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
    method get-value ( --> Str ) {

      my Str $value = $!form;
      if $!lang-tag.defined {
        $value ~= "\@$!lang-tag";
      }

      elsif $!datatype !~~ 'xsd:string' {
        $value ~= "^^$!datatype";
      }

      return $value;
    }

    #---------------------------------------------------------------------------
    #
    multi method Str ( --> Str ) { return self.get-value; }
  }
}


=finish

    #---------------------------------------------------------------------------
    # Shortcuts
    # new( :$form, :datatype('xsd:integer'))
    #
    multi submethod xBUILD ( Int :$form ) {
      $!form = $form.fmt('%s');
      $!datatype .= check-iri('xsd:integer');

      self.set-type($Rdf::NODE-LITERAL);
    }

