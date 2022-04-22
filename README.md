# LoRNA_ER_stress
A LoRNA/LOPIT experiment to explore the relocalisation or RNA and protein in response to activation of the Unfolded Protein Response (UPR).

The analyses in this repository are contained in R markdown (Rmd) notebooks. These notebooks can be re-run in the order denoted by their prefixes and all experimental data required for the re-analysis is contained with the repository, with one noteable exception described below.

### Repository structure 

The top level directories are:

* 1_external - Data from external sources including functional annotations and experimental results and, where required, Rmd notebooks to process the data for use in analysis notebooks
* 2_protein - Analysis of LOPIT data, including relocalisation upon UPR activation
* 3_rna - Analysis of LoRNA data, including relocalisation and modelling of features driving localisation/re-localisation
* 5_manuscript_figures - Figures generated within analysis notebooks for presentation in the manuscript (main and supplementary)
* 6_shiny_app - Generation of objects for shiny app. Note that this does not include the code for the deployment of the app itself
* 7_sup_tables - Generation of supplementary tables for the manuscript
* accessory - Additional files required for the analysis
* experimental_design - Further experimental details required for analysis

Within the directories, further README files describe the file structure. Notebook directories will always have numerical prefixes to indicate the order in which the notebooks were run.

&#x26a0;&#xfe0f;
The RNA (LoRNA) notebooks `3_rna/notebooks/2_lorna/1_data_processing/1_estimate_spike_in.Rmd` and `2_Make_MsnSets.Rmd` require access to the output of salmon from the RNA-Seq fastq data processing pipeline, and have hardcoded paths to the expected location of this output. As such, these cannot be run from the files in this repository alone. All LoRNA notebooks from `3_Normalise_by_abundance.Rmd` onwards and all other notebooks can be run from the data included in this repository alone, or data which can be obtained as described in READMEs.
&#x26a0;&#xfe0f;

## Dependencies
The notebooks in this repository were run with R 4.0.3 and Bioconductor 3.11. Using other versions of R may not be possible for some notebooks. For example, ENCODExplorer is used in some notebooks and is not available in Bioconductor 3.14.

This repository makes extensive use of non-base R packages. To run all notebooks, the following dependencies need to be installed.

** From CRAN **:
- broom
- cowplot
- dbscan
- ggalluvial
- ggbeeswarm
- ggplot2
- ggrepel
- ggridges
- ggtern
- glmnet
- gplots
- tidyverse
- naniar
- NNLM
- pbapply
- pbmcapply
- pROC
- RColorBrewer
- Rtsne
- writexl

** From Bioconductor **
- AnnotationHub
- biobroom
- biomaRt
- coRdon
- DEqMS
- ENCODExplorer
- ensembldb
- GenomicRanges
- GO.db
- goseq
- Gviz
- limma
- MSnbase
- pRoloc
- pRolocdata
- rtracklayer
- tximport
- UniProt.ws

** From Github ** (use e.g `devtools::install_github()`):
- bandle (ococrook/bandle) # Note now available through Bioconductor but not with R 4.0.3
- camprotR (CambridgeCentreForProteomics/camprotR)
- OptProc (TomSmithCGAT/OptProc)
- pRolocExt (TomSmithCGAT/pRolocExt)




