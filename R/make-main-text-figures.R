FINFIGOUT <- "./tmp/plots/figures_for_main_paper"
dir.create(FINFIGOUT, recursive = TRUE)

# make the kinalyzer smearograms
source("./R/all_aggregated_smearograms.R")



## now compute some quantities:

# how about colony vs kinalyer?
colki <- droplevels(col.vs.kina[col.vs.kina$Scenario.x != "lotta_large",])
mean(colki$part.dist.x<=colki$part.dist.y)  # how many does colony do better than Kinalyzer with the AP distance?
mean(colki$part.dist2.x<=colki$part.dist2.y)  # how many does colony do better than Kinalyzer with the S distance?
mean(colki$trimmed.part.dist2.x<=colki$trimmed.part.dist2.y, na.rm = T) # trimmed distance
table(colki$Scenario.x, colki$part.dist2.x<=colki$part.dist2.y)




colcons <- droplevels(col.vs.cons[col.vs.cons$Scenario.x != "lotta_large",])
mean(colcons$part.dist.x<=colcons$part.dist.y)  # how many does colony do better than Kinalyzer with the AP distance?
mean(colcons$part.dist2.x<=colcons$part.dist2.y)  # how many does colony do better than Kinalyzer with the S distance?
table(colcons$Scenario.x, colcons$part.dist2.x<=colcons$part.dist2.y)


# how does colony do compared to FF?
colff <- droplevels(col.vs.ff[col.vs.ff$Scenario.x != "lotta_large",])
mean(colff$part.dist.x<=colff$part.dist.y)  # how many does colony do better than FF 



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
file.rename("new-colony-boxplots-10-loci.pdf", file.path(FINFIGOUT, "new-colony-boxplots-10-loci.pdf"))

