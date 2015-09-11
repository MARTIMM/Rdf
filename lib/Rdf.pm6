use v6;
use File::HomeDir;
use HTTP::UserAgent;
#use Rdf::Turtle;               # Circular loading Rdf!

package Rdf:ver<0.3.1>:auth<https://github.com/MARTIMM> {

  #-----------------------------------------------------------------------------
  # Setup program-name. Path leading to the name of the program is removed.
  #
  my $program-name = $*PROGRAM-NAME;
  $program-name ~~ s:g/ .*? <?before '/'> //;
  $program-name ~~ s/ ^^ '/' //;

  #-----------------------------------------------------------------------------
  # Setup the home directory for this program
  #
  my $home-dir = File::HomeDir.my_home;
if 0 { # Not yet useful
  my $pname = "$home-dir/.Turtle/" ~ $program-name;
  $pname ~~ s/\.          # Start with the dot
              <-[.]>+     # Then no dot may appear after that
              $           # til the end
             //;          # Remove found extention

  mkdir( $pname, :8<755>) unless $pname.IO ~~ :d;
  our $home-dir-path = "$pname/";
}

  #-----------------------------------------------------------------------------
  # Setup the turtle cache directory
  #
  our $turtle-cache = "$home-dir/.Turtle/Cache/";
  mkdir( $turtle-cache, :8<755>) unless $turtle-cache.IO ~~ :d;

  #-----------------------------------------------------------------------------
  # Setup the base url for this application. Can be modified later.
  #
  my $base;
  if !$base.defined {
    $base = [~] 'file:///', $home-dir, '/', $program-name;
    $base ~~ s/ '.' <-[.]>+ $ //;
    $base ~= '/';
#say "Base at start: $base";
  }

  else {
#say "Base defined as: $base";
  }

  # Array of types to check for
  #
  our @RDF-TYPES;

  #-----------------------------------------------------------------------------
  # Prefixes are visible in every OWL object;
  #
  our $prefixes = Hash.new();

  # Set some known prefixes with their iri
  #
  if ! $prefixes.keys {
    $prefixes<__Unknown_Prefix__ rdf rdfs xsd foaf schema dcterms wd> = @(
      'http://martimm.github.io/Unknown-Prefix#',
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#', # rdf
      'http://www.w3.org/2000/01/rdf-schema#',       # rdfs
      'http://www.w3.org/2001/XMLSchema#',           # xsd      data types
      'http://xmlns.com/foaf/0.1/',                  # foaf     social network
      'http://schema.org/',                          # schema
      'http://purl.org/dc/terms/',                   # dcterms  Dubin core
      'http://www.wikidata.org/entity/',             # wd       Wiki data
    );
  }

  #-----------------------------------------------------------------------------
  # Exported routines
  #
  module Rdf-Tools {

    #---------------------------------------------------------------------------
    # Prefixes are set only once for each prefix. Every time a new prefix
    # is set the local-name is checked if the name is a URL for which
    # its page can be cached.
    #
    sub set-prefix (
      Str :$prefix = ' ',
      Str :$local-name where $local-name.chars >= 1
    ) is export {

say "Prefix & local name: '$prefix', '$local-name'";

      # Make a local cache name from url
      #
      my $cache-name = $local-name;
      $cache-name ~~ s/ ^ 'http://' //;
      $cache-name ~~ s:g/ \/ /-/;

# Prefixes are redefinable
#      if ?$prefixes{$prefix} {
#        note "Prefix '$prefix' in use and mapped to $prefixes{$prefix}"
#          unless $prefixes{$prefix} eq $local-name;
#      }
#
#      else {
        $prefixes{$prefix} = $local-name;
#      }

      # Check protocol. If http:// then we can download the file and cache it
      # if there isn't a local version in the turtle home directory
      #
      if $local-name ~~ m/ ^ 'http://' /
         and "$turtle-cache$cache-name".IO !~~ :e {

        # Cache data into local files
        #
        my HTTP::UserAgent $ua .= new;
say "Get source of $local-name";
        my $response = $ua.get($local-name);
        if $response.is-success {
          my $content = $response.content;
          spurt( $turtle-cache ~ $cache-name, $content);
        }

        else {
          note "$local-name is not downloadable";
        }

        CATCH {
          default {
            say .message ~ ". Command to get " ~ $local-name;
#            .say;
          }
        }
      }

      # Parse the turtle file to get all defined triples
      #
#      if $cache-name.IO ~~ :r {
      if 0 {
#        my Rdf::Turtle $t .= new;
#        my $content = slurp($cache-name);
#        my Match $status = $t.parse(:$content);
#        ok $status ~~ Match, "Parse tuple ok";
      }
    }

    #---------------------------------------------------------------------------
    #
    sub get-prefix ( Str $prefix = ' ' --> Str ) is export {
      return $prefixes{$prefix} // '';
    }

    #---------------------------------------------------------------------------
    #
    sub get-homedir (  --> Str ) is export {
      return $home-dir;
    }

    #---------------------------------------------------------------------------
    #
    sub get-base (  --> Str ) is export {
      return $base;
    }

    #---------------------------------------------------------------------------
    #
    sub set-base ( Str $new-base ) is export {
      $base = $new-base;
say "Set base to $base";
    }
  }
}

