

pd_path <- Sys.getenv("PD_STUFF_DIR")  # get the absolute path of the directory with all the partitiion distance stuff in it


# get the library of functions to use
source(file.path(pd_path, "R/SibAssessRfunctions.R"));


# path to the file with all the true partitions in it 
TFile <- read.table(file.path(pd_path, "input/TruePartitions.txt"),header=T)


# read the file with the estimated partitions.  Here we have a default, but you could always open an R session and read the EFile from a different place first.
# the exists test didn't seem to be working so I just coerced it to fail, then commented it out, since this will run through my poor mans parallelization script anyway.
#if(0 && !exists("EFile")) {
#  EFile <- read.table("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/play/ColonyPartial.txt",header=T)
#}




# these are for storing the output
cc <- c();
pd <- c();
pdsc <- c();
tr.pd <- c();  # the tr means "after trimming mutual single- and doubletons
tr.pdsc <- c();
tr.num <- c();
numl <- c();
num.duped <- c();
num.duped.tr <- c();

cnts <- 0;

for (L in levels(as.factor(EFile$NumLoc))) {  # cycle over the number of loci that have been done
  print(L);
  EF.L <- EFile[ EFile$NumLoc==L,];  # restrict our focus to L loci

  for (C in levels(EF.L$Code)) {

     if(length(EF.L$SibSet[ EF.L$Code==C])>0) {  # this is a klugie catch for now because it seems to cycle over values of C that have no data!

       #length(EF.L$SibSet[ EF.L$Code=="akACaael"])


       # MLAP with no correction for non-partitions
       #print("Getting Sets for Uncorrected MLAP");
       est<-GetSets(EF.L,C);
       base<-substr(x=as.character(C),1,7);  # get canonical name of the code (without n,h,l on the end)
       truth<-GetSets(TFile,base);
       res<-PD(truth,est);
       

       # now we get the same thing, but remove the ones that need removing
       t<-table(unlist(est$sets));
       rem.from.sc <- as.numeric(names(t)[t>1]);
       dup.elem <- length(rem.from.sc);
       if(dup.elem==0) {
         res.sc = res;
       }
       else {
         #print(paste("About to get sets for est2. rem.from.sc=",rem.from.sc));
         est2 <- GetSets(EF.L,C,rem=rem.from.sc);
         if(est2$num.distinct==0) { # if everyone was duplicated and hence removed
           
           res.sc <- res;
           res.sc$pd <- est$num.distinct;  # PD is just the total number of individuals because we penalize for each one
         }
         else {
           #print(paste("About to get sets for truth2. rem.from.sc=",rem.from.sc));
           truth2 <-GetSets(TFile,base,rem=rem.from.sc);
           res.sc <- PD(truth2,est2);
           res.sc$pd <- res.sc$pd + dup.elem; # here we increase the pd for the dupes we had to delete.
         }
       }

       

       # now, we do the trimmed PD estimates, by dumping from both collections of sets, all those elements that
       # appear only in sets of two or less in BOTH the truth and the estimate.
       sub2.est <- ElemInShortVecs(est$sets);
       sub2.truth <- ElemInShortVecs(truth$sets);
       if(length(sub2.est)>0 && length(sub2.truth)>0) {
         sub2.rem <- intersect(sub2.est,sub2.truth);  # these are the ones to remove
       }
       else {
         sub2.rem <- integer(0);
       }

       #print(paste("About to get sets for est.tr."));
       est.tr <- GetSets(EF.L,C,rem=sub2.rem);

       #print(paste("About to get sets for truth.tr. sub2.rem="));
       truth.tr <- GetSets(TFile,base,rem=sub2.rem);

       if(truth.tr$num.entries==0) {
         res.tr <- res;  # have to add this for the case where nothing is remaining on the first set looked at
         res.tr.sc <- res.tr;  # gotta add this too
         dup.elem.tr <-	0; # and this too
         res.tr$pd <- NA;
         res.tr.sc$pd <- NA;
       }
       else {
         res.tr <- PD(truth.tr,est.tr);
         
         # and here we do a version of the trimmed one that penalizes the non-partition solution:
         t<-table(unlist(est.tr$sets));
         rem.from.tr.sc <- as.numeric(names(t)[t>1]);
         dup.elem.tr <- length(rem.from.tr.sc);
         if(dup.elem.tr==0) {
           res.tr.sc = res.tr;
         }
         else {
           #print(paste("About to get sets for est3. rem.from.tr.sc=",rem.from.tr.sc));
           est3 <- GetSets(EF.L,C,rem=rem.from.tr.sc);
           if(est3$num.distinct==0) { # if everyone was duplicated and hence removed
             res.tr.sc = res.tr;
             res.tr.sc$pd <- est.tr$num.distinct;  # PD is just the total number of individuals because we penalize for each one
           }
           else {
             #print(paste("About to get sets for truth3. rem.from.tr.sc=",rem.from.tr.sc));
             truth3 <-GetSets(TFile,base,rem=rem.from.tr.sc);
             res.tr.sc <- PD(truth3,est3);
             res.tr.sc$pd <- res.tr.sc$pd + dup.elem.tr; # here we increase the pd for the dupes we had to delete.
           }
         }
       }
       
       cnts <- cnts + 1;
       
       cc[cnts]<-C;
       pd[cnts]<-res$pd
       pdsc[cnts]<-res.sc$pd
       
       tr.pd[cnts]<-res.tr$pd
       tr.pdsc[cnts]<-res.tr.sc$pd

       tr.num[cnts] <- truth.tr$num.entries

       num.duped[cnts] <- dup.elem;
       num.duped.tr[cnts] <- dup.elem.tr;
       numl[cnts] <- L
     }
     
   }
}

Res.DF <- data.frame(Code=cc,NumLoc=numl,part.dist=pd, part.dist2=pdsc, trimmed.part.dist=tr.pd, trimmed.part.dist2=tr.pdsc, trimmed.num=tr.num, num.dupl.elems=num.duped, num.dupl.when.trimmed=num.duped.tr);

write.table(Res.DF,file="party_distances.txt",sep="\t", quote=F, row.names=F);
