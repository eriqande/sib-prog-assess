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
./script/CondenseColonyResults.sh huge-output/{n75,LottaLarge}/Collections/*/l[1-9]*2  > condensed-new-colony-best-fs-families.txt

# here we pick out results from the old version of colony (directories ending in "o")
./script/CondenseColonyResults.sh huge-output/{n75,LottaLarge}/Collections/*/l[1-9]*o  > condensed-old-colony-best-fs-families.txt


# now we need to build up the glpk R package, which we install, but we don't use
# it that way because something went awry.  So we dyn.load the .so....
echo "Building glpk source code..."
R CMD INSTALL ../partition-distance-calculation/glpk



# now, get ready to run all the PD scripts.  There are lots of dependencies and so we need to 
# get the absolute path to the directory where all that stuff lives:
export PD_STUFF_DIR=$PWD/../partition-distance-calculation



# and now we run "Poor-Man's Parallel Partition Distances" in two different directories
mkdir OldColony NewColony
cd OldColony
echo "Launching PoorMansParallel4PDs.sh on Old Colony Results"
$PD_STUFF_DIR/script/PoorMansParallel4PDs.sh ../condensed-old-colony-best-fs-families.txt

cd ../NewColony
echo "Launching PoorMansParallel4PDs.sh on New Colony Results"
$PD_STUFF_DIR/script/PoorMansParallel4PDs.sh ../condensed-new-colony-best-fs-families.txt

echo "You should now have some R processes running in the backgound and producing 
output, eventually, in directories PmP_XXX where XXX is the number of loci, inside
the directories OldColony and NewColony

Once those processes have finished up, it is time to slurp the Partition Distance
results back."


