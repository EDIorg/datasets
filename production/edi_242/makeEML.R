library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Gross methane production and consumption estimated for intact soil cores from agricultural plots including environmental covariates and example raw isotope pool dilution data"

file_descriptions <- c("This table contains the gross CH4 production and consumption fluxes measured via IPD at weeks 6 and 21 of the incubation.  In addition, the table contains data for other net gases fluxes, soil moisture, redox potential, inorganic nitrogen content, pH, and other useful covariates.  All statistical analysis and reported in Brewer et al., 2018 used the data in this table.",
                       "The raw IPD data used as input to the R script that fits observations to the IPD models.  This includes measurements of 12CH4 and 13CH4 concentrations over time")

quote_character <- rep("\"",2)

temp_cov <- c("2014-05-21", "2014-11-30")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.242.3"

make_eml(path = file_path,
         dataset.title = dataset_title,
         data.files = file_names,
         data.files.description = file_descriptions,
         data.files.quote.character = quote_character,
         temporal.coverage = temp_cov,
         maintenance.description = maint_desc,
         user.id = user_id,
         affiliation = "EDI",
         package.id = package_id)
