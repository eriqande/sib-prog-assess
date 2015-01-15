if [ $# -le 2 ]; then
  echo Syntax
  echo "   $(basename $0) CondensedFile  OutputDirectory DIR1 DIR2 DIR3 ....  "
  echo "CondensedFile = name of the file to put the condensed results into
OutputDirectory = name of directory to be created to compute the PD results
DIR1 DIR2 ...  names of directories, usually there by globbing

Example:
  $(basename $0) condensed-new-colony-best-fs-families.txt  FullColony huge-output/{n75,LottaLarge}/Collections/*/l[1-9]*2  
  
"
  exit 1;
fi


CondensedFile="$1"
OutputDirectory="$2"

shift 2

# once you've run colony via 01-run-colony-subset.sh, you can run this script to get
# the partition distances.  

#### Some checks to make sure we are running this in the right directory, etc ####
# check to make sure that we are in the right directory
if [ $(basename $(pwd)) != "colony" ]; then
	echo "You started $0 in the wrong directory.  Must be started in the ./analysis/colony directory"
	echo "Exiting..."
	exit 1
fi

# check to make sure that the other directories we expect to be there are there:
if [ ! -d script ] || [ ! -d bin ] || [ ! -d input ]; then 
	echo "Did not find directories \"script\" or \"bin\" or \"input\".  You must have started the
script $0 in the wrong directory.  Must be started in the ./analysis/colony directory"
	echo "Exiting..."
	exit 1
fi



# check to make sure there is some huge output
if [ ! -d huge-output ]; then
	echo "Did not find directory \"huge-output\".  You need to run 01-run-colony-subset.sh first!"
	echo "Exiting..."
	exit 1
fi



# now, we want to condense all the colony output into a somewhat shorter list of 
# the inferred full sibling groups.  A data frame of those, in fact.
echo "Condensing colony output.  This could take a while..."
# this line picks out all the directories ending with a 2, which means it is the new version of 
# colony (because it doesn't have an "o" on the end)
./script/CondenseColonyResults.sh $@  > $CondensedFile



# now we need to build up the glpk R package, which we install, but we don't use
# it that way because something went awry.  So we dyn.load the .so....
echo "Building glpk source code..."
R CMD INSTALL ../partition-distance-calculation/glpk



# now, get ready to run all the PD scripts.  There are lots of dependencies and so we need to 
# get the absolute path to the directory where all that stuff lives:
export PD_STUFF_DIR=$PWD/../partition-distance-calculation



# and now we run "Poor-Man's Parallel Partition Distances" in two different directories
mkdir $OutputDirectory
cd $OutputDirectory
echo "Launching PoorMansParallel4PDs.sh in $OutputDirectory on $CondensedFile"
$PD_STUFF_DIR/script/PoorMansParallel4PDs.sh ../$CondensedFile


echo "You should now have some R processes running in the backgound and producing 
output, eventually, in directories PmP_XXX where XXX is the number of loci, inside
the directory $OutputDirectory

Once those processes have finished up, it is time to slurp the Partition Distance
results back.

You will do that with the script 03-slurp-up-colony-pds.R"


