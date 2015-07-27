package Rdf:ver<0.1.0> {

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

  # Some from RFD (http://www.w3.org/1999/02/22-rdf-syntax-ns)
  constant $LANGSTRING          = 'rdf:langString';
  constant $HTML                = 'rdf:HTML';

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

    $LANGSTRING,
    $HTML,
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
  }

  # Cache data into local files
  #
}
