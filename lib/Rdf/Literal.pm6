use v6;
use Rdf;
use Rdf::Node;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    has Str $.lexical-form;
    has Str $.datatype;
    has Str $.language;

    #---------------------------------------------------------------------------
    # Explicit datatype
    # When $lexical-form is "some string" $datatype must be xsd:string
    # When $lexical-form is "some string"@lang-tag $datatype must be
    # rdf:langString.
    #
    multi submethod BUILD (
      Str :$lexical-form,
      Str :$datatype, # where $datatype ~~ any(@Rdf::RDF-TYPES),
      Str :$language
    ) {

      # If lixical form is a complete description then the datatype and
      # language are ignored
      #
      if $lexical-form ~~ m/ '^^' / {
        ( my $lform, my $datatype ) = $lexical-form.split(/'^^'/);
        if $lform ~~ m/ '@\w+' $ / {
          ( $lform, my $lang) = split(/'@'/);
          $!language = $lang.lc;
          if $datatype !~~ m/ 'langString' / {
            die "Datatype wrong for language tagged strings";
          }
        }

        $!lexical-form = $lform;
        $!datatype = full-iri($datatype);
      }

      # If language is given the datatype is langString and the data is text.
      # argument datatype is ignored.
      #
      elsif ?$language {
        $!language = $language.lc;
        $!lexical-form = $lexical-form;
        $!datatype = full-iri('rdf:langString');
      }

      # if a language is tagged onto the text then the datatype must be
      # langString if given.
      #
      elsif $lexical-form ~~ m/ '@' \w+ $ /
            and ?$datatype
            and $datatype ne 'rdf:langString' {
        die "Language string does not have proper datatype";
      }

      elsif $lexical-form ~~ m/ '@' (\w+) $ / {
        $!language = $/[0];
        $lexical-form ~~ s/ '@' (\w+) $ //;
      }
      
      elsif ?$datatype {
        $!lexical-form = $lexical-form;
        $!datatype = full-iri($datatype);
      }
      
      else {
        $!lexical-form = $lexical-form;
        $!datatype = full-iri('xsd:string');
      }

      my Str $value = $!lexical-form;   #   qq@"$!lexical-form"@;
      if $!language.defined {
        $value ~= "\@$!language";
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
    multi submethod BUILD ( Int :$lexical-form ) {
      $!lexical-form = $lexical-form.fmt('%s');
      $!datatype = full-iri('xsd:integer');

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
      return $!language;
    }
  }
}


=finish

    #---------------------------------------------------------------------------
    # Implicit datatype(xsd:string) or specified in full datatype IRI
    #
    multi submethod yBUILD ( Str :$lexical-form, Str :$lang-tag ) {

say "$lexical-form, $lang-tag";
      # Normalize to lowercase
      #
      if ?$lang-tag {
        $!language = $lang-tag.lc;
        $!lexical-form = $lexical-form;
        $!datatype = full-iri('rdf:langString');
      }

      # Check if this is a full specification of a literal
      #
      elsif $lexical-form ~~ m/ '^^' / {
        ( my $lform, my $datatype ) = $lexical-form.split(/'^^'/);
        if $lform ~~ m/ '@\w+' $ / {
          ( $lform, my $lang) = split(/'@'/);
          $!language = $lang.lc;
          if $datatype !~~ m/ 'langString' / {
            die "Datatype wrong for language tagged strings";
          }
        }
        
        $!lexical-form = $lform;
        $!datatype = full-iri($datatype);
say "$!lexical-form, $!datatype, $datatype";
      }

      else {
        $!lexical-form = $lexical-form;
        $!datatype = full-iri($Rdf::STRING);
      }

      # Strins and language tagged string don't need datatypes
      #
      my Str $value = $!lexical-form;
      if $!language.defined {
        $value ~= "\@$!language";
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
    multi submethod xBUILD ( Str :$lexical-form, Str :$lang-tag is copy ) {

      my $dt;
      
      # Normalize to lowercase
      #
      $lang-tag.lc if $lang-tag.defined;
      $dt =full-iri($Rdf::LANGSTRING) if $lang-tag.defined;
      $dt =full-iri($Rdf::STRING) unless $dt.defined;

      $!lexical-form = $lexical-form;
      $!datatype = $dt;
      $!language = $lang-tag if $lang-tag.defined;

      my Str $value = $!lexical-form;
      if $!language.defined {
        $value ~= "\@$!language";
      }

      elsif $!datatype !~~ 'xsd:string' {
        $value ~= "^^$!datatype";
      }

      self.set-value($value);
      self.set-short-value(short-iri($value));
      self.set-type($Rdf::NODE-LITERAL);
    }

