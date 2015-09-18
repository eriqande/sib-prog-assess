# run this in the ./analysis/colony directory

# this creates the table to high confidence incorrect sibship assignments
# and puts in in a .tex file in the sib_ass_tex directory.
	
#setwd("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ColonyPosteriorSummaries/play/")



# read the data in
#  y <- read.table("~/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/output/colony_final_crunch.txt", header=T)	

y <- read.table("full-colony-new-condensed.txt", header = T)


x <- y;


# make an allele number column
alle.nums <- 0:26
names(alle.nums) <- paste("a",letters, sep="")
x$NumAlleles <- alle.nums[substr(x$Code,1,2)]


# make a scenario column. Recall:
# tc["allhalf"] = "AB";
# tc["allpathalf"] = "AC";
# tc["nosibs"] = "AE";
# are the ones we want to do
x$Scenario <- substr(x$Code, 3,4)

# make a genotyping error column:
x$GenoErr <- factor(substr(x$Code, 8, 8));



# now, let us restrict our attention to just situations with no full sibs
x <- x[x$Scenario %in% c("AE", "AB", "AC"), ]

# and let us also focus only on the intermediate geno.error setting using Colony:
x <- x[ x$ColonyErrOpts=="d.02m.02", ]


x$Scenario <- factor(x$Scenario) # reset the factor levels here
x$Code <- factor(x$Code)


# finally, we want to drop all those sibships that were not 
# identified with >= .98 posterior probability
x <- x[ x$ProbScore>=.98, ]


# now, we can just count the number of inferred sibships of each size
# discovered across all runs, broken out by:
# NumLoc
# NumAlleles
#   <--- Put SibSize in here
# Scenario
# GenoErr
# This will be a big sloppy result, but should be pretty cool nonetheless
table(x$NumLoc, x$NumAlleles, x$SibSize, x$Scenario, x$GenoErr, dnn=c("NumLoc", "NumAlleles", "SibSize", "Scenario", "GenoErr") )

# So, sometimes it finds sibships up to size 8, but very few.  So, we will probably be OK just lumping
# all the sibships >=4 into their own category.
x$SibSizeCategory <- x$SibSize
x$SibSizeCategory[x$SibSize>=4] <- ">=4"

# now we can do like so:
table(x$NumLoc, x$NumAlleles, x$SibSizeCategory, x$Scenario, x$GenoErr, dnn=c("NumLoc", "NumAlleles", "SibSize", "Scenario", "GenoErr") )


# now, we want to count up the actual number of simulated data sets for each of these conditions. 
# this is a little dodge-fest because I have conditioned on greater than .98, but let's see if
# we can do it like this:
tapply(x$Code,  INDEX=list(x$NumLoc, x$NumAlleles, x$Scenario, x$GenoErr), FUN=function(x) length(unique(x)))
# Yep! that tells us what we were expecting to see: 15 data sets for each condition


# now we can do the average number of high-posterior, but incorrect, inferred sibships like so:
ttp <- table(x$NumLoc, x$NumAlleles, x$SibSizeCategory, x$Scenario, x$GenoErr, dnn=c("NumLoc", "NumAlleles", "SibSize", "Scenario", "GenoErr") ) / 15

# ttp stands for "table to print".  Now let's get the bits out of it what we want:
df_tab <-
	rbind(
		cbind(ttp[, , "2", "AE", "n"], NA, ttp[, , "2", "AB", "n"]), 
		NA,
		cbind(ttp[, , "3", "AE", "n"], NA, ttp[, , "3", "AB", "n"]),
		NA,
		cbind(ttp[, , ">=4", "AE", "n"], NA, ttp[, , ">=4", "AB", "n"])
	)

fdtab <- format(df_tab, digits = 1)
fdtab[fdtab == "   NA"] <- ""

ff3 <- cbind(rownames(fdtab), fdtab)
colnames(ff3)[1] <- '$L$'

ff4 <- cbind(c(2, rep("", 5), 3, rep("", 5), "$\\geq 4$", rep("", 4)), ff3)
colnames(ff4)[1] <- '$S$'
write.table(ff4, quote = FALSE, sep = "  &  ", eol = "\\\\\n", row.names = FALSE, file = "../../sib_assess_tex/hi-conf-tab.tex")


