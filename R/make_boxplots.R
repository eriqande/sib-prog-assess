OUTDIR <- "./tmp/plots/boxplots"

source("./R/RecoverCodesWithinR.R") # for some useful functions

### SET UP THE WORK AREA  ####
dir.create(OUTDIR, recursive = TRUE)
latex.comms <- file.path(OUTDIR, "latex_commands_for_boxplots.tex")
file.remove(latex.comms)


#### LOAD ALL THE DATA AND PREPARE THEM ####
load("./scores/PRT_April_1_2014_party_dists.rda")
prt.all <- PRT_party_dists
rm(PRT_party_dists)
col.all <- read.table("./scores/Colony_Results_All.txt",header=T);
kina.all <- read.table("./scores/Kinalyzer75s_PDs_and_Time.txt",header=T);
ff.all <- read.table("./scores/FamilyFinderAll.txt",header=T);
cons.all <- read.table("./scores/KinaConsense75_PDs.txt",header=T);  # kinalyzer with consensus option
#prt.all <- read.table("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/prt_part_dists_computed_by_eca.txt",header=T);
col.pair.all <- read.table("./scores/Colony_Pairwise_Results_All.txt",header=T);


#col.med <- col.all[ col.all$gtyp.err.assumption == "d.02m.02",]
col.med <- read.table("./scores/full_colony_new_version.txt",header=T);

# now, we need to get a column of number of alleles, etc for prt.all from the Codes in the file
prt.all$NumAlleles <- CodeToAlleNum(prt.all$Code)
prt.all$Scenario <- CodeToScenarioName(prt.all$Code)
prt.all$GenoError <- CodeToGenoError(prt.all$Code)


#### CYCLE OVER SCENARIOS (EXCEPT LOTTA-LARGE) AND MAKE PLOTS  ####

The.SCENS <- c("nosibs","allhalf","allpathalf","sfs_noh","sfs_wh","slfsg_noh","slfsg_wh","onelarge_noh","onelarge_wh") # leaving out lotta_large at this point.
the.SCEN.names <- c("NoSibs", "AllHalf", "AllPatHalf", "SmallSGs", "SmallSGs_H", "BigSGs", "BigSGs_H", "OneBig", "OneBig_H", "LottaLarge")
names(the.SCEN.names) <- The.SCENS

