
rm(list = ls())
library(EMLassemblyline)

# Parameterize script

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\mendota_p_cycling\\edi_283\\metadata_templates'

data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\mendota_p_cycling\\edi_283\\data'

eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\mendota_p_cycling\\edi_283\\eml'

data.files <- c(
  "chemphys.csv",
  "LakeLevel.csv",
  "Mendota_pheasant_branch_30year2xP.csv",
  "Mendota_yahara_30year2xP.csv",
  "Modeled_thermocline_daily.csv",
  "NLDAS_daily.csv",
  "ntl301_hypso.csv",
  "P_Drivers.csv",
  "P_EpilimnionP.csv",
  "P_HypolimnionP.csv",
  "P_ModelOutput.csv",
  "PGRNN_1.csv",
  "PGRNN_10.csv",
  "PGRNN_2.csv",
  "PGRNN_3.csv",
  "PGRNN_4.csv",
  "PGRNN_5.csv",
  "PGRNN_6.csv",
  "RNN_1.csv",
  "RNN_2.csv",
  "RNN_3.csv",
  "RNN_4.csv",
  "RNN_5.csv",
  "RNN_6.csv"  
)

data.files.description <- c(
  'Lake Mendota chemical properties through time',
  'Lake water surface levels through time',
  'Chemical and physical properties of Pheasant Branch inflow through time',
  'Chemical and physical properties of Yahara River inflow through time',
  'Thermocline depth, epilimnetic temperature, and hypolimnetic temperature for Lake Mendota through time',
  'Atmospheric data for Madison through time',
  'Hypsometry factors for various lakes',
  'Driving data for PROCESS',
  'The observed epilimnetic phosphorus and the corresponding modeled output for epilimnetic phosphorus from PROCESS',
  'The observed hypolimnetic phosphorus and the corresponding modeled output for hypolimnetic phosphorus from PROCESS',
  'The PROCESS model outputs for epilimnetic phosphorus and hypolimnetic phosphorus at the daily time scale',
  'Modeled outputs of lake phosphorus from PGRNN when validated on segment 1',
  'Modeled outputs of lake phosphorus from PGRNN when the ecological principal loss function was not included',
  'Modeled outputs of lake phosphorus from PGRNN when validated on segment 2',
  'Modeled outputs of lake phosphorus from PGRNN when validated on segment 3',
  'Modeled outputs of lake phosphorus from PGRNN when validated on segment 4',
  'Modeled outputs of lake phosphorus from PGRNN when validated on segment 5',
  'Modeled outputs of lake phosphorus from PGRNN when validated on segment 6',
  'Modeled outputs of lake phosphorus from RNN when validated on segment 1',
  'Modeled outputs of lake phosphorus from RNN when validated on segment 2',
  'Modeled outputs of lake phosphorus from RNN when validated on segment 3',
  'Modeled outputs of lake phosphorus from RNN when validated on segment 4',
  'Modeled outputs of lake phosphorus from RNN when validated on segment 5',
  'Modeled outputs of lake phosphorus from RNN when validated on segment 6'
)




# Import core templates

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  license = 'CC0', 
  data.files = data.files
)

# Import categorical variables template

EMLassemblyline::define_catvars(
  path = path,
  data.path = data.path
)

# Translate templates into EML

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Data for Lake Mendota Phosphorus Cycling Model',
  data.files = data.files,
  data.files.description = data.files.description,
  temporal.coverage = c('1995-05-09', '2015-12-31'),
  geographic.description = 'Lake Mendota, Madison, WI',
  geographic.coordinates = c('43.146', '-89.3673', '43.0766', '-89.4837'),
  maintenance.description = 'completed',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.141.4',
  environment = 'production',
  provenance = c('knb-lter-ntl.1.42', 'knb-lter-ntl.29.18')
)
