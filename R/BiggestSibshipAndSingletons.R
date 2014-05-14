REGENERATE_SAVED_DATA <- FALSE
library(reshape)
library(dichromat)  # to check out colors and see which don't work for color blind folks
source("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/script/RecoverCodesWithinR.R") # for some useful functions




##########################################################
############ Execute if you need to recompile the data
if(REGENERATE_SAVED_DATA) {

# make some temporary files to hold uncompresed output, etc
setwd("/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FamilyFinderRuns")
system("cat *_Alleles/Output.txt LottaLargeRuns/*_Alleles/Output.txt  | awk 'NR==1 {print; next} $1==\"Code\" {next} {print}' > /tmp/ff_partitions_all.txt")
system("gzcat /Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/PRT_April_1_2014_with_codes.txt.gz > /tmp/PRT_April_1_2014_with_codes.txt")

# just set this here, though we make sure it is done later, too
setwd("/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/")




# get the true partitions
truth <- read.table(
	file="/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/TruePartitions.txt",
	header=T,
	stringsAsFactors=F
	)
# This just takes all the true partitions and puts them in a list
# subscripted by their Code.  Thus we can access them quickly
truth.list <- by(truth, as.factor(truth$Code), FUN=function(x) x)




process.data <- function(datfile) {

	inferred <- read.table(
	#file="/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/output/ColonyFirstFifteenReps.txt",
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



my.files<-c(
  "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/output/colony_final_crunch.txt",
  "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/output/all_kinalyzer_refined.txt",
  "/tmp/PRT_April_1_2014_with_codes.txt",
  "/tmp/ff_partitions_all.txt",
  "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/output/colony_pairwise_final_crunch.txt",
  "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/output/all_kinalyzer_consense_refined.txt"
	)
res.list <- list();
for(i in seq_along(my.files)) {
	res.list[[i]] <- process.data(my.files[i])
}
names(res.list) <- c("CO", "KI", "PRT", "FF", "CP", "KC"); 
save(res.list, file="/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/BiggestSibshipSavedData.Rda", compress="xz")
}
####################################################################


setwd("/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/")
latex.comms <- "latex_commands_for_biggest_sibship.tex"
file.remove(latex.comms)


# just load that back in to save time here if not regenerating data
if(!REGENERATE_SAVED_DATA) {
	load("/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/BiggestSibshipSavedData.Rda")
}

xlabs<-c(70,60,50,40,30,20,10,0,10,20,30,40,50,60,70)
ylabs<-c(30,20,10,0,10,20,30)
# you need to have set up a plot space already
plot.a.quadrant <- function(X, xmult=1, ymult=1, add=T, ...) {
	if(!add) {
		plot(0:1, 0:1, type="n", xlim=c(-75,75), ylim=c(-30,30), 
			ylab="Size of Largest True Sibship",
			xlab="Size of Largest Inferred Sibship",
		  axes=F,
			... )
		abline(b=1,a=0, lty="dashed")
		abline(b=-1,a=0, lty="dashed")
		abline(h=0)
		abline(v=0)
		box()
		axis(1, labels=xlabs, at=xlabs*c(rep(-1,7),rep(1,8)) )
		axis(2, labels=ylabs, at=ylabs*c(rep(-1,3),rep(1,4)) )
	}
	my.col <- c("darkturquoise", "orange", "blue")
	#my.col <- dichromat(my.col, type="deutan")
	#my.col <- dichromat(my.col, type="protan")
	names(my.col) <- c("n","l","h") # these names are for the genotyping error rates
	
	half.sibbed <- c("allhalf", "allpathalf", "sfs_wh", "onelarge_wh", "slfsg_wh")
	no.halfs <- c("nosibs", "onelarge_noh", "sfs_noh", "slfsg_noh")
	
	
	x <- X$Max.Inferred.Sibsize * xmult + runif(n=nrow(X), min=-.5, max=.5)
	y <- X$Max.True.Sibsize * ymult + runif(n=nrow(X), min=-.5, max=.5)
	points(x[y<75] ,y[y<75], 
		col=my.col[substr(X$Code,8,8)],
		pch=1 + (X$Scenario %in% half.sibbed),
		cex=.45
	) # I put the <75 there so we don't do the lotta_larges
	
}


plot.four.quadrants <- function(num.alle, num.loc, meths=c("PRT", "CO", "KI", "FF")) {
	plot.a.quadrant(subset(res.list[[meths[1]]], Num.Alleles==num.alle & NumLoc==num.loc), 1, 1, add=F, 
		main=paste(num.alle, "Alleles   ", num.loc, "Loci")
		)
	# put labels down:
	text(x=c(75, -75, -75, 75), y=c(25, 25, -25,-25), labels=meths)
	
	plot.a.quadrant(subset(res.list[[meths[2]]], Num.Alleles==num.alle & NumLoc==num.loc), -1, 1, add=T)
	plot.a.quadrant(subset(res.list[[meths[3]]], Num.Alleles==num.alle & NumLoc==num.loc), -1, -1, add=T)
	plot.a.quadrant(subset(res.list[[meths[4]]], Num.Alleles==num.alle & NumLoc==num.loc), 1, -1, add=T)
	
	# at the very end, put some dotted lines in to indicate the "correct" x-value ranges
	verts=rep(c(1,5,20,30), each=2) + c(-.5,+.5)
	abline(v=c(verts,-verts), lty="dotted", col="gray")
}


# make plots and copy them directly to the suppl3 latex directory
SUPPL3DIR <- "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl3"
quartz("X-plots", width=11, height=7.5)
for(a in c(5,10,15,20,25)) {
	for(l in c(5,10,15,20,25)) {
		plot.four.quadrants(a, l )  # this is the one for the first plot I made
		file.name <- paste("biggest_sibship_alle",a,"_loc",l,".pdf",sep="")
		dev.copy2pdf(file=file.path(SUPPL3DIR, file.name))
		write(paste("\\begin{figure}\\includegraphics[width=\\textwidth]{",file.name,"} \\caption{$X$-plot with \\colony{} (CO), \\prt{} (PRT), \\familyfinder{} (FF), and \\kinalyzer{} 2-allele (KI), $A=",a,"$, $L=",l,"$} \\label{xplot-a",a,"l",l,"} \\end{figure}\\clearpage", sep=""),
			file=latex.comms, append=T)
	}
}
for(a in c(5,10,15,20,25)) {
	for(l in c(5,10,15,20,25)) {
		plot.four.quadrants(a, l, meths=c("CP", "CO", "KI", "KC") )  # this one has CP and KC in there.
		file.name <- paste("biggest_sibship_with_kikc_alle",a,"_loc",l,".pdf",sep="")
		dev.copy2pdf(file=file.path(SUPPL3DIR, file.name))
		write(paste("\\begin{figure}\\includegraphics[width=\\textwidth]{",file.name,"} \\caption{$X$-plot with \\colony{} (CO), \\colony{}-P (CP), \\kinalyzer{} 2-allele (KI), and \\kinalyzer{} consense (KC), $A=",a,"$, $L=",l,"$} \\label{xplot-kikc-a",a,"l",l,"} \\end{figure}\\clearpage", sep=""),
			file=latex.comms, append=T)
	}
}


# at the end, put the latex.comms where the need to be:
file.copy(latex.comms, SUPPL3DIR, overwrite=T)




# that is interesting to look at, and we can do something with this at some point.
# note this:
table(largest.compare$Max.True.Sibsize, largest.compare$Scenario)
# it shows us how many observations there are for each scenario and each max number of 
# true sib size
# when you break it down by num alleles and num loc you see there are 45 observations in each:
table(largest.compare$Max.True.Sibsize, largest.compare$Scenario, largest.compare$NumLoc, largest.compare$Num.Alleles)
# that is 3 genoerror levels and 15 reps.  Here is the plan for a crazy figure:
# 3 colors = 3 geno_error levels
# 2 shapes = with or without half sibs
# one figure for each combination of num.alle and num loc
# I can fit four methods in the four quadrants.  Y-axis is correct size of largest sibship
# x-axis is the size of inferred largest sibship. 
# use positive or negative to put in different quadrants.  Cool! this will be interesting.


if(0) {
# How about looking at the Sibsizes greater than 1 in the nosibs?
inferred$Scenario <- CodeToScenarioName(inferred$Code)
inferred$NumAlle <- CodeToAlleNum(inferred$Code)


wrongos <- subset(inferred, Scenario=="nosibs" & SibSize>1)

# this makes a histogram where each individual in a sibship > size 1 in the sample is an observation and the
# value each one carries is the posterior prob score of the sibship it is in
## THIS ONLY WORKS FOR THE COLONY OUTPUT
tweak <- by(wrongos, list(as.factor(wrongos$NumLoc), as.factor(wrongos$NumAlle)), 
					function(x) hist(
												rep(x$ProbScore, times=x$SibSize), 
												breaks=seq(0,1,by=.1),
												plot=F
												)
				)
names(dimnames(tweak)) <- c("NumLoc", "NumAlle")

# OK, now we can print tweaks and I see that it has the info I want, we just have to figure out 
# how to extract it. It isn't particularly friendly.
# I think I should focus solely on the NumAlleles = 10 case.
}