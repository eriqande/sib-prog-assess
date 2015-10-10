OUTDIR <- "tmp/plots/figures_for_main_paper"
dir.create(OUTDIR, recursive = TRUE)

#### LOAD DATA AND PREPARE IT ####
load("./scores/PRT_April_1_2014_party_dists.rda")
prt.all <- PRT_party_dists
rm(PRT_party_dists)
kina.all <- read.table("./scores/Kinalyzer75s_PDs_and_Time.txt",header=T);
ff.all <- read.table("./scores/FamilyFinderAll.txt",header=T);
cons.all <- read.table("./scores/KinaConsense75_PDs.txt",header=T);  # kinalyzer with consense option

col.pair <- read.table("./scores/full_colony_new_version_pairwise.txt",header=T);  # colony with pairwise calculation


col.med <- read.table("./scores/full_colony_new_version.txt",header=T);



# now, we need to get a column of number of alleles, etc for prt.all from the Codes in the file
# for num alleles
alle.letters <- paste("a",letters, sep="")
alle.letter.nums <- 0:(length(alle.letters)-1)
names(alle.letter.nums) <- alle.letters
prt.all$NumAlleles <- alle.letter.nums[substr(prt.all$Code,1,2)]
# for scenario we get what they are from the colony output:
temp <- unique(cbind(as.character(col.med$Scenario),substr(col.med$Code,3,4)))
the.scen.names <- temp[,1]
names(the.scen.names) <- temp[,2]
prt.all$Scenario <- as.factor(the.scen.names[substr(prt.all$Code,3,4)])
# then the GenoErr
prt.all$GenoError <- as.factor(substr(prt.all$Code,8,8));



# merge pairs of methods together for comparison
col.vs.ff <- merge(col.med,ff.all, by=c("Code","NumLoc"));
col.vs.kina <- merge(col.med,kina.all, by=c("Code","NumLoc"));
kina.vs.ff <- merge(kina.all,ff.all, by=c("Code","NumLoc"));
ff.vs.kina <-  merge(ff.all,kina.all, by=c("Code","NumLoc"));
col.vs.cons <- merge(col.med, cons.all, by=c("Code","NumLoc"));
kina.vs.cons <- merge(kina.all,cons.all,by=c("Code","NumLoc"));
col.vs.prt <- merge(col.med, prt.all, by=c("Code","NumLoc"));
col.vs.col.pair <- merge(col.med, col.pair, by=c("Code","NumLoc"));




#### DEFINE SOME FUNCTIONS TO DO THE PLOTS  ####
# here is a function to make a single smearogram given
# two vectors of pds, pd1 and pd2,  and a vector of locus numbers LN
aggregated.smear.panel <- function(pd1,
                        pd2,
                        LN,
                        GenoError,
                        #my.pch=c(3,23,2,22,1),
                        my.colors=c("lightgray","gray","black"),  # for levels of genotyping error: lightgray=lots, gray=medium, black=none
                        x.label="Method 1 PD",
                        y.label="Method 2 PD",
                        main.lab="",
                        abc="(a)"
                        ) {
  l1=length(pd1);
  l2=length(pd2);
  r1=runif(min=-.5,max=.5,n=l1);
  r2=runif(min=-.5,max=.5,n=l2);
  if(l1>0 && l1>0 ) {
    plot(pd1+r1,pd2+r2,
         main=main.lab,
         col=my.colors[as.numeric(as.factor(GenoError))],
         pch=20,
         cex=.28,
         xlim=c(0,80), #c(0,max(pd1+r1,pd2+r2,na.rm=T)),
         ylim=c(0,80), #c(0,max(pd1+r1,pd2+r2,na.rm=T)),
         xlab=x.label,
         ylab=y.label
         );

    # now, put down all the no-genotyping cases on top, in black
    pd1.n <- pd1[GenoError=="n"];
    pd2.n <- pd2[GenoError=="n"];
    r1.n <- r1[GenoError=="n"];
    r2.n <- r2[GenoError=="n"];
               
    l1=length(pd1.n);
    l2=length(pd2.n);
    if(l1>0 && l1>0 ) {
      points(pd1.n+r1.n,pd2.n+r2.n, pch=20,cex=.15,col="black"); 
    }


    
    abline(a=0,b=1, lty="dashed");
  }
  mtext(text=abc,side=3,line=1,at=0,cex=1.15)
}



