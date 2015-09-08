use v6;
use Rdf;
use Rdf::Node;
use Rdf::Turtle::Grammar;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    has Str $.lexical-form;             # Value without quotes
    has Str $.datatype;                 # Short iri format
    has Str $.language;                     # Language without '@'

    #---------------------------------------------------------------------------
    # Explicit datatype
    # When $lexical-form is "some string" $datatype must be xsd:string
    # When $lexical-form is "some string"@lang-tag $datatype must be
    # rdf:langString.
    #
    submethod BUILD ( Str :$literal ) {
      
      # Language is not used for many data types
      #
      $!language = '';

say "Lit Q: ", $literal;
      # Test literal with parts from the turtle grammar
      #
      if $literal ~~ m/ ^ <Rdf::Turtle::Grammar::literal-text> $ / {
        my $l = $/<Rdf::Turtle::Grammar::literal-text>;
#
say "\nMatch: ", $l.perl;

        # Check for strings
        #
        if $l<quoted-string>:exists {
          $!lexical-form = ~$l<quoted-string>;
          $!lexical-form ~~ s/^ '"' //;
          $!lexical-form ~~ s/ '"' $//;

          # When language is defined, it will be in a list. This because
          # of the ()* in the regex
          #
          if ?$l.elems and $l[0]<language>:exists {
            $!language = ~$l[0]<language>;
            $!datatype = 'rdf:langString';
          }

          else {
            $!datatype = 'xsd:string';
          }

          my $quotes = $!lexical-form ~~ m/ \n / ?? '"""' !! '"';
          self!set-lv(:$quotes);
          self!set-sv(:$quotes);
        }

        # Check for data type strings
        #
        if $l<datatype-string>:exists {
          my $ds = ~$l<datatype-string>;

          ( my $lt, my $dt) = $ds.split('^^');
          $lt ~~ s/^ '"' //;
          $lt ~~ s/ '"' $//;

          $!datatype = self.short-iri(:full-iri($dt));
          $!lexical-form = $!datatype ~~ m/ 'double' /
                           ?? cleanup-double($lt)
                           !! $lt;
say "DTS: ~$l<datatype-string>, $!lexical-form, $!datatype";

          self!set-lv(:quotes('"'));
          self!set-sv(:quotes(''));
        }


        # Check for integers
        #
        if $l<integer>:exists {
          $!lexical-form = cleanup-integer(~$l<integer>);
          $!datatype = 'xsd:integer';

          self!set-lv(:quotes('"'));
          self!set-sv(:quotes(''));
        }
      }
    }

    #---------------------------------------------------------------------------
    #
    sub cleanup-double ( Str $text is copy --> Str ) {

      # Remove trailing zeros after '.' and before 'e'
      #
      if $text ~~ m/ '.' .*? 'e' / {
        $text ~~ s/ '0'+ 'e' /e/;
      }

      return cleanup-integer($text);
    }

    #---------------------------------------------------------------------------
    #
    sub cleanup-integer ( Str $text is copy --> Str ) {
      # Remove leading zeros and positive sign
      #
      my $neg = $text ~~ m/ ^ '-'/;
      $text ~~ s/^ <[0\-\+]>+ //;
      return ?$neg ?? '-' ~ $text !! $text;
    }

    #---------------------------------------------------------------------------
    #
    method !set-sv ( :$quotes = '"' ) {
      self.set-short-value(
        [~] $quotes,
        $!lexical-form,
        $quotes,
        (?$!language ?? "\@$!language" !! '')
      );
    }

    #---------------------------------------------------------------------------
    #
    method !set-lv ( :$quotes = '"' ) {
      self.set-value(
        [~] $quotes,
            $!lexical-form,
            $quotes,
            (?$!language ?? "\@$!language" !! ''),
            '^^',
            self.full-iri(:short-iri($!datatype))
      );
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
----

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
----
      # If lexical form is a complete description then the datatype and
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

--------------



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

