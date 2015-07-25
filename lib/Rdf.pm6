package Rdf:ver<0.1.0> {

  # Prefixes are visible in every OWL object;
  #
  our $prefixes = Hash.new;

  # Set some known prefixes with their iri
  #
  if ! $prefixes.keys {
    $prefixes<rdf rdfs xsd foaf schema dcterms wd> = @(
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      'http://www.w3.org/2000/01/rdf-schema#',
      'http://www.w3.org/2001/XMLSchema#',
      'http://xmlns.com/foaf/0.1/',
      'http://schema.org/',
      'http://purl.org/dc/terms/',
      'http://www.wikidata.org/entity/',
    );
  }
  
  # Cache data into local files
  #
}
