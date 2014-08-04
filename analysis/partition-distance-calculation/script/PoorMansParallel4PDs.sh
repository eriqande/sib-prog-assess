

# put default values here
# VAR=default
COMPILEPD=/Users/eriq/Documents/work/prj/HansSib/party_dist_calc_code/CompilePDs.R



function usage {
      echo Syntax:
      echo "  $(basename $0) PathToPartitionFile

This function will break the file of inferred partitions into a bunch of different ones
(one for each value of the number of loci) and cycle over all the
different reps in it and run the CompilePDs.R script on each one.  "
      echo
}

if [ $# -eq 0 ]; then
    usage;
    exit 1;
fi;

while getopts ":h" opt; do
    case $opt in
	h    ) 
	    usage
	    exit 1
	    ;;
	#m    )  VAR=$OPTARG;
	#    ;;
	\?   )
	    usage
	    exit  1
	    ;;
    esac
done

shift $((OPTIND-1));


# uncomment to test for right number of required args
if [ $# -ne 1 ]; then
    usage;
    exit 1;
fi

FILE=$1;


# first, figure out the string of locus numbers
LOCNUMS=$(awk '
 NR==1 {for(i=1;i<=NF;i++) {if($i=="NumLoc") L=i;} next}
 {n[$L]++}
 END {for(i in n) printf(" %d ",i);}' $FILE);

echo $LOCNUMS;


# now get headers in all the files you will break this stuff into.  Put them into
# pmp directories:
for i in $LOCNUMS; do mkdir -p PmP_$i; head -n 1 $FILE > PmP_$i/dat.txt; done


# now break FILE up an append into those files: 
awk ' 
 NR==1 {for(i=1;i<=NF;i++) {if($i=="NumLoc") L=i;} next}
 {file=sprintf("PmP_%d/dat.txt",$L); print $0 >> file}
' $FILE 


# now make an R script in each one:
for i in $LOCNUMS; do 
    (echo "EFile <- read.table(\"dat.txt\",header=T);"; echo; echo; cat $COMPILEPD) > PmP_$i/rscript.R; 
done 


# now we start each of those under nohup:
for i in $LOCNUMS; do 
    cd PmP_$i;  
    nohup R CMD BATCH rscript.R  big_output.txt  & 
    echo Started $i;  
    cd ..; 
done 
