
# note that pd_path should be already defined.  Basically it is Sys.getenv("PD_STUFF_DIR") 

 # this is to get the glpk stuff to call.  No longer can use library to get it
dyn.load(file.path(pd_path, "glpk/src/glpk.so"))
source(file.path(pd_path, "glpk/R/glpk.R"))
source(file.path(pd_path, "glpk/R/lpx.R"))
source(file.path(pd_path,"R/TonyLibrary.R"))
 


# a function to take a data frame x with fields Code and SibSet
# and a Code code.  This will then return the partition (or set cover)
# as a sorted list. It also returns the sizes of the sets. The total number
# of entries and the total number of distinct elements, and the number of
# elements that appear more than once.
#
# there is another option to add a vector of values that should be removed
# from any of the sets.  This is done so that I can toss out singletons (and
# perhaps doubletons) if desired.
GetSets <- function(x,code, rem=c()) {
  y <- x[ x$Code==code, ];
  sets <- list();
  n <- length(y$SibSet);  # number of sets in the cover or partition
  sizes <- rep(0,times=n);

  #print(paste("Getting Sets: C=",C));
  #print(paste("Getting Sets: rem=",rem));
  if(length(rem)==0) { 
    for(i in 1:n) {
      #print(paste("i=",i));
      #print(paste("y$SibSet[i]=",y$SibSet[i]));
      sets[[i]] <- sort(as.integer(strsplit(as.character(y$SibSet[i]),split=",",fixed=TRUE)[[1]]));
      sizes[i] <- length(sets[[i]]);
    }
  }
  else {
    j<-0;
    for(i in 1:n) { 
      tempset <- sort(
                      setdiff(
                              as.integer(strsplit(as.character(y$SibSet[i]),split=",",fixed=TRUE)[[1]]),
                              unique(rem))
                      );
      if(length(tempset)>0) {
        j<-j+1;
        sets[[j]] <- tempset;
        sizes[j] <- length(sets[[j]]);
      }
    }
    sizes <- sizes[1:j]; # chop off the extra length
  }
  

  # now count some stuff
  ul <- unlist(sets);
  num.entries <- length(ul);
  num.distinct <- length(unique(ul));
  num.more.than.once <- sum(table(ul)>1);
  
  return(list(code=code,sets=sets,sizes=sizes,
              num.entries=num.entries,
              num.distinct=num.distinct,
              num.more.than.once=num.more.than.once));
}





# given a list of vectors L, this function will
# return a vector of the elements that occur ONLY in vectors
# less than or equal to length Sz.  It is meant to operate
# on the sets field of the object returned by GetSets.  This
# should probably only be used on those objects that don't
# have duplicated elements.  It will be used to get a vector of
# values to be dropped in the PD estimate when one ignores singletons
# and doubletons, for example.  Note that if the sets are a set cover
# and not a partition, then if, for example, element 12 appears in a
# set of size 1, but also appears in a set of size 4, then it will
# not appear in the output.
ElemInShortVecs <- function(L,Sz=2) {
  xx <- list();
  yy <- list();
  j<-0;
  k<-0;
  for(i in L) {
    if(length(i)<=Sz) {
      j<-j+1;
      xx[[j]]<-i;
    }
    else {
      k <- k+1;
      yy[[k]]=i;
    }
  }
  return(sort(
              setdiff(
                      unique(unlist(xx)), unique(unlist(yy))
                      )
              )
         );
}



# just a quick thing to compute the partition distance (via MLAP) between
# a partition (truth) and a set cover or partition (est).  Returns a list with the "raw" partition distance,
# (i.e. as the Kinalyzer group computes it, as well as accounting for duplicate
# entries.  Takes as input the outputs of GetSets.
# return fields:
#  v : the number of things that "line up"
# pd : the partition distance (num entries in truth (a partition) minus v
# ndupe : number of elements in est that appear more than once
PD <- function(truth, est) {

  # first we just compute the PD via the MLAP between truth and est
  # the way the Kinalyzer group does (i.e. not penalizing if est is a
  # set cover and not a partition.  We can compute the more correct
  # version separately using the same function
  b.obj <- convert.subsets.2(truth$sets,est$sets);
  b<-BA.function(b.obj);
  v=b$v;
  pd=truth$num.entries-v;
  ndupe=est$num.more.than.once;


  return(list(v=v, pd=pd, ndupe=ndupe) );

}
