require(graphics)
source("./R/RecoverCodesWithinR.R") # for some useful functions
OUTDIR <- "./tmp/plots/smearograms"

# this must be run in the directory that contains sib-prog-assess.Rproj

#### DEFINE TWO USEFUL FUNCTIONS FOR MAKING SMEAROGRAMS  ####
# here is a function to make a single smearogram given
# two vectors of pds, pd1 and pd2,  and a vector of locus numbers LN
smear.panel <- function(pd1,
                        pd2,
                        LN,
                        Num.Alle,
                        my.pch=c(3,23,2,22,1),
                        my.colors=c("red","orange","yellow","green","blue"),
                        x.label="Method 1 PD",
                        y.label="Method 2 PD",
                        main.lab=""
) {
  l1=length(pd1);
  l2=length(pd2);
  r1=runif(min=-.5,max=.5,n=l1);
  r2=runif(min=-.5,max=.5,n=l2);
  if(l1>0 && l1>0 ) {
    plot(pd1+r1,pd2+r2,
         main=main.lab,
         col=my.colors[LN/5],
         pch=my.pch[Num.Alle/5],
         cex=.5,
         xlim=c(0,max(pd1+r1,pd2+r2,na.rm=T)),
         ylim=c(0,max(pd1+r1,pd2+r2,na.rm=T)),
         xlab=x.label,
         ylab=y.label
    );
    abline(a=0,b=1, lty="dashed");
  }
}



# here is a function to take a pairwise comparison table X and
# make a series of plots out of it.  Each scenario gets its own
# page with all the PD calcs on it.  Note that the first of the pair
# should have columns suffixed with x and the second with y
two.methods.all.smears <- function(X, meth1="Method1", meth2="Method2", filepref="file", outdir) {
  
  par(mar=c(4.1, 4.1, 2.1, 1.1))
  DISTS <- c("part.dist","part.dist2","trimmed.part.dist","trimmed.part.dist2");  # will be convenient to have
  sDists <- c("pd","pd2","tr.pd","tr.pd2");
  sDistNames <- c("PD_AP", "PD_S", "PD_AP^T", "PD_S^T")
  
  xd <- paste(DISTS,"x",sep=".");
  yd <- paste(DISTS,"y",sep=".");
  
  for (SCEN in The.SCENS) { #levels(X$Scenario.x)) {  # cycle over sibling scenarios
    
    file.name <- paste(filepref,"_",meth1,"_vs_",meth2,the.SCEN.names[SCEN], sep="")
    file.name <- paste(gsub("[^0-9A-Za-z_]","", file.name), ".pdf", sep="") # get all the spaces and periods out of it
    file.name <- file.path(outdir, file.name)  # prepend the output directory to the name
    
    pdf(file = file.name, width = 13, height = 8.5)  # write to a pdf file directly.
    par(mfrow=c(3,4));
    for (g in c('n','l','h')) { # cycle over genotyping error levels
      d <- X [X$Scenario.x==SCEN & X$GenoError.x==g, c(xd,yd,"NumLoc","NumAlleles.x")];  # now d has just the rows of interest and just the columns we want too
      # now we cycle over the different versions of partition distances and plot them
      for(p in 1:4)  {
        x <- d[,p];
        y <- d[,4+p];  # this assumes there are four different partition distances we are dealing with
        
        smear.panel(x,
                    y,
                    LN=d$NumLoc,
                    Num.Alle=d$NumAlleles.x,
                    x.label=meth1,
                    y.label=meth2,
                    main.lab=paste(the.SCEN.names[SCEN],g,sDistNames[p],sep=",  ")
                    
        );
        
      }
    }
    
    
    if(!is.na(texlabstrs[meth1])) {labname1<-texlabstrs[meth1]} else { labname1<-meth1} 
    if(!is.na(texlabstrs[meth2])) {labname2<-texlabstrs[meth2]} else { labname2<-meth2} 
    
    latex_command <- paste("\\begin{figure}\\includegraphics[width=\\textwidth]{../../",file.name,"} \\caption{",
                           latex.prog.names[meth2]," compared to ",latex.prog.names[meth1]," on scenario ", SCEN.latex[SCEN], " \\label{fig:",labname1,"_v_",
                           labname2,"_on_",gsub("_", "", SCEN),"}} \\end{figure}", sep="")
    write(latex_command, file=file.list, append=T)
    dev.off()
    
  }
}

#### READ IN ALL THE SCORES FROM THE VARIOUS PROGRAMS  ####

# prt stuff in an R archive
load("./scores/PRT_April_1_2014_party_dists.rda")
prt.all <- PRT_party_dists
rm(PRT_party_dists)

