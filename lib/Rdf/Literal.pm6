use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    has Str $.lexical-form;
    has Str $.datatype;
    has Str $.lang-tag;

    #---------------------------------------------------------------------------
    # Explicit datatype
    # When $lexical-form is "some string" $datatype must be xsd:string
    # When $lexical-form is "some string"@lang-tag $datatype must be
    # rdf:langString.
    #
    multi submethod BUILD (
      Str :$lexical-form,
      Str :$datatype where $datatype ~~ any(@Rdf::RDF-TYPES),
    ) {

      if $lexical-form ~~ m/ '@' \w+ $ / and $datatype ne $Rdf::LANGSTRING {
        die "Language string does not have proper datatype";
      }

      if $lexical-form ~~ m/ '@' (\w+) $ / {
        $!lang-tag = $/[0];
      }

      $!lexical-form = $lexical-form;
      $!datatype = Rdf::Rdf-Tools.full-iri($datatype);

      my Str $value = $!lexical-form;   #   qq@"$!lexical-form"@;
      if $!lang-tag.defined {
        $value ~= "\@$!lang-tag^^" ~ $datatype;
      }

      elsif $!datatype !~~ 'xsd:string' {
        $value ~= "^^$!datatype";
      }

      self.set-value($value);
      self.set-short-value(short-iri($value));
      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Implicit datatype(xsd:string) or specified in full datatype IRI
    #
    multi submethod BUILD ( Str :$lexical-form ) {

      # Check if this is a full specification of a literal
      #
      if $lexical-form ~~ m/ '^^' / {
        ( my $lform, my $datatype ) = $lexical-form.split(/'^^'/);
        if $lform ~~ m/ '@\w+' $ / {
          ( $lform, my $ltag) = split(/'@'/);
          $!lang-tag = $ltag.lc;
          if $datatype !~~ m/ 'http://www.w3.org/1999/02/22-rdf-syntax-ns#langString' / {
            die "Datatype wrong for language tagged strings";
          }
        }
        
        $!lexical-form = $lform;
        $!datatype = full-iri($datatype);
      }

      else {
        $!lexical-form = $lexical-form;
        $!datatype = Rdf::Rdf-Tools.full-iri($Rdf::STRING);
      }

      my Str $value = $!lexical-form;
      if $!lang-tag.defined {
        $value ~= "\@$!lang-tag";
      }

      elsif $!datatype !~~ 'xsd:string' {
        $value ~= "^^$!datatype";
      }

      self.set-value($value);
      self.set-short-value(short-iri($value));
      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Implicit datatype(xsd:string) or datatype('rdf:langString')
    #
    multi submethod BUILD ( Str :$lexical-form, Str :$lang-tag is copy ) {

      my $dt;
      
      # Normalize to lowercase
      #
      $lang-tag.lc if $lang-tag.defined;
      $dt = Rdf::Rdf-Tools.full-iri($Rdf::LANGSTRING) if $lang-tag.defined;
      $dt = Rdf::Rdf-Tools.full-iri($Rdf::STRING) unless $dt.defined;

      $!lexical-form = $lexical-form;
      $!datatype = $dt;
      $!lang-tag = $lang-tag if $lang-tag.defined;

      my Str $value = $!lexical-form;
      if $!lang-tag.defined {
        $value ~= "\@$!lang-tag";
      }

      elsif $!datatype !~~ 'xsd:string' {
        $value ~= "^^$!datatype";
      }

      self.set-value($value);
      self.set-short-value(short-iri($value));
      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    # Shortcuts
    # new( :$lexical-form, :datatype('xsd:integer'))
    #
    multi submethod xBUILD ( Int :$lexical-form ) {
      $!lexical-form = $lexical-form.fmt('%s');
      $!datatype = Rdf::Rdf-Tools.full-iri('xsd:integer');

      self.set-value($!lexical-form ~ '^^' ~ $!datatype);
      self.set-short-value(short-iri($!lexical-form ~ '^^' ~ $!datatype));
      self.set-type($Rdf::NODE-LITERAL);
    }

    #---------------------------------------------------------------------------
    #
    method get-form ( ) {
      return $!lexical-form;
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
  }
}


=finish

