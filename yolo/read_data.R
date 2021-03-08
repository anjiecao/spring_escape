library(googlesheets4) # package for reading data in spreadsheet directly into R
library(here) # pakcage for managing paths
#rsconnect::deployApp(here("app.R"))


RAW_DATA_GOOGLE_SHEET_ID <- "1MOlxQdnUBsobbyM7XbA0dLAG-RjhS4GgARCv3qRvAMI"
SHEET_NAME <- "accomodations"
PATH <- here("yolo.csv")


read_raw_data <- function(sheet_id, sheet_name){
  
  df.accomodations <- read_sheet(sheet_id, sheet_name,
                                 
                                 col_types = "cddddcccccdcc")
  
  return(df.accomodations)
}

df.accomodations <- read_raw_data(RAW_DATA_GOOGLE_SHEET_ID, SHEET_NAME)
write_csv(df.accomodations, PATH)
