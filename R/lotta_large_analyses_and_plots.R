
load("./scores/prt_archive_03_30_2014.rData")

dl <- list(
	co=read.table("./scores/Colony_Results_All.txt", header=T),
	ki=read.table("./scores/Kinalyzer75s_PDs_and_Time.txt", header=T),
	ff=read.table("./scores/FamilyFinderAll.txt", header=T),
	cp=read.table("./scores/Colony_Pairwise_Results_All.txt", header=T),
	prt=prt.archive   #read.table("../PRT_results_all.txt", header=T)  # these are the results that Tony sent on July30. (after I put them in a text format).  They differ only in lotta_large from the results in Sept 2012.
)

# fix names from tony's prt_archive results data frame:
names(dl$prt)[1:3]<-c("Scenario", "NumAlleles", "NumLoc" )
names(dl$prt)[8] <- "part.dist2"  # have to change what tony called it.
g<-c("l", "h", "n")  # then make GenoError there too
dl$prt$GenoError <- g[dl$prt$Error.model]
dl$prt$Minutes <- dl$prt$"Time.(ms)"/(1000*60) # and add a minutes column

# now, drop the other two genotyping error assumptions for colony:
dl$co <- dl$co[dl$co$gtyp.err.assumption=="d.02m.02", ]

# if you want to see how many of each condition were done, you can do this:
cnts<-lapply(dl, function(x) table(x$GenoEr, x$NumAl, x$NumLo, x$Scen, dnn=c("GenoErr", "Alleles", "Loci", "Scenario")) )



# make sure time is measured on the same scale in all.  Let's use "Minutes"
# first get a Minutes column where we don't have one
dl$ki$Minutes <- dl$ki$Seconds/60.0
dl$ff$Minutes <- dl$ff$real.time.secs/60.0  # just use Real time here.  It doesn't make much difference anyway


# use this to see that there are no results for Kinalyzer (i ditched those
# earlier in the process because it just couldn't finish any except small 
# numbers of loci and alleles).
lapply(dl,function(x) table(x$Scenario)["lotta_large"])

# remove the kinalyzer one
dl$ki<-NULL


# let's put this all into long format
temp <- lapply(names(dl), function(y) {x<-dl[[y]]; x[x$Scenario=="lotta_large", c("Scenario", "NumAlleles", "NumLoc", "GenoError", "part.dist2", "Minutes")]})
names(temp)<-names(dl)
bb<-do.call(rbind, lapply(names(temp), function(y) {x<-temp[[y]]; cbind(toupper(y),x) }))
names(bb)[1]<-"Meth"


# order the factor labels as we want to:
bb$Meth <- factor(bb$Meth, levels=c("CO", "CP", "PRT", "FF"))
bb$GenoError <- factor(bb$GenoError, levels=c("n", "l", "h"))


# now, make a bunch of big boxplots:
# quartz(width=10, height=6.4)  # uncomment for one run through to get the right size window
pdf(file="lotta_large_boxplots.pdf", 10.5, 6) # make the plot window the size we want it
par(mfrow=c(5,5))
par(mar=c(1,2,0,1))
par(oma=c(2,6,4,0))
for(A in seq(5,25, by=5)) {
	for(L in seq(5,25, by=5)) {
		pick <- bb$NumAlleles==A & bb$NumLoc==L
		x <- bb[pick,]
		boxplot(part.dist2~GenoError+Meth, x, 
			at=1:3 + rep(c(0,5,10,15),each=3),
			xlim=c(0,19),
			axes=F
		)
		box()
		axis(2)
		axis(1, at=c(0,5,10,15)+2, 
			labels={if(A==25) {c("CO", "CP", "PRT", "FF")} else FALSE}, 
			tck={if(A==25) {-.083} else -.12},
			cex.axis=1.2)
	}	
}	
mtext("Number of Loci", 3, 2.5, T)
mtext(paste(seq(5,25,by=5)), 3, 0.5, T, adj=(1:5 - .45)/5)


mtext("Number of Alleles", 2, 4.5, T)
mtext(paste(seq(5,25,by=5)), 2, 2.8, T, at=(5:1 - .5)/5, las=1)
mtext(expression(PD[S]), 2, 0.4, T, at=(5:1 - .4)/5, cex=.7)

dev.off()


#### OK, now let's look at the new version of colony with the anti-split correction ####
# we will do this with ggplot 
col2 <- read.table("./scores/Colony_do_over_with_new_version.txt", header = T)
dl$c2 <- col2
names(dl) <- toupper(names(dl))  # make the names uppercase
library(plyr)
df <- ldply(dl)  # make one big data frame out of all of them
df$Prog <- factor(df$".id", levels = c("C2", "CO", "CP", "PRT", "FF")) # make Program a factor with levels in order we want them in 
dfl <- df[df$Scenario == "lotta_large" & df$NumLoc == 10, ] # restrict it to just 10 loci
geqc <- c(n = "d = 0, m = 0", l = "d = 0.03, m = 0.01", h = "d = 0.07, m = 0.03")
dfl$GenoErrText <- factor(geqc[as.character(dfl$GenoError)], levels = geqc)  # make a text specification of the genotyping error rates



library(ggplot2)
g <- ggplot(dfl, aes(x = Prog, y = part.dist2)) +
  geom_boxplot() + 
  facet_grid(GenoErrText ~ NumAlleles) +
  xlab("Program / Version") + 
  ylab("Partition Distance")

ggsave(filename = "new-colony-boxplots-10-loci.pdf", plot = g, width = 12.0, height = 5.2)

