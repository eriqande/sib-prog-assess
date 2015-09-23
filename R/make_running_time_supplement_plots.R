OUTDIR <- "./tmp/plots/running_times"


### SET UP WORK AREA, ETC ####
The.SCENS <- c("nosibs","allhalf","allpathalf","sfs_noh","sfs_wh","slfsg_noh","slfsg_wh","onelarge_noh","onelarge_wh", "lotta_large") 
SCEN.latex <- gsub("_","",paste("\\",The.SCENS,sep=""))
names(SCEN.latex) <- The.SCENS
the.SCEN.names <- c("NoSibs", "AllHalf", "AllPatHalf", "SmallSGs", "SmallSGs_H", "BigSGs", "BigSGs_H", "OneBig", "OneBig_H", "LottaLarge")
names(the.SCEN.names) <- The.SCENS

dir.create(OUTDIR)
latex.comms <- file.path(OUTDIR, "running_times_latex_include.tex")
suppressWarnings(file.remove(latex.comms))


### LOAD THE DATA, AND THEN FORMAT IT AND MASSAGE AS NECESSARY ####
load("./scores/prt_archive_03_30_2014.rData")  # get the latest results from Tony

dl <- list(
  c25 = read.csv("./scores/full_colony_new_version_with_times.txt"),
  c25p = read.csv("./scores/full_colony_new_version_pairwise_with_times.txt"),
  c2=read.table("./scores/Colony_Results_All.txt", header=T),
  ki=read.table("./scores/Kinalyzer75s_PDs_and_Time.txt", header=T),
  ff=read.table("./scores/FamilyFinderAll.txt", header=T),
  c2p=read.table("./scores/Colony_Pairwise_Results_All.txt", header=T),
  prt=prt.archive  # these are the results that Tony sent on April 1. (after I put them in a text format).  They differ only in lotta_large from the results in Sept 2012.
)

# fix names from tony's prt_archive results data frame:
names(dl$prt)[1:3]<-c("Scenario", "NumAlleles", "NumLoc" )
names(dl$prt)[8] <- "part.dist2"  # have to change what tony called it.
g<-c("l", "h", "n")  # then make GenoError there too
dl$prt$GenoError <- g[dl$prt$Error.model]
dl$prt$Minutes <- dl$prt$"Time.(ms)"/(1000*60) # and add a minutes column
dl$prt$Number <- as.integer(gsub("r", "", dl$prt$Replication))


# now, drop the other two genotyping error assumptions for colony:
dl$c2 <- dl$c2[dl$c2$gtyp.err.assumption=="d.02m.02", ]

# if you want to see how many of each condition were done, you can do this:
# Note that this will create some partially matched name warnings.
cnts<-lapply(dl, function(x) table(x$GenoEr, x$NumAl, x$NumLo, x$Scen, dnn=c("GenoErr", "Alleles", "Loci", "Scenario")) )



# make sure time is measured on the same scale in all.  Let's use "Minutes"
# first get a Minutes column where we don't have one
dl$ki$Minutes <- dl$ki$Seconds/60.0
dl$ff$Minutes <- dl$ff$real.time.secs/60.0  # just use Real time here.  It doesn't make much difference anyway

# now get a list of data frames that just have just the five classifying columns and Minutes:
dm<-lapply(dl, function(x) x[, c("Scenario","NumAlleles", "NumLoc", "GenoError", "Number", "Minutes")])

for(i in names(dm)) {dm[[i]][["Meth"]] = toupper(i)}

# and, if you want to see how many are non-missing we should be able to do this:
# Note that this will create some partially matched name warnings.
cnts.not.na<-lapply(dm, function(x) {x<-x[!is.na(x$Minutes), ]; table(x$GenoEr, x$NumAl, x$NumLo, x$Scen, dnn=c("GenoErr", "Alleles", "Loci", "Scenario"))} )

# rbind the rows into a long data frame, but drop KI because it is way too high and it screws up
# the plots because the upper ylim is so high
stacked<-rbind(dm$c25, dm$c25p, dm$c2, dm$ff, dm$c2p, dm$prt)

