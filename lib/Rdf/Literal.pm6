use v6;
use Rdf;
use Rdf::Node;
use Rdf::Turtle::Grammar;

package Rdf {

  #-----------------------------------------------------------------------------
  #
  class Literal is Rdf::Node {

    has Str $.lexical-form;             # Value with quotes if string
    has Str $.datatype;                 # Short iri format
    has Str $.language;                 # Language without '@'

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

#say "Lit Q: '$literal'";
      # Test literal with parts from the turtle grammar
      #
      if $literal ~~ m:s/^ <Rdf::Turtle::Grammar::literal-text> $/ {
        my $l = $/<Rdf::Turtle::Grammar::literal-text>;
#        my $l = $literal;
#say "Lit L: ", $l.perl;

        # Check for integers
        #
        if $l<double>:exists {
          $!lexical-form = cleanup-double(~$l<double>);
          $!datatype = 'xsd:double';

          self!set-lv(:quotes('"'));
          self!set-sv(:quotes(''));
#say "Lit double: ", self.get-value;
        }


        elsif $l<decimal>:exists {
          $!lexical-form = cleanup-decimal(~$l<decimal>);
          $!datatype = 'xsd:decimal';

          self!set-lv(:quotes('"'));
          self!set-sv(:quotes(''));
#say "Lit decimal: ", self.get-value;
        }


        elsif $l<integer>:exists {
          $!lexical-form = cleanup-integer(~$l<integer>);
          $!datatype = 'xsd:integer';

          self!set-lv(:quotes('"'));
          self!set-sv(:quotes(''));
#say "Lit integer: ", self.get-value;
        }


        elsif $l<boolean>:exists {
          $!lexical-form = ~$l<boolean>;
          $!datatype = 'xsd:boolean';

          self!set-lv(:quotes('"'));
          self!set-sv(:quotes(''));
#say "Lit boolean: ", self.get-value;
        }


        # Check for data type strings
        #
        elsif $l<datatype-string>:exists {
          my $ds = ~$l<datatype-string>;

          ( my $lt, my $dt) = $ds.split('^^');
          $lt ~~ s/^ '"' //;
          $lt ~~ s/ '"' $//;

          $!datatype = self.short-iri(:full-iri($dt));
          $!lexical-form = $!datatype ~~ m/ 'double' /
                           ?? cleanup-double($lt)
                           !! $lt;

          self!set-lv(:quotes('"'));
#          self!set-lv(:quotes(''));
          self!set-sv(:quotes(''));
#say "Lit datatype string: ", self.get-value;
        }


        # Check for strings
        #
        elsif $l<quoted-string>:exists {
          $!lexical-form = ~$l<quoted-string>;
#          $!lexical-form ~~ s/^ '"' //;
#          $!lexical-form ~~ s/ '"' $//;

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

#          my $quotes = $!lexical-form ~~ m/ \n / ?? '"""' !! '"';
#          self!set-lv(:$quotes);
#          self!set-sv(:$quotes);
          self!set-lv(:quotes(''));
          self!set-sv(:quotes(''));
#say "Lit quoted string: ", self.get-value;
        }
      }

      # Literal expression not recognized
      #
      else {
#say "\nMatch: ", $/.perl;
        note "Literal expression '$literal' not supported";
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
    sub cleanup-decimal ( Str $text is copy --> Str ) {

      # Remove trailing zeros after '.' and before the end
      #
      if $text ~~ m/ '.' .*? $/ {
        $text ~~ s/ '0'+ $//;
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

