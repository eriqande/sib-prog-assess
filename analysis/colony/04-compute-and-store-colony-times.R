

# this is a a little R code that reads that file
# ColonyRuns_ProgressLog.txt and computes the running times of 
# colony on all the different data sets.

# working directory should be set to ./analysis/colony/


library(dplyr)
library(lubridate)
library(stringr)

if(!str_detect(getwd(), "analysis/colony$")) {
  stop("This needs to be run from within the ./analysis/colony directory.  setwd() your way there.")
}

# read in the progress log:
pl <- read.table("ColonyRuns_ProgressLog.txt") %>% tbl_df


# make a text string to read in the times with lubridate, and parse it with
# lubridate
pl <- pl %>% 
  mutate(datetime = ymd_hms(paste(V12, V8, V9, V10, sep = "-")))


# now get the number of loci and also whether it was full or pairwise colony
pl <- pl %>% 
  mutate(
    NumLoc = as.numeric(str_match(V5, "^l([0-9]{1,2})L")[,2]),
    Version = ifelse(str_detect(V5, "x$"), "ColonyNewVersionPairwise", "ColonyNewVersion") 
    )

# rename some things:
pl <- pl %>%
  rename(Code = V2)

# now, with that all computed we just want the difference between the
# Finished time and the Starting time for each combination of
# Scenario and NumLoc and Version.  We'll do that like so (note that this assumes
# there is a single Starting and single Finishing time for each such colony run)
pl <- pl %>%
  group_by(Code, NumLoc, Version) %>%
  arrange() %>%
  summarise(Minutes = as.numeric(difftime(datetime[2], datetime[1], units = "mins")))


# now that we have done that, we can join them with the 
# partition distance results, and write those back to files.

# first for full colony
full_col_pd <- tbl_df(read.table("../../scores/full_colony_new_version.txt", header = TRUE))
full_col_merged <- inner_join(full_col_pd, select(pl, Code, NumLoc, Version, Minutes))
write.csv(full_col_merged, file = "../../scores/full_colony_new_version_with_times.txt")


# then for pairwise colony
pair_col_pd <- tbl_df(read.table("../../scores/full_colony_new_version_pairwise.txt", header = TRUE))
pair_col_merged <- inner_join(pair_col_pd, select(pl, Code, NumLoc, Version, Minutes))
write.csv(pair_col_merged, file = "../../scores/full_colony_new_version_pairwise_with_times.txt")