# here, set the number of alleles for all plots
for( ALLES in c(5,10,15,20,25)) {

out.file.num <- 0;

for(panel.num in 1:6) {
  if(panel.num %% 2 == 1) {
    file.name <- paste("/mega_boxplot_alles",ALLES,"_num",out.file.num + 1,".pdf",sep="")
    pdf(file = file.path(OUTDIR, file.name), 12, 8) # make the plot window the size we want it
    par(oma=c(0,5,0,.3))
    par(mfrow=c(6,9))
  }
  
  if(panel.num %% 2 == 0) {
    out.file.num <- out.file.num + 1;
  }

  if(panel.num==1) {
    LOCS=5;
  }
  if(panel.num==2) {
    LOCS=10;
  }
   if(panel.num==3) {
    LOCS=15;
  }
  if(panel.num==4) {
    LOCS=20;
  }
  if(panel.num==5) {
    LOCS=20;
  }
  if(panel.num==6) {
    LOCS=25;
  }
  


col.a <- col.med[col.med$NumLoc==LOCS & col.med$NumAlleles==ALLES & col.med$Scenario!="lotta_large",]
kina.a <- kina.all[kina.all$NumLoc==LOCS & kina.all$NumAlleles==ALLES  & kina.all$Scenario!="lotta_large",]
ff.a <- ff.all[ff.all$NumLoc==LOCS & ff.all$NumAlleles==ALLES  & ff.all$Scenario!="lotta_large",]
cons.a <- cons.all[cons.all$NumLoc==LOCS & cons.all$NumAlleles==ALLES  & cons.all$Scenario!="lotta_large",]
prt.a <- prt.all[prt.all$NumLoc==LOCS & prt.all$NumAlleles==ALLES  & prt.all$Scenario!="lotta_large",]
col.pair.a <- col.pair.all[col.pair.all$NumLoc==LOCS & col.pair.all$NumAlleles==ALLES  & col.pair.all$Scenario!="lotta_large",]



global.max <- max(col.a$part.dist2, col.pair.a$part.dist2, prt.a$part.dist.2, kina.a$part.dist2,ff.a$part.dist2,cons.a$part.dist2);

for(GENERR in c("n","l","h")) {
left.right <- 0;
for (SCEN in The.SCENS ) {

  left.right <- left.right + 1;
  
  # get the data we want in some convenient variable names
  col.b.n <- col.a$part.dist2[col.a$Scenario==SCEN & col.a$GenoError==GENERR];
  kina.b.n <-  kina.a$part.dist2[kina.a$Scenario==SCEN  & kina.a$GenoError==GENERR];
  cons.b.n <- cons.a$part.dist2[cons.a$Scenario==SCEN   & cons.a$GenoError==GENERR];
  ff.b.n <- ff.a$part.dist2[ff.a$Scenario==SCEN  & ff.a$GenoError==GENERR];
  prt.b.n <- prt.a$part.dist2[prt.a$Scenario==SCEN   & prt.a$GenoError==GENERR];
  col.pair.b.n <- col.pair.a$part.dist2[col.pair.a$Scenario==SCEN  & col.pair.a$GenoError==GENERR];


  if(GENERR=="n") {
    par(mar=c(0,.5,3,.5)+.1)
    box.names=rep("",6);
    box.main=paste(the.SCEN.names[SCEN]);
    if(panel.num %% 2 == 0) {
      box.main=""
    }
  }
  if(GENERR=="l") {
    par(mar=c(.25,.5,.25,.5)+.1)
    box.names=rep("",6);
    box.main="";
  }
   if(GENERR=="h") {
    par(mar=c(3,.5,0,.5)+.1)
    box.names=c("CO", "CP", "PRT", "FF","K2","KC");
    box.main="";
  }
  if(left.right>1) {
    box.yaxt="n";
  }
  else {
    box.yaxt="s";
    #par(mar=par("mar")+c(0,1.5,0,0))
  }

  boxlist <- list(col.b.n,
  				col.pair.b.n,
  				prt.b.n,
          ff.b.n,
          kina.b.n,
          cons.b.n);

  boxlistmax <- max(unlist(boxlist))
  
  boxplot(x=boxlist,
          lwd=1,
          #ylim=c(0,global.max),
          ylim=c(0,75),
          boxwex=.3,
          names=box.names,
          las=2,
          yaxt=box.yaxt,
          lwd=.5,
          main=box.main #," #Locs=",LOCS," #Alle=",ALLES)
          )
  if(left.right>1) {
    axis(side = 2, labels = FALSE, tck = -0.05)
  }
  axis(side = 4, labels = FALSE, tck = -0.05)
  
} # closes loop over SCEN
} # closes loop over GENERR
  if(panel.num %% 2 == 1) {
    mtext(text=paste("(a) L=",LOCS,sep=""),cex=1.5, side=2, outer=T, at=0.98, las=1,line=5, adj=0);
  }
  if(panel.num %% 2 == 0) {
    mtext(text=paste("(b) L=",LOCS,sep=""),cex=1.5, side=2, outer=T, at=0.48, las=1,line=5, adj=0);
    mtext(text=expression(PD[S]),outer=T,at=.75, side=2, line=2.2);
    mtext(text=expression(PD[S]),outer=T,at=.25, side=2, line=2.2);
    
    dev.off()
    
    
    #### INCOMPLETE HERE!!
    latex_command <- paste("\\begin{figure}\\includegraphics[width=\\textwidth]{", "../../", OUTDIR, file.name,"} \\caption{Boxplots of $\\PDS$ for all methods and all $n$75 scenarios. $A=",ALLES,"$ and $L=",LOCS-5,"$ ({\\em a}) and $L=",LOCS,"$ ({\\em b}).}",
    	" \\label{fig:suppl_boxplot_A",ALLES,"_Num_",out.file.num,"} \\end{figure}", sep="")
    write(latex_command, file=latex.comms, append=T)
    
    
  }  
}  # closes loop over panel.num
}  # closes loop over ALLES