# here is a function to take a pairwise comparison table X and
# make a series of plots out of it.  These are desiged to be panels
# in an mfrow context
agg.2m.smear.with.exp <- function(X, filepref="file", column=1, letter="a", 
                                  xlabel = expression(Try~This~ Cr[ap]),
                                  ylabel = expression(Or~This~Cra^p)) {
  par(mar=c(4.1, 4.7, 3.1, 1.1))
  DISTS <- c("part.dist","part.dist2","trimmed.part.dist","trimmed.part.dist2");  # will be convenient to have
  
  xd <- paste(DISTS,"x",sep=".");
  yd <- paste(DISTS,"y",sep=".");
  
  d <- X [, c(xd,yd,"NumLoc","NumAlleles.x","GenoError.x")];  # now d has just the rows of interest and just the columns we want too
  
  # now we cycle over the different versions of partition distances and plot them
  c <- 0;
  p <- column
    c <- c+1;
    x <- d[,p];
    y <- d[,4+p];  # this assumes there are four different partition distances we are dealing with
    
    
    aggregated.smear.panel(x,
                           y,
                           LN=d$NumLoc,
                           GenoError=d$GenoError.x,
                           x.label=xlabel,
                           y.label=ylabel,
                           abc=paste("(",letter,")",sep="")
    );
}



#### MAKE THE FIRST AGGREGATED SMEAROGRAM PLOT ####
# make colony vs kinalyzer and show all 4 PD types in a 2x2 matrix and put another row below that
# for the consense option.
pdf(file = file.path(OUTDIR, "various_kina_smears.pdf"), height=7.4, width=5.9)
par(mfrow=c(3,2))
#aggregated.two.methods.smears(col.vs.kina,meth1="Colony 2.0.5.7",meth2="Kinalyzer 2-allele");
agg.2m.smear.with.exp(col.vs.kina, column = 1, letter = "a",
                      xlabel = expression("Colony 2.0.5.7 "~PD[AP]),
                      ylabel = expression("Kinalyzer 2-allele "~PD[AP]))

agg.2m.smear.with.exp(col.vs.kina, column = 2, letter = "b",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]),
                      ylabel = expression("Kinalyzer 2-allele "~PD[S]))

agg.2m.smear.with.exp(col.vs.kina, column = 3, letter = "c",
                      xlabel = expression("Colony 2.0.5.7 "~PD[AP]^T),
                      ylabel = expression("Kinalyzer 2-allele "~PD[AP]^T))

agg.2m.smear.with.exp(col.vs.kina, column = 4, letter = "d",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]^T),
                      ylabel = expression("Kinalyzer 2-allele "~PD[S]^T))

agg.2m.smear.with.exp(col.vs.cons, column = 2, letter = "e",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]),
                      ylabel = expression("Kinalyzer consense "~PD[S]))

agg.2m.smear.with.exp(kina.vs.cons, column = 2, letter = "f",
                      xlabel = expression("Kinalyzer 2-allele "~PD[S]),
                      ylabel = expression("Kinalyzer consense "~PD[S]))
dev.off()




#### MAKE THE SECOND AGG SMEARO FIGURE ####
# now we are going to do another 3 by 2 set of panels.  The top row will be the
# PRT results.  The middle the Family Finder Results and the bottom the colony pairwise
# results.
pdf(file = file.path(OUTDIR, "prt_ff_and_col_pair_smears.pdf"), height=7.4, width=5.9)
par(mfrow=c(3,2))

col.vs.prt75s <- col.vs.prt[ col.vs.prt$Scenario.x != "lotta_large", ]
col.vs.ff75s <- col.vs.ff[ col.vs.ff$Scenario.x!="lotta_large",]
col.vs.pair75s <- col.vs.col.pair [ col.vs.col.pair$Scenario.x != "lotta_large", ]


agg.2m.smear.with.exp(col.vs.prt75s, column = 2, letter = "a",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]),
                      ylabel = expression("PRT "~PD[S]))

agg.2m.smear.with.exp(col.vs.prt75s, column = 4, letter = "b",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]^T),
                      ylabel = expression("PRT "~PD[S]^T))

agg.2m.smear.with.exp(col.vs.ff75s, column = 2, letter = "c",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]),
                      ylabel = expression("Family Finder "~PD[S]))

agg.2m.smear.with.exp(col.vs.ff75s, column = 4, letter = "d",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]^T),
                      ylabel = expression("Family Finder "~PD[S]^T))

agg.2m.smear.with.exp(col.vs.pair75s, column = 2, letter = "e",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]),
                      ylabel = expression("Colony-P 2.0.5.7 "~PD[S]))

agg.2m.smear.with.exp(col.vs.pair75s, column = 4, letter = "f",
                      xlabel = expression("Colony 2.0.5.7 "~PD[S]^T),
                      ylabel = expression("Colony-P 2.0.5.7 "~PD[S]^T))

dev.off()



