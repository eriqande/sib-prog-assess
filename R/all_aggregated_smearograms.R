OUTDIR <- "tmp/plots/figures_for_main_paper"
dir.create(OUTDIR, recursive = TRUE)

#### LOAD DATA AND PREPARE IT ####
load("./scores/PRT_April_1_2014_party_dists.rda")
prt.all <- PRT_party_dists
rm(PRT_party_dists)
#prt.all <- read.table("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/prt_part_dists_computed_by_eca.txt",header=T);
col.all <- read.table("./scores/Colony_Results_All.txt",header=T);
kina.all <- read.table("./scores/Kinalyzer75s_PDs_and_Time.txt",header=T);
ff.all <- read.table("./scores/FamilyFinderAll.txt",header=T);
cons.all <- read.table("./scores/KinaConsense75_PDs.txt",header=T);  # kinalyzer with consense option

col.pair <- read.table("./scores/Colony_Pairwise_Results_All.txt",header=T);  # colony with pairwise calculation


col.med <- col.all[ col.all$gtyp.err.assumption == "d.02m.02",]



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

alph=c("a","b","c","d","e","f");



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
         cex=.15,
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
# make a series of plots out of it.  Each scenario gets its own
# page with all the PD calcs on it.  Note that the first of the pair
# should have columns suffixed with x and the second with y
aggregated.two.methods.smears <- function(X, meth1="Method1", meth2="Method2", filepref="file", columns=1:4, letters=alph) {
  par(mar=c(4.1, 4.1, 3.1, 1.1))
  DISTS <- c("part.dist","part.dist2","trimmed.part.dist","trimmed.part.dist2");  # will be convenient to have
  sDists <- c("w","x","y","z");
  xd <- paste(DISTS,"x",sep=".");
  yd <- paste(DISTS,"y",sep=".");
  
#  for (g in c('n','l','h')) { # cycle over genotyping error levels
    d <- X [, c(xd,yd,"NumLoc","NumAlleles.x","GenoError.x")];  # now d has just the rows of interest and just the columns we want too
                                        # now we cycle over the different versions of partition distances and plot them
    c <- 0;
    for(p in columns)  {
      c <- c+1;
      x <- d[,p];
      y <- d[,4+p];  # this assumes there are four different partition distances we are dealing with
      
      aggregated.smear.panel(x,
                  y,
                  LN=d$NumLoc,
                  GenoError=d$GenoError.x,
                  x.label=paste(meth1,sDists[p],sep=""),
                  y.label=paste(meth2,sDists[p],sep=""),
                  #main.lab=paste(sDists[p],sep=" "),
                  abc=paste("(",letters[c],")",sep=""),
                  );
      
    }
#  }
#  dev.copy2eps(file=paste(filepref,"_",meth1,"_vs_",meth2,SCEN,".eps", sep=""));
}



#### MAKE THE PLOTS ####
# make colony vs kinalyzer and show all 4 PD types in a 2x2 matrix and put another row below that
# for the consense option.
#postscript(file=file.path(OUTDIR, "various_kina_smears.ps"), height=7.4, width=5.9)
quartz("various_kina_smears.ps", height=7.4, width=5.9)
par(mfrow=c(3,2))
aggregated.two.methods.smears(col.vs.kina,meth1="c",meth2="k");

# then we want to make two more plots on the bottom for the consense algorithm
# here c=Colony, k=kinalyzer two allele, b=consense
aggregated.two.methods.smears(col.vs.cons,meth1="c",meth2="b",columns=c(2),letters="e");
aggregated.two.methods.smears(kina.vs.cons,meth1="k",meth2="b",columns=c(2),letters="f");
dev.copy2eps(file=file.path(OUTDIR, "various_kina_smears.eps"));
#dev.off()



# now we are going to do another 3 by 2 set of panels.  The top row will be the
# PRT results.  The middle the Family Finder Results and the bottom the colony pairwise
# results.
#postscript(file = file.path(OUTDIR, "prt_ff_and_col_pair_smears.eps"), height=7.4, width=5.9)
quartz("prt_ff_and_col_pair_smears.eps", height=7.4, width=5.9)
par(mfrow=c(3,2))
col.vs.prt75s <- col.vs.prt[ col.vs.prt$Scenario.x != "lotta_large", ]
aggregated.two.methods.smears(col.vs.prt75s, meth1="c", meth2="p",columns=c(2),letters="a");
aggregated.two.methods.smears(col.vs.prt75s, meth1="c", meth2="p",columns=c(4),letters="b");

col.vs.ff75s <- col.vs.ff[ col.vs.ff$Scenario.x!="lotta_large",]
aggregated.two.methods.smears(col.vs.ff75s,meth1="c",meth2="f",columns=c(2),letters="c");
aggregated.two.methods.smears(col.vs.ff75s,meth1="c",meth2="f",columns=c(4),letters="d");

col.vs.pair75s <- col.vs.col.pair [ col.vs.col.pair$Scenario.x != "lotta_large", ]
aggregated.two.methods.smears(col.vs.pair75s, meth1="c",meth2="a",columns=c(2),letters="e");
aggregated.two.methods.smears(col.vs.pair75s, meth1="c",meth2="a",columns=c(4),letters="f");
dev.copy2eps(file = file.path(OUTDIR, "prt_ff_and_col_pair_smears.eps"));
#dev.off()



