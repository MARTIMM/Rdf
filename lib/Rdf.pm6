package Rdf:ver<0.1.0>:auth<https://github.com/MARTIMM> {

  #-----------------------------------------------------------------------------
  # Definition of used constants
  # Node types
  #
  constant $NODE-IRI            = 0x0001;
  constant $NODE-BLANK          = 0x0002;
  constant $NODE-LITERAL        = 0x0003;
  constant $NODE-GRAPH          = 0x0004;

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

  # Cache data into local files
  #


  module Rdf-Tools {

    #---------------------------------------------------------------------------
    #
    sub prefix (
      Str :$prefix = ' ',
      Str :$local-name where $local-name.chars >= 1
    ) is export {

      if ?$prefixes{$prefix} {
        note "Prefix '$prefix' in use for $prefixes{$prefix}";
      }

      else {
        $prefixes{$prefix} = $local-name;
      }
    }

    #---------------------------------------------------------------------------
    #
    sub get-prefix ( Str $prefix = ' ' ) is export {
      return $prefixes{$prefix};
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
