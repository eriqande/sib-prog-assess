# This should be run in the "./analysis/colony" directory
library(reshape)
source("../../R/RecoverCodesWithinR.R") # for some useful functions



# get the true partitions
truth <- read.table(
  file="../partition-distance-calculation/input/TruePartitions.txt",
  header=T,
  stringsAsFactors=F
)
# This just takes all the true partitions and puts them in a list
# subscripted by their Code.  Thus we can access them quickly
truth.list <- by(truth, as.factor(truth$Code), FUN=function(x) x)



# a function to read in the condensed sibships and get what we want from that
process.data <- function(datfile) {
  
  inferred <- read.table(
    file=datfile,
    header=T,
    stringsAsFactors=F
  )
  
  # now, for each combination of Code and NumLoc in the inferred, we want to 
  # extract the largest inferred sibship.
  # by returns its result as a 2-D array with the Code and NumLoc being dimnames.  I want to
  # turn it back into a data frame.  I can do that manually (which is an interesting exercise)
  # but I use melt from the reshape package here.  melt can't operate on things of class "by"
  # so I unclass it.
  largest.inferred <- melt(
    unclass(
      by(inferred, 
         list(as.factor(inferred$Code), as.factor(inferred$NumLoc)), 
         FUN=function(x) max(x$SibSize)
      )
    )
  )
  
  names(largest.inferred) <- c("Code", "NumLoc", "Max.Inferred.Sibsize")
  
  
  # get the largest ones in the true partitions
  largest.truth <- unclass(by(truth, 
                              as.factor(truth$Code), 
                              FUN=function(x) max(x$SibSize)
  )) 
  
  
  # now we just make a new column which is the largest sibsize of the true sibship
  largest.compare <- cbind(largest.inferred, Max.True.Sibsize=largest.truth[substr(largest.inferred$Code,1,7)])
  
  
  # here is a function to recover the number of alleles from the Code:
  largest.compare$Num.Alleles <- CodeToAlleNum(largest.compare$Code)
  largest.compare$Scenario <- CodeToScenarioName(largest.compare$Code)
  largest.compare  # return this
  
}



#### And now we crunch those output out into a list  ####
thefiles <- c("full-colony-new-condensed.txt", "full-colony-new-condensed-pairwise.txt")
names(thefiles) <- c("C25", "C25P")
new_results <- lapply(thefiles, process.data)


#### Now, we add those results to the original results  ####
load("../../scores/BiggestSibshipSavedData.Rda")

res.list <- c(res.list, new_results)
names(res.list)[names(res.list) == "CO"] <- "C2"
names(res.list)[names(res.list) == "CP"] <- "C2P"


save(res.list, file = "../../scores/BiggestSibshipSavedData-WithNewColony.Rda")
