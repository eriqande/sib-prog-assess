FINFIGOUT <- "./tmp/plots/figures_for_main_paper"
dir.create(FINFIGOUT, recursive = TRUE)

# make the kinalyzer smearograms
source("./R/all_aggregated_smearograms.R")



# function to do fix-fragging calls
# infile should have no extension. nor should outfile
fix_frag <- function(infile, outfile, addToTop=10) {
	CALL <- paste("latex ", infile, ".tex;  ", 
	               "FixFrag.sh ", infile, ".dvi dump.pdf;  ",
	                "awk '/^%%BoundingBox:/ {$NF+=", addToTop, "; print; next} {print}' dump.eps > ", outfile, ".eps;  ",
	                " epstopdf ", outfile, ".eps",
	                sep="")
	
	 system(CALL)
	 return(paste(outfile, ".pdf", sep=""))
}


### NOT DOING FIX-FRAGGING ON GITHUB.  NOT PORTABLE
# now do it:
# now try fix-fragging
#setwd("./image_forge")
# then copy the files that need fix-fragging into ./image_forge
#stopifnot(all(file.copy(file.path(FINFIGOUT, c("various_kin_smears.eps", "prt_ff_and_col_pair_smears.eps") ),  "./image_forge")))
#final_fig <- fix_frag("various_kin_smear_forge", "various_kin_smear", 10)
#file.copy(final_fig, IMGDIR, overwrite=T)
#final_fig <- fix_frag("prt_ff_pair_smear_forge", "prt_ff_pair_smear", 10)
#file.copy(final_fig, IMGDIR, overwrite=T)



## now compute some quantities:
cvprt<-droplevels(col.vs.prt[col.vs.prt$Scenario.x!="lotta_large",])
mean(cvprt$part.dist.x<=cvprt$part.dist.y)  # how many does colony do better than PRT?

cvp<-droplevels(col.vs.col.pair[col.vs.col.pair$Scenario.x!="lotta_large",])  # use same variable name as above, to make it easy....
mean(cvp$part.dist.x<=cvp$part.dist.y) # how many does colony do better than pairwise colony on?


# what is the distribution of the number of alleles and number of loci and Scenario where colony-P does better?
cpb<-cvp[cvp$part.dist.x>cvp$part.dist.y,]
table(cpb$NumLoc, cpb$NumAlleles.x, cpb$Scenario.x)




### ------------------------------------------------------------
# Now, do the boxplots
source("./R/make_boxplots.R")


# and copy them over for the paper:
BOXDIR <- "./tmp/plots/boxplots"
stopifnot(file.copy(file.path(BOXDIR, "mega_boxplot_alles10_num1.pdf"), file.path(FINFIGOUT, "boxplots_for_paper10_num1.pdf"), overwrite=T))
stopifnot(file.copy(file.path(BOXDIR, "mega_boxplot_alles25_num2.pdf"), file.path(FINFIGOUT, "boxplots_for_paper25_num2.pdf"), overwrite=T))




# and do the lotta large boxplots:
source("./R/lotta_large_analyses_and_plots.R")
file.copy("lotta_large_boxplots.pdf", file.path(FINFIGOUT, "lotta_large_boxplots.pdf"), overwrite=T)
file.remove("lotta_large_boxplots.pdf")