# the rest in text files
col.all <- read.table("./scores/Colony_Results_All.txt",header=T);
kina.all <- read.table("./scores/Kinalyzer75s_PDs_and_Time.txt",header=T);
ff.all <- read.table("./scores/FamilyFinderAll.txt",header=T);
cons.all <- read.table("./scores/KinaConsense75_PDs.txt",header=T);  # kinalyzer with consense option
col.pair.all <- read.table("./scores/Colony_Pairwise_Results_All.txt",header=T);


# restrict focus here to one Colony error setting
col.med <- col.all[ col.all$gtyp.err.assumption == "d.02m.02",]

# now, we need to get a column of number of alleles, etc for prt.all from the Codes in the file
prt.all$NumAlleles <- CodeToAlleNum(prt.all$Code)
prt.all$Scenario <- CodeToScenarioName(prt.all$Code)
prt.all$GenoError <- CodeToGenoError(prt.all$Code)



# now, create a list of all those data sets, indexed by the name you want for
# each method:
all.data <- list(Colony=col.med, 
                 ColonyP=col.pair.all,
                 PRT=prt.all,
                 FamilyFinder=ff.all,
                 Kinalyzer=kina.all,
                 KinaConsense=cons.all
)

#### DEFINE VARIABLES TO HELP WRITE OUT THE CAPTIONS AND OTHER TEXT  ####
# this is for writing the names up there:
The.SCENS <- c("nosibs","allhalf","allpathalf","sfs_noh","sfs_wh","slfsg_noh","slfsg_wh","onelarge_noh","onelarge_wh", "lotta_large") 
SCEN.latex <- gsub("_","",paste("\\",The.SCENS,sep=""))
names(SCEN.latex) <- The.SCENS
the.SCEN.names <- c("NoSibs", "AllHalf", "AllPatHalf", "SmallSGs", "SmallSGs_H", "BigSGs", "BigSGs_H", "OneBig", "OneBig_H", "LottaLarge")
names(the.SCEN.names) <- The.SCENS

# this is for the typesetting of the table of contents, etc.
latex.prog.names <- c("\\colony{}-P", "\\colony{}", "\\prt{}", "\\familyfinder{}", "\\kinalyzer{} 2-allele", "\\kinalyzer{} consense", 
                      "\\colony{} assuming moderate error rate", "\\colony{} assuming no genotyping error", "\\colony{} assuming a high error rate" )
names(latex.prog.names) <- c("ColonyP", "Colony", "PRT", "FamilyFinder", "Kinalyzer", "KinaConsense", 
                             "Colony d=0.02, m=0.02", "Colony d=0 m=0", "Colony d=0.07 m=0.03")
labstrs <- c("Colony d=0 m=0", "Colony d=0.07 m=0.03", "Colony d=0.02, m=0.02")
texlabstrs <- c("ColNone", "ColHigh", "ColMed")
names(texlabstrs) <- labstrs






# open up a quartz window to set the width and heigth of it that we want.
# note that this probably only will work on my laptop at work!
#quartz(width=13, height=8.5)


# this script creates a boatload of plots, so put them all somewhere in ./tmp
dir.create(OUTDIR, recursive = T);
file.list <- file.path(OUTDIR, "latex_commands_for_smearograms.tex")
suppressWarnings(file.remove(file.list))





#### CYCLE OVER ALL PAIRWISE COMPARISONS AND MAKE THE PLOTS  ####
for(i in 1:(length(all.data)-1)) {
	for(j in (i+1):length(all.data)) {
	  write(paste("\\part{",latex.prog.names[names(all.data)[j]], " compared to ", latex.prog.names[names(all.data)[i]],
	  	"\\label{sec:",names(all.data)[j],"_v_",names(all.data)[i], "}}", "\\newpage", sep=""), file=file.list, append=T)
		merge.set <- merge(all.data[[i]], all.data[[j]], by=c("Code","NumLoc"))
		two.methods.all.smears(merge.set, meth1=names(all.data)[i], meth2=names(all.data)[j], outdir=OUTDIR);
	}
}



#### MAKE PLOTS TO COMPARE COLONY ERROR RATE SETTINGS  ####
# and down here I would like to compare the Colony runs with with the medium setting
# to those with the high and the low settings for assumed genotyping error rates
col.none <- col.all[ col.all$gtyp.err.assumption == "d0m0",]
col.high <- col.all[ col.all$gtyp.err.assumption == "d.07m.03",]
X<-col.med
i<-0
for(Y in list(col.none, col.high)) {
	i<-i+1
	write(paste("\\part{", latex.prog.names[labstrs[i]], " compared to ", latex.prog.names["Colony d=0.02, m=0.02"], "\\label{sec:", texlabstrs[i],"_v_ColMed}}", "\\newpage", sep=""), file=file.list, append=T)
	merge.set <- merge(X, Y, by=c("Code","NumLoc"))
	two.methods.all.smears(merge.set, meth1="Colony d=0.02, m=0.02", meth2=labstrs[i], outdir=OUTDIR);
}




