# once you've run colony via 01-run-colony-subset.sh and you have computed the partition distances
# with 02-analyze-colony-subset-runs.sh, you can run this script to compile the partition distances
# into a format that we can readily use to make figures

#### Some checks to make sure we are running this in the right directory, etc ####
# check to make sure that we are in the right directory
if(basename(getwd()) != "colony") stop("You are in the wrong directory. Must be started in the ./analysis/colony directory")

if(!all(c("script", "bin", "input") %in% dir())) stop("Did not find directories \"script\" or \"bin\" or \"input\".  You must have sourced the script from the wrong directory.  Must be started in the ./analysis/colony directory")


# check to make sure that the directories we want to find out output in are there
if(!all(c("NewColony", "OldColony") %in% dir())) stop("Missing directory \"OldColony\" of \"NewColony\".  You probably need to run 02-analyze-colony-subset-runs.sh")



##### Now Slurp the data into a list of data frames and bung it together  ####
dirs <- file.path(rep(c("NewColony", "OldColony"), each=2), paste("PmP_", rep(c(5,10), 2), sep=""))
names(dirs) <- dirs
pd_list <- lapply(dirs, function(x) {
  ff <- file.path(x, "party_distances.txt")
  read.table(ff, header=T, stringsAsFactors = FALSE)
})

newc <- rbind(pd_list[[1]], pd_list[[2]])
newc$Version <- "NewColony"

oldc <- rbind(pd_list[[3]], pd_list[[4]])
oldc$Version <- "OldColony"

COL <- rbind(oldc, newc)




#### Now parse out the meaning of the Code for each data set, etc ####
source("../R/RecoverCodesWithinR.R")

COL$Scenario <- CodeToScenarioName(COL$Code)  
COL$NumAlleles <- CodeToAlleNum(COL$Code)  
COL$Number <- CodeToRepNumber(COL$Code)  
COL$GenoError <- CodeToGenoError(COL$Code)  
COL$gtyp.err.assumption <- "d.02m.02"



#### Then write it to a file in the "scores" directory ####
write.table(x = COL, file = "../../scores/Colony_do_over_with_new_version.txt", quote = FALSE, sep = "\t", row.names = FALSE)
