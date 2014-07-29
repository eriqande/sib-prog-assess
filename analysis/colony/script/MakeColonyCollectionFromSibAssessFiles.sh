# Defaults:
NoNum=1;
LO=1;


function usage {
echo "Syntax:
    $(basename $0)  [-l Lo]  [-n Num]  NumAlle  Dir1 Dir2 Dir3 ...  


Lo is the index of the rep to start processing from.  By default it
  is 1.  But, if you do -l 6 -n 15 then the 10 reps with indexes
  from 6 to 15 inclusive will be processed. 

Num is the highest index of reps to do in each directory. If \"-n Num\"
  is omitted then all of the reps in each directory will be done.
  However, if it is included and [-l Lo] is not included, then
  reps 1 through Num will be processed.


Dir is the path of the directory to operate on.  Its basename should
  correspond to one of the simulation types in our sib-prog assess work.
  In fact, it should be one of the directories in the SibAssessDataSets1
  directory that holds all the simulated data sets.  It used the fact that
  it is all within, say, a \"10_Alleles\" directory to figure out how many 
  alleles each data set was simulated with.  So, its path must include that part!
  See function TwoCode for the currently defined simulation scenario names.
  This script lets you process multiple Dirs at once. 
 
Output is a directory called Collections within which are many subdirectories
named by the short codes as given in ShortCodeList.txt (another output file)
that will help make it easy to get back to the
original files given the codes (though they can be recovered without that
because there is some rhyme and reason to them, see my wiki page on:
almudevar_collab:sib_prog_eval_colony

Within each of those subdirectories is a file called genotypes.txt

This Collections directory can be inserted into a ColonyArea and run.

"
}

if [ $# -eq 0 ]; then
    usage;
    exit 1;
fi;

# use getopts so you can pass it -n 50, for example. 
while getopts ":l:n:h" opt; do
    case $opt in
	l    )  LO=$OPTARG
	    ;;
	n    )  Num=$OPTARG
	    NoNum=0;
	    ;;
	h    ) 
	    usage 
	    exit 1
	    ;;
	\?   )
	    usage
	    exit  1
	    ;;
    esac
done

shift $((OPTIND-1));




rm -f ShortCodeList.txt;


# here is a simple shell function that will return a two letter code that corresponds 
# to each possible directory that we might encounter
function TwoCode {
    echo $1 | awk '
BEGIN {
 tc["allhalf"] = "AB";
 tc["allpathalf"] = "AC";
 tc["lotta_large"] = "AD";
 tc["nosibs"] = "AE";
 tc["onelarge_noh"] = "AF";
 tc["onelarge_wh"] = "AG";
 tc["sfs_noh"] = "AH";
 tc["sfs_wh"] = "AI";
 tc["slfsg_noh"] = "AJ";
 tc["slfsg_wh"] = "AK";
}
{ 
 if(!($1 in tc)) 
   print "ERROR";
 else {
   printf("%s",tc[$1]);
 }
}
'
}


# simple shell function.  It coverts an integer (less than 676=26^1*25 + 26^0*25 + 1) 
# into a two-character string where a=0, b=1, ..., z=25
# which is the number in base 25
function Base25_2 {
    echo $1 | \
    awk '
      BEGIN {a="abcdefghijklmnopqrstuvwxyz"}
      {x=int($1/26); y=$1-x*26; printf("%s%s",substr(a,x+1,1),substr(a,y+1,1));}
    '
}



# simple shell function.  It coverts an integer (less than or equal to 26^2*25 + 26*25 + 1*25) 
# into a three-character string where a=0, b=1, ..., z=25
# which is the number in base 25
function Base25_3 {
    echo $1 | \
    awk '
      BEGIN {a="abcdefghijklmnopqrstuvwxyz"}
      {x=int($1/676); y=$1-x*676; z=int(y/26); b=y-z*26; printf("%s%s%s",substr(a,x+1,1),substr(a,z+1,1),substr(a,b+1,1));  }
    '
}



# simple shell function.  It coverts an integer (less than 676=26^1*25 + 26^0*25 + 1) 
# into a two-character string where a=0, b=1, ..., z=25
# which is the number in base 25
function Base25_2_cap {
    echo $1 | \
    awk '
      BEGIN {a="ABCDEFGHIJKLMNOPQRSTUVWXYZ"}
      {x=int($1/26); y=$1-x*26; printf("%s%s",substr(a,x+1,1),substr(a,y+1,1));}
    '
}


mkdir Collections

# here is the main loop for processing the directories:
HowManyDone=0;
while (( "$#" )); do 

    Dir=$1;
    
    # from the path of Dir, get the number of alleles
    AlleDir=$(basename $(dirname $Dir))  # this is the name of the XX_Alleles directory it is inside
    Alle=${AlleDir/_Alleles/}  # here we pull the XX part of the name out as its own number

    # here if NoNum==1 we have to count how many files there are to process:
    if [ $NoNum -eq 1 ]; then
	Num=$(ls $Dir/*_r*_noerr.txt | wc | awk '{print $1}');
    fi

    # get the prefix for the files:
    pre=$(basename $Dir);
    TLC=$(TwoCode $pre);
    if [ $TLC = "ERROR" ]; then
	echo "Sorry! For Dir=$Dir we get pre=$pre which has no two letter code.  ERROR! Exiting." > /dev/stderr;
	exit 1;
    fi
    
    # get the number of alleles in base 25 character string:
    AlleName=$( Base25_2 $Alle)
    
    
    # then we cycle over all the reps that we want and we print stuff out in slg_pipe format
    # with the coding that we want
    GenoErrs=( noerr  d02m01  d06m03 );
    ge=( n l h );
    for((i=$LO;i<=$Num;i++)); do
	rep=`printf %03d $i`;
	
        # print something out so it is easy to get back to the right files later
	echo "PATTERN:  $Dir/${pre}_r${rep}   ${AlleName}${TLC}$(Base25_3 $i)"  >> ShortCodeList.txt;
	for j in 0 1 2; do
	    file=$Dir/${pre}_r${rep}_${GenoErrs[j]}.txt;
	    code=${AlleName}${TLC}$(Base25_3 $i)${ge[j]};
	    
            # tell us the naming conventions:
	    echo "$(fp $file)  $code" >> ShortCodeList.txt;

	    mkdir Collections/$code;
	    
	    # here we spew out the data:
	    le2unix $file | awk -v code=$code '{printf("%s%03d",code,NR); for(i=2;i<=NF;i++) printf("\t%s",$i); printf("\n");}' >  Collections/$code/genotypes.txt;
	done
    done

    HowManyDone=$(( $HowManyDone + 1 )); # add one more.
    shift;
done