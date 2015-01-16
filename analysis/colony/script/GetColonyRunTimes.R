
library(stringr)
library(lubridate)
library(dplyr)

x <- read.table("analysis/colony/ColonyRuns_ProgressLog.txt")

x$Code <- x$V2
x$GtypErr <- str_match(x$V5, "d\\.[0-9]*m\\.[0-9]*")[,1]
x$NumLoc <- str_match(x$V5, "^l([0-9]*)L")[,2]
x$Times <- parse_date_time(paste(x$V8, x$V9, x$V10), orders = "b d H M S")
x$When <- x$V1 # whether starting or finishing

x <- x[, -(1:12)]

x <- tbl_df(x)

starttimes <- x %>%
  filter(When == "Starting")

endtimes <- x %>%
  filter(When == "Finished")

joined <- inner_join(starttimes, endtimes, by = c("Code", "GtypErr", "NumLoc"))

joined$diffs  <- joined$Times.y - joined$Times.x
