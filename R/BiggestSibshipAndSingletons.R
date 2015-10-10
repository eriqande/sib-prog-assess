REGENERATE_SAVED_DATA <- FALSE

OUTDIR <- "./tmp/plots/biggest_sibship"
library(reshape)
source("R/RecoverCodesWithinR.R") # for some useful functions




##########################################################
############ Execute if you need to recompile the data   NOTICE YOU HAVE TO MANUALLY PUT THE NEW COLONY RESULTS IN THERE!
if(REGENERATE_SAVED_DATA) {

# make some temporary files to hold uncompresed output, etc
setwd("/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FamilyFinderRuns")
system("cat *_Alleles/Output.txt LottaLargeRuns/*_Alleles/Output.txt  | awk 'NR==1 {print; next} $1==\"Code\" {next} {print}' > /tmp/ff_partitions_all.txt")
system("gzcat /Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/PRT_April_1_2014_with_codes.txt.gz > /tmp/PRT_April_1_2014_with_codes.txt")

# just set this here, though we make sure it is done later, too
#setwd("/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/")




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


# Then after that you ought to change into ./analysis/colony and run 05-add-new-colony-data-for-xplots.R  
}
####################################################################


#### SET UP OUTPUT DIRECTORY
dir.create(OUTDIR, recursive = TRUE)
latex.comms <- file.path(OUTDIR, "latex_commands_for_biggest_sibship.tex")
suppressWarnings(file.remove(latex.comms))


#### LOAD DATA  (i havent put the resources to regenerate the data up on GitHub) ####
# just load the data in to save time here if not regenerating data\
if(!REGENERATE_SAVED_DATA) {
	load("./scores/BiggestSibshipSavedData-WithNewColony.Rda")
}


#### DEFINE SOME PLOTTING FUNCTIONS  ####
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



plot.four.quadrants <- function(num.alle, num.loc, meths=c("PRT", "C25", "KI", "FF")) {
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


#### NOW ACTUALLY GENERATE THE PLOTS ####
# make plots and copy them directly to the suppl3 latex directory
#SUPPL3DIR <- "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl3"
for(a in c(5,10,15,20,25)) {
	for(l in c(5,10,15,20,25)) {
	  file.name <- paste("biggest_sibship_alle",a,"_loc",l,".pdf",sep="")
	  pdf(file = file.path(OUTDIR, file.name), width=11, height=7.5)
		plot.four.quadrants(a, l )  # this is the one for the first plot I made
		dev.off()
		write(paste("\\begin{figure}\\includegraphics[width=\\textwidth]{", "../../", OUTDIR, "/", file.name,"} \\caption{$X$-plot with \\colony{}~2.0.5.7 (C25), \\prt{} (PRT), \\familyfinder{} (FF), and \\kinalyzer{} 2-allele (KI), $A=",a,"$, $L=",l,"$} \\label{xplot-a",a,"l",l,"} \\end{figure}\\clearpage", sep=""),
			file=latex.comms, append=T)
	}
}
for(a in c(5,10,15,20,25)) {
	for(l in c(5,10,15,20,25)) {
	  file.name <- paste("biggest_sibship_with_kikc_alle",a,"_loc",l,".pdf",sep="")
	  pdf(file = file.path(OUTDIR, file.name), width=11, height=7.5)
		plot.four.quadrants(a, l, meths=c("C25P", "C25", "C2", "KC") )  # this one has CP and KC in there.
		dev.off()
		write(paste("\\begin{figure}\\includegraphics[width=\\textwidth]{", "../../", OUTDIR, "/", file.name,"} \\caption{$X$-plot with \\colony{}~~2.0.5.7 (C25), \\colony{}-P~2.0.5.7 (C25P), \\colony{}~2.0 (CO), and \\kinalyzer{} consense (KC), $A=",a,"$, $L=",l,"$} \\label{xplot-kikc-a",a,"l",l,"} \\end{figure}\\clearpage", sep=""),
			file=latex.comms, append=T)
	}
}







