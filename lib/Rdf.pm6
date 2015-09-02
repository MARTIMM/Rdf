use v6;
use File::HomeDir;
use HTTP::Client;

package Rdf:ver<0.1.0>:auth<https://github.com/MARTIMM> {

  # Setup the home directory for this program
  #
  my $home-dir = File::HomeDir.my_home;
  my $pname = "$home-dir/." ~ $*PROGRAM-NAME;
  $pname ~~ s/\.          # Start with the dot
              <-[.]>+     # Then no dot may appear after that
              $           # til the end
             //;          # Remove found extention

  mkdir( $pname, :8<755>) unless $pname.IO ~~ :d;
  our $home-dir-path = "$pname/";
  
  # Setup the base url for this application. Can be modified later.
  #
  our $base;
  if !$base.defined {
    $base = 'file:///' ~ $*PROGRAM-NAME;
    $base ~~ s/ '.' <-[.]>+ $ //;
    $base ~= '#';
say "Base at start: $base";
  }
  
  else {
say "Base defined as: $base";
  }

  #-----------------------------------------------------------------------------
  # Definition of used constants
  # Node types
  #
  constant $NODE-IRI            = 0x0001;
  constant $NODE-BLANK          = 0x0002;
  constant $NODE-LITERAL        = 0x0003;
  constant $NODE-GRAPH          = 0x0004;

if 0 {
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
}

  # Array of types to check for
  our @RDF-TYPES;

  #-----------------------------------------------------------------------------
  # Prefixes are visible in every OWL object;
  #
  our $prefixes = Hash.new;

  # Set some known prefixes with their iri
  #
  if ! $prefixes.keys {
    $prefixes<rdf rdfs xsd foaf schema dcterms wd> = @(
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#', # rdf
      'http://www.w3.org/2000/01/rdf-schema#',       # rdfs
      'http://www.w3.org/2001/XMLSchema#',           # xsd      data types
      'http://xmlns.com/foaf/0.1/',                  # foaf     social network
      'http://schema.org/',                          # schema
      'http://purl.org/dc/terms/',                   # dcterms  Dubin core
      'http://www.wikidata.org/entity/',             # wd       Wiki data
    );

#    $prefixes{' '} = 'file:///' ~ $*PROGRAM-NAME ~ '#';
  }



  module Rdf-Tools {

    #---------------------------------------------------------------------------
    #
    sub prefix (
      Str :$prefix = ' ',
      Str :$local-name where $local-name.chars >= 1
    ) is export {

say "local name: '$prefix', '$local-name'";
      if ?$prefixes{$prefix} {
        note "Prefix '$prefix' in use and mapped to $prefixes{$prefix}"
          unless $prefixes{$prefix} eq $local-name;
      }

      else {
        $prefixes{$prefix} = $local-name;

        # Check protocol
        #
        if $local-name ~~ m/ ^ 'http://' / {
          # device local name from url
          #
          my $cache-name = $local-name;
          $cache-name ~~ s/ ^ 'http://' //;
          $cache-name ~~ s:g/ \/ /-/;

          # Check if there is a local version cached in the home directory
          #
          if $cache-name.IO !~~ :r {
            # Cache data into local files
            #
            my HTTP::Client $client .= new;
            my $response = $client.get($local-name);
            if $response.success {
              my $content = $response.content;
  #            my $mt = open( 'mime-types-list.html', :rw, :!bin);
  #            $mt.print($content);
  #            $mt.close;
              spurt( $home-dir-path ~ $cache-name, $content);
            }

            else {
              note "$local-name is not downloadable";
            }
          }
          
          # Parse the turtle file to get all defined triples
        }
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
    sub set-base ( Str $new-base --> Str ) is export {
      $base = $new-base;
    }

    #---------------------------------------------------------------------------
    # Convert log notation iri to a short one
    #
    sub short-iri ( Str $full-iri is copy --> Str ) is export {

#say "FI: $full-iri";
      for $prefixes.keys -> $k {
#say "KV: $k => $prefixes{$k}";
        my $uri = $prefixes{$k};
        if $full-iri ~~ m/ $uri / {
          $full-iri ~~ s/ $uri /$k:/;
          last;
        }
      }

#say "SI: $full-iri";
      return $full-iri;
    }

    #---------------------------------------------------------------------------
    # Convert short notation iri into full iri format
    # e.g. xsd:long --> http://www.w3.org/2001/XMLSchema#long
    #
    sub full-iri ( Str $iri-string --> Str ) is export {

      # An iri can be a short iri of only the <local name> or a
      # <prefix:local name> combination. If split returns two results its the
      # second otherwise its the first.
      #
      ( my $prefix, my $local-name) = $iri-string.split(':');

      # prefix and localname if there is a ':'
      #
      my Str $site-iri;
      if ?$local-name #`{{Then there is also a prefix}} {
        $site-iri = $prefixes{$prefix} ~ $local-name
          if $prefixes{$prefix}:exists;
      }

      # Only localname in prefix, prefix is default, use prefix ' '.
      #
      else {
        $site-iri = $prefixes{' '} ~ $prefix
          if $prefixes{' '}:exists;
      }

      return $site-iri;
    }
  }
}
