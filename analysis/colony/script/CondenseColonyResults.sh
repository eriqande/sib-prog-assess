

# put default values here
QUIET=0;



function usage {
      echo Syntax:
      echo "  $(basename $0) " [-h] [-q] Dir1 Dir2 Dir3 ...
      echo
      echo " -h  : print help and exit
 -q  : Quiet: don't notify me if some directories are missing necessary 
              result files.  Otherwise, these notifications are burped out
              to stderr.
 Dir1 Dir2  ... : the directories that have the file ending with \".BestFSFamily\".
       Ultimately I may process other files in those directories.  Note that 
       it is essential that the prefix on those files be of the form
       Code_conditions like:  afABaabh_l15Lfd.02m.02.BestFSFamily
"  
}

if [ $# -eq 0 ]; then
    usage;
    exit 1;
fi;

while getopts ":hq" opt; do
    case $opt in
	h    ) 
	    usage
	    exit 1
	    ;;
	q    )  QUIET=1;
	    ;;
	\?   )
	    usage
	    exit  1
	    ;;
    esac
done

shift $((OPTIND-1));


echo "Code    NumLoc    FreqWeighting   ColonyErrOpts  ProbScore   SibSize  SibSet"

while (($#)); do
    DIR=$1;
    FILE=$DIR/*.BestFSFamily;
    if [ -f $FILE ]; then
	NAME=$(basename $FILE);
	TAG=$(echo $NAME | awk '{split($1,a,/_/); code=a[1]; sub(/l/,"  ",a[2]); sub(/L/,"  ",a[2]);  gsub(/f/,"   f    ",a[2]); gsub(/\.BestFSFamily/,"",a[2]); print a[1],a[2];}');

	awk '/FullSibshipIndex/ || NF==0 {next} {printf("   %s   %d   ",$2,NF-2); for(i=3;i<=NF;i++) { a=$i; gsub(/[^0-9]/,"",a); printf("%d,",a);} printf("\n")}' $FILE | \
	    sed 's/,$//g;' | \
	    sort -n -b -r -k 2 | \
	    awk -v tag="$TAG" '{print tag,$0}' 
    else
	if [ $QUIET -eq 0 ]; then
	    echo "Found no BestFSFamily file in directory $(fp $DIR)" > /dev/stderr;
	fi
    fi
    shift;
done
