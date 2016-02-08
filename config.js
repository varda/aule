AULE_CONFIG = {
  // Base URI on which Aulë is mounted.
  BASE: '/',

  // Root endpoint of Varda server.
  API_ROOT: 'http://127.0.0.1:5000/',

  // Number of items per page.
  PAGE_SIZE: 50,

  // Number of pages to be considered many by the UI.
  MANY_PAGES: 13,

  // Optional MyGene.info configuration used for frequency lookup by
  // transcript. This should be an object with the following fields:
  //
  // - species:
  //   Query MyGene.info for transcripts in this organism.
  // - exons_field:
  //   Field name in MyGene.info gene annotation containing a dictionary with
  //   coordinate data for each transcript. Coordinates should correspond with
  //   the reference genome of the Varda server.
  // - email:
  //   MyGene.info encourages regular users to provide an email, so that they
  //   can better track the usage or follow up with you. This field is optional.
  //
  // Example configuration:
  //
  //     MY_GENE_INFO: {
  //       species: 'human',
  //       exons_field: 'exons_hg19'
  //     }
  MY_GENE_INFO: null
};