# make sure that the Meth is a factor
stacked$Meth <- factor(stacked$Meth, levels = c("C25", "C2", "C25P", "C2P", "PRT", "FF"))

# now let's refactor GenoError and force the levels to be ordered as we want them to be:
stacked$GenoError <- factor(stacked$GenoError, levels=c("n","l","h"))


### CYCLE OVER THE SCENARIOS AND MAKE THE PLOTS  ####
for(S in The.SCENS) { # cycle over the Scenarios.  One page of plots for each scenario
  ss<-stacked[stacked$Scenario==S,]
  
  # figure out what the name of the file should be
  file.name <- paste("running_times_noki_",S,".pdf", sep="")
  
  # open the pdf device and set 'er up
  pdf(file.path(OUTDIR, file.name), 1.2*11, 1.2*7.3)
  par(oma=c(0,3,3,0))
  par(mar=rep(2.1,4) + c(2, 0 , 0, 0))
  par(mfrow=c(5,5))
  
  for(A in seq(5,25,by=5)) {
    
    for(L in seq(5,25,by=5)) {
      
      pick<-ss$NumAlleles==A & ss$NumLoc==L  # logical vector to pick out the right number of alleles, etc
      
      b.vals <- boxplot(ss$Minutes[pick] ~ ss$Meth[pick], outline=F, boxwex=.5, plot=F)  # get all the info, so we can count up outliers later
      
      
      # make the main plot		
      boxplot(ss$Minutes[pick] ~ ss$Meth[pick], 
              outline=F, boxwex=.2, ylim=c(0, 1.22*max(b.vals$stats[5,], na.rm=T)),
              border="black",
              las = 2
      )
      mtext(paste(A, "Alleles ", L, "Loci"), 3, .85, adj=.5, cex=.76)  # put the title on this way, because it needs to be a little further out than normal
      
      
      # now plot the individual points to the right of each box
      x.tweak<-c(.1, .2, .3) + 0.17
      g.cols<-c("darkturquoise","orange","blue")
      points(as.numeric(ss$Meth[pick])+x.tweak[ss$GenoError[pick]] + runif(n=sum(pick), min=-.03, max=.03), 
             ss$Minutes[pick], 
             col=g.cols[ss$GenoError[pick]], 
             cex=.5
      )
      
      # now get the number and the mean of the outliers which are above the top of the chart
      # and we print those values out near in the top margin of the plot area when they exist
      if(length(b.vals$out)>0) {
        off.chart <- b.vals$out > par("usr")[4]
        if(sum(off.chart>0)) {
          o.grp <- factor(b.vals$group[off.chart])
          o.means <- tapply(b.vals$out[off.chart], o.grp, mean)
          o.cnt <- table(o.grp) 
          mtext(paste( o.cnt, floor(o.means), sep=":"), 3, 0.1, at=as.numeric(levels(o.grp)), cex=.51)
        }
      }
      
      # now, also include the number that PRT did not complete on, in red in the upper right corner:
      num.prt.fail <- max(45 - sum(pick & ss$Meth=="PRT") + sum(is.na(ss$Minutes[pick & ss$Meth=="PRT"])))  # this catches the ones that are just absent (i.e. not just NA---totally absent!)
      if(num.prt.fail > 0) {
        mtext(num.prt.fail, 3, 0.2, adj=1, col="red", cex=.6)
      }
    }
  }
  # put the scenario name at the very top and add Minutes on the left to apply to all the y axes
  mtext(the.SCEN.names[S], 3, 0.5, outer=T, cex=1.45)
  mtext("Minutes", 2, 1, outer=T, cex=1.2, srt=90)
  
  # make a pdf file and write a line to the latex file
  dev.off() 
  write(paste("\\begin{figure}\\includegraphics[width=\\textwidth]{", "../../", OUTDIR, "/", file.name,"} \\caption{Running times of  \\colony{} 2.0.5.2 (C25), \\colony{} 2.0.5.2-P (C25P), \\colony{} 2.0 (C2), \\colony{} 2.0-P (C2P), \\familyfinder{} (FF), and \\prt{} (PRT) in scenario ",SCEN.latex[S], "} \\label{fig:run-time-noki-",S,"} \\end{figure}\\clearpage", sep=""),
        file=latex.comms, append=T)
}