#===============================================================================

=finish

  #-----------------------------------------------------------------------------
  # XSD (http://www.w3.org/2000/01/rdf-schema#) Data types recognized
  # by the program. See table 'A list of the RDF-compatible XSD types, with
  # short descriptions' at http://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/

  # Core types
  constant $STRING              = 'xsd:string';
  constant $BOOLEAN             = 'xsd:boolean';
  constant $DECIMAL             = 'xsd:decimal';        # Arbitrary precision
  constant $INTEGER             = 'xsd:integer';        # Arbitrary precision

  # IEEE floating-pointnumbers
  constant $DOUBLE              = 'xsd:double';
  constant $FLOAT               = 'xsd:float';

  # Time and date
  constant $DATE                = 'xsd:date';
  constant $TIME                = 'xsd:time';
  constant $DATETIME            = 'xsd:dateTime';
  constant $DATETIMESTAMP       = 'xsd:dateTimeStamp';

  # Recurring and partial dates
  constant $GYEAR               = 'xsd:gYear';          # Gregorian
  constant $GMONTH              = 'xsd:gMonth';
  constant $GDAY                = 'xsd:gDay';
  constant $GYEARMONTH          = 'xsd:gYearMonth';
  constant $GMONTHDAY           = 'xsd:gMonthDay';
  constant $DURATION            = 'xsd:duration';
  constant $YEARMONTHDURATION   = 'xsd:yearMonthDuration';
  constant $DAYTIMEDURATION     = 'xsd:dayTimeDuration';

  # Limited-range integer numbers
  constant $BYTE                = 'xsd:byte';
  constant $SHORT               = 'xsd:short';
  constant $INT                 = 'xsd:int';
  constant $LONG                = 'xsd:long';
  constant $UNSIGNEDBYTE        = 'xsd:unsignedByte';
  constant $UNSIGNEDSHORT       = 'xsd:unsignedShort';
  constant $UNSIGNEDINT         = 'xsd:unsignedInt';
  constant $UNSIGNEDLONG        = 'xsd:unsignedLong';
  constant $POSITIVEINTEGER     = 'xsd:positiveInteger';        # >  0
  constant $NONNEGATIVEINTEGER  = 'xsd:nonNegativeInteger';     # >= 0
  constant $NEGATIVEINTEGER     = 'xsd:negativeInteger';        # <  0
  constant $NONPOSITIVEINTEGER  = 'xsd:nonPositiveInteger';     # <= 0

  # Encoded binary data
  constant $HEXBINARY           = 'xsd:hexBinary';
  constant $BASE64BINARY        = 'xsd:base64Binary';

  # Miscellaneous XSD types
  constant $ANYURI              = 'xsd:anyURI';
  constant $LANGUAGE            = 'xsd:language';
  constant $NORMALIZEDSTRING    = 'xsd:normalizedString';
  constant $TOKEN               = 'xsd:token';
  constant $NMTOKEN             = 'xsd:NMTOKEN';
  constant $NAME                = 'xsd:Name';
  constant $NCNAME              = 'xsd:NCName';

  # Some from RDF (http://www.w3.org/1999/02/22-rdf-syntax-ns) and
  # RDFS (http://www.w3.org/2000/01/rdf-schema#)
  #
  # RDF Classes
  constant $RESOURCE            = 'rdfs:Resource';
  constant $LITERAL             = 'rdfs:Literal';
  constant $LANGSTRING          = 'rdf:langString';
  constant $HTML                = 'rdf:HTML';
  constant $XMLLITERAL          = 'rdf:XMLLiteral';
  constant $CLASS               = 'rdfs:Class';
  constant $PROPERTY            = 'rdf:Property';
  constant $DATATYPE            = 'rdfs:Datatype';
  constant $STATEMENT           = 'rdf:Statement';
  constant $BAG                 = 'rdf:Bag';
  constant $SEQ                 = 'rdf:Seq';
  constant $ALT                 = 'rdf:Alt';
  constant $CONTAINER           = 'rdfs:Container';
  constant $CONTAINERMEMBERSHIPPROPERTY = 'rdfs:ContainerMembershipProperty';
  constant $LIST                = 'rdf:List';

  # RDF Properties
  constant $TYPE                = 'rdf:type';
  constant $SUBCLASSOF          = 'rdfs:subClassOf';
  constant $SUBPROPERTYOF       = 'rdfs:subPropertyOf';
  constant $DOMAIN              = 'rdfs:domain';
  constant $RANGE               = 'rdfs:range';
  constant $LABEL               = 'rdfs:label';
  constant $COMMENT             = 'rdfs:comment';
  constant $MEMBER              = 'rdfs:member';
  constant $FIRST               = 'rdf:first';
  constant $REST                = 'rdf:rest';
  constant $SEEALSO             = 'rdfs:seeAlso';
  constant $ISDEFINEDBY         = 'rdfs:isDefinedBy';
  constant $VALUE               = 'rdf:value';
  constant $SUBJECT             = 'rdf:subject';
  constant $PREDICATE           = 'rdf:predicate';
  constant $OBJECT              = 'rdf:object';


  # Array of types to check for
  constant @RDF-TYPES           = (
    $STRING,
    $BOOLEAN,
    $DECIMAL,
    $INTEGER,

    $DOUBLE,
    $FLOAT,

    $DATE,
    $TIME,
    $DATETIME,
    $DATETIMESTAMP,

    $GYEAR,
    $GMONTH,
    $GDAY,
    $GYEARMONTH,
    $GMONTHDAY,
    $DURATION,
    $YEARMONTHDURATION,
    $DAYTIMEDURATION,

    $BYTE,
    $SHORT,
    $INT,
    $LONG,
    $UNSIGNEDBYTE,
    $UNSIGNEDSHORT,
    $UNSIGNEDINT,
    $UNSIGNEDLONG,
    $POSITIVEINTEGER,
    $NONNEGATIVEINTEGER,
    $NEGATIVEINTEGER,
    $NONPOSITIVEINTEGER,

    $HEXBINARY,
    $BASE64BINARY,

    $ANYURI,
    $LANGUAGE,
    $NORMALIZEDSTRING,
    $TOKEN,
    $NMTOKEN,
    $NAME,
    $NCNAME,

    $RESOURCE,
    $LITERAL,
    $LANGSTRING,
    $HTML,
    $XMLLITERAL,
    $CLASS,
    $PROPERTY,
    $DATATYPE,
    $STATEMENT,
    $BAG,
    $SEQ,
    $ALT,
    $CONTAINER,
    $CONTAINERMEMBERSHIPPROPERTY,
    $LIST,

    $TYPE,
    $SUBCLASSOF,
    $SUBPROPERTYOF,
    $DOMAIN,
    $RANGE,
    $LABEL,
    $COMMENT,
    $MEMBER,
    $FIRST,
    $REST,
    $SEEALSO,
    $ISDEFINEDBY,
    $VALUE,
    $SUBJECT,
    $PREDICATE,
    $OBJECT,
  );

