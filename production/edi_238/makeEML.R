library(EMLassemblyline)

file_path <- "./data"

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Looking beyond the mean: Drivers of variability in postfire stand development of conifers in Greater Yellowstone"

file_descriptions <- c("Model comparison with Forest Vegetation Simulator. FVS outputs for Pinus contorta var. latifolia. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Model comparison with Forest Vegetation Simulator. FVS outputs for Pseudotsuga menziesii var. glauca. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Model comparison with Forest Vegetation Simulator. iLand outputs for Pinus contorta var. latifolia. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Model comparison with Forest Vegetation Simulator. ilLand outputs for Pseudotsuga menziesii var. glauca. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Single-species (initial) evaluation outputs for Abies lasiocarpa. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Single-species (initial) evaluation outputs for Pinus contorta var. latifolia. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Single-species (initial) evaluation outputs for Picea engelmannii. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Single-species (initial) evaluation outputs for Pseudotsuga menziesii var. glauca. Values are for trees greater than 4 meters in height unless otherwise noted.",
                       "Succession (multispecies evaluation) experiment replicate 1. Trees refer to living trees greater than 4 meters in height and values are specific to the tree species in a given row unless otherwise noted. ",
                       "Succession (multispecies evaluation) experiment replicate 1. Used for comparison with mature Douglas-fir stands at simulation year 300. Values are specific to the tree species in a given row unless otherwise noted. ",
                       "Succession (multispecies evaluation) experiment replicate 2. Used for comparison with mature Douglas-fir stands at simulation year 300. Values are specific to the tree species in a given row unless otherwise noted. ",
                       "Succession (multispecies evaluation) experiment replicate 3. Used for comparison with mature Douglas-fir stands at simulation year 300. Values are specific to the tree species in a given row unless otherwise noted. ",
                       "Succession (multispecies evaluation) experiment replicate 2. Trees refer to living trees greater than 4 meters in height and values are specific to the tree species in a given row unless otherwise noted.",
                       "Succession (multispecies evaluation) experiment replicate 3. Trees refer to living trees greater than 4 meters in height and values are specific to the tree species in a given row unless otherwise noted.",
                       "Processed (aggregated, condensed) outputs from the simulation (stand variability) experiment for Abies lasiocarpa. Includes all n = 20 replicates of 4 scenarios. Values are for trees greater than 4 meters in height.",
                       "Processed (aggregated, condensed) outputs from the simulation (stand variability) experiment for Pinus contorta var. latifolia. Includes all n = 20 replicates of 4 scenarios. Values are for trees greater than 4 meters in height.",
                       "Processed (aggregated, condensed) outputs from the simulation (stand variability) experiment for Picea engelmannii. Includes all n = 20 replicates of 4 scenarios. Values are for trees greater than 4 meters in height.",
                       "Processed (aggregated, condensed) outputs from the simulation (stand variability) experiment for Pseudotsuga menziesii var. glauca. Includes all n = 20 replicates of 4 scenarios. Values are for trees greater than 4 meters in height.")
                       
quote_character <- rep("\"",18)

temp_cov <- c("2016-01-01", "2018-05-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.238.4"

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