#### Down here we are going to generated the table for the text. ####
library(dplyr)
library(tidyr)

write_running_times_table <- function(LOTTA_LARGE = FALSE) {
  # put kinalyzer back in there
  ST <- rbind(stacked, dm$ki) %>% 
    tbl_df %>%
    filter(!(NumLoc %in% c(3, 7)))
  
  if(LOTTA_LARGE) {
    TMP <- ST %>%
      filter(Scenario == "lotta_large", NumAlleles == 15)
    FILE <- "./sib_assess_tex/running_time_table_lotta_large.tex"
    LEFTCOL <- "\\lottalarge"
  }
  else {
    TMP <- ST %>%
      filter(Scenario != "lotta_large", NumAlleles == 15)
    FILE <- "./sib_assess_tex/running_time_table_n75.tex"
    LEFTCOL <- "$n75$"
  }
  
  SUMS <- TMP %>%
    group_by(Meth, NumLoc) %>%
    summarize(Mean = mean(Minutes, na.rm = TRUE), Min = quantile(Minutes, probs = 0.1, na.rm = TRUE), Max = quantile(Minutes, probs = 0.9, na.rm = TRUE))
  
  
  MeanTimes <- SUMS %>%
    mutate(MeanFmt = sprintf(Mean, fmt = "%.2f")) %>%
    select(Meth, NumLoc, MeanFmt) %>%
    spread(., NumLoc, MeanFmt)
  
  RangeTimes <- SUMS %>%
    mutate(range = paste("{\\sl ", sprintf(Min, fmt = "%.2f"), "--", sprintf(Max, fmt = "%.2f"), "}", sep = "") ) %>%
    select(Meth, NumLoc, range) %>%
    spread(., NumLoc, range)
  
  TAB <- rbind(MeanTimes, RangeTimes) %>% arrange(Meth)
  
  # take care of the family finder stuff
  if(LOTTA_LARGE==FALSE) {
    TAB[TAB$Meth == "FF", -1][1,] <- "$<1$ sec"
    TAB[TAB$Meth == "FF", -1][2,] <- ""
  }
  
  # now we just need to put the proper latexed names in for the software and a couple other tweaks.
  Names <- c("\\colony~{\\sc 2.0.5.2}$^{a,b}$", 
             "\\colony-P~{\\sc 2.0.5.2}$^{a,b}$",
             "\\colony~{\\sc 2.0}$^{a,c}$",
             "\\colony-P~{\\sc 2.0}$^{a,c}$",
             "\\prt$^{d}$",
             "\\kinalyzer$^{a}$",
             "\\familyfinder$^{e}$")
  
  names(Names) <- c("C25", "C25P", "C2", "C2P", "PRT", "KI", "FF")
  
  TAB$Meth <- Names[as.character(TAB$Meth)]
  
  TAB$Meth[c(F,T)] <- ""
  
  names(TAB)[1] <- ""
  
  # now we have to put what type of data set it was in the first line of the first column
  TAB2 <- cbind(LC = "", TAB, stringsAsFactors = FALSE)
  TAB2$LC[1] <- LEFTCOL
  names(TAB2)[1:2] <- ""
  
  if(LOTTA_LARGE==FALSE) {
    write.table(rbind("", TAB2), row.names = FALSE, col.names = TRUE, sep = "  &  ", eol = "\\\\\n", quote = FALSE,
                file = FILE)
  }
  else {
    write.table(TAB2, row.names = FALSE, col.names = FALSE, sep = "  &  ", eol = "\\\\\n", quote = FALSE,
                file = FILE)
  }
  
  NULL
  
}

write_running_times_table()
write_running_times_table(TRUE)