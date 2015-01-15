#' put PDs from pmp files into a data frame
#' 
#' once you've run colony via 01-run-colony-subset.sh and you have computed the partition distances
#' with 02-analyze-colony-subset-runs.sh, you can run this script to compile the partition distances
#' into a format that we can readily use to make figures
#' @param directory The directory holding the pmp_* files
#' @param run_name A name that you want to give to this set of results. It ends up in the "Version" column
#' of the resulting data frame.
#' @param gtyp_rate  The genotyping rate at which the data were simulated.  This has to be set manually if it
#' is different than d.02m.02
#' @param score_file_name The name of the file that you want the data frame to be written to in the scores directory.
slurp_up_partition_distances <- function(directory = "FullColonyNewResults",
                                         run_name = "ColonyNewVersion",
                                         gtyp_rate = "d.02m.02",  # The user has to provide this correctly if it is different
                                         score_file_name = "full_colony_new_version.txt")
{
  
  
  #### Some checks to make sure we are running this in the right directory, etc ####
  # check to make sure that we are in the right directory
  if(basename(getwd()) != "colony") stop("You are in the wrong directory. Must be started in the ./analysis/colony directory")
  
  if(!all(c("script", "bin", "input") %in% dir())) stop("Did not find directories \"script\" or \"bin\" or \"input\".  You must have sourced the script from the wrong directory.  Must be started in the ./analysis/colony directory")
  
  
  # check to make sure that the directories we want to find out output in are there
  if(!(directory %in% dir())) stop(paste("Missing directory ", directory, ".  You probably need to run 02-analyze-colony-subset-runs.sh or you got the name wrong", sep = ""))
  
  
  
  ##### Now Slurp the data into a list of data frames and bung it together  ####
  dirs <- dir(directory, full.names = TRUE)
  names(dirs) <- dirs
  pd_list <- lapply(dirs, function(x) {
    ff <- file.path(x, "party_distances.txt")
    read.table(ff, header=T, stringsAsFactors = FALSE)
  })
  
  COL <- do.call(rbind, pd_list)
  COL$Version <- run_name
  
  
  
  
  #### Now parse out the meaning of the Code for each data set, etc ####
  source("../../R/RecoverCodesWithinR.R")
  
  COL$Scenario <- CodeToScenarioName(COL$Code)  
  COL$NumAlleles <- CodeToAlleNum(COL$Code)  
  COL$Number <- CodeToRepNumber(COL$Code)  
  COL$GenoError <- CodeToGenoError(COL$Code)  
  COL$gtyp.err.assumption <-  gtyp_rate  
  
  
  
  #### Then write it to a file in the "scores" directory ####
  write.table(x = COL, file = paste("../../scores/", score_file_name, sep = ""), quote = FALSE, sep = "\t", row.names = FALSE)
  
}
