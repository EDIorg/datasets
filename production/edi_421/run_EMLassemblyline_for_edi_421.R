# This script executes an EMLassemblyline workflow.

# Staging = edi.319
# Production = edi.421

library(EMLassemblyline)
setwd("/Users/csmith/Documents/EDI/datasets/edi_421")

EMLassemblyline::template_table_attributes(
  path = ".", 
  data.table = "ca_lsa_combined_edi.csv"
)

EMLassemblyline::template_core_metadata(
  path = ".",
  license = "CC0",
  file.type = ".docx"
)

EMLassemblyline::template_geographic_coverage(
  path = ".",
  empty = TRUE
)

EMLassemblyline::make_eml(
  path = ".", 
  dataset.title = "Lake surface areas and watershed areas for 4012 lakes in the USA and New Zealand", 
  temporal.coverage = c("1984-01-01", "2018-01-01"), 
  maintenance.description = "completed", 
  data.table = "ca_lsa_combined_edi.csv",
  data.table.description = "Lake and watershed areas", 
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.421.1"
)
