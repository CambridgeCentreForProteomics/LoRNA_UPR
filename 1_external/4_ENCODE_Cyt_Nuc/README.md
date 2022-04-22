**encode_files.txt** was defined from: https://www.encodeproject.org/search/?type=Experiment&status=released&perturbed=false&assay_title=polyA+plus+RNA-seq&replicates.library.biosample.donor.organism.scientific_name=Homo+sapiens&biosample_ontology.classification=cell+line&lab.title=Thomas+Gingeras%2C+CSHL&award.rfa=ENCODE2&biosample_ontology.term_name!=AG04450&biosample_ontology.term_name!=BJ

The ENCODE files themselves are not included in the repo but can be quickly downloaded with e.g:
`xargs -L 1 curl -O -J -L < encode_files.txt`

The files need to be downloaded to this directory.
