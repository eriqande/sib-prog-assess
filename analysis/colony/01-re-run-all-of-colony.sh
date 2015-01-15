#### This is a bash shell script to run a subset of the colony analyses  ####





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

# check to make sure that there is a directory /tmp
if [ ! -d /tmp ]; then
	echo "This script wants to store a lot of stuff in a directory called /tmp.  There
appears to be no such directory, which suggests that we are not operating in a sane
Unix environment here. Thus I doubt things will work downstream anyway!"
	echo "Exiting..."
	exit 1
fi

# store location of this directory:
CURDIR="$PWD"





#### Download the data sets and extract them to the /tmp directory  ####

# get the simulated data sets from Dropbox.  Ultimately we will change this to the 
# Dryad site
if [ -d /tmp/SibAssessDataSets1 ]; then 

	echo "It appears you already have the simulated data sets in the directory 
\"/tmp/SibAssessDataSets1\".  Consequently we will not download them, but rather use
those that are already there.  If you do want to download fresh ones, then please 
remove the directory \"/tmp/SibAssessDataSets1\"."

else 
	echo "Downloading and extracting the data sets..."
		curl -o /tmp/SibAssessDataSets1.tar.gz  https://dl.dropboxusercontent.com/u/19274778/SibAssessDataSets1.tar.gz &&  \
		cd /tmp &&  echo "gunzipping archive...soon to be untarring it...That will take a while!"  && \
		gunzip SibAssessDataSets1.tar.gz  && \
		tar -xvf SibAssessDataSets1.tar
fi	

# cd back to the directory we started in
cd $CURDIR 





#### Prepare the data files we wish to analyze and format them for easy running of Colony ####

# here are the scenarios and data sets we wish to pick out:
# all the n75 scenarios 5-25 loci and 5-25 alleles, reps 1-15
# lotta_large 5-25 loci and 5-25 alleles, reps 1-5

# note that we want to use the new version of Colony and we want to
# use the Ewens prior on sibship sizes.

# So, we make some commmand lines that will pick these out..
mkdir -p huge-output
cd huge-output

echo
echo "Setting up directory structure for colony analyses"
echo "    Setting up LottaLarge data sets"
mkdir -p LottaLarge  # give these their own directory
cd LottaLarge  
# grab the lotta larges
../../script/MakeColonyCollectionFromSibAssessFiles.sh -n 5 /tmp/SibAssessDataSets1/{5,10,15,20,25}_Alleles/lotta_large/


cd $CURDIR/huge-output
mkdir -p n75
cd n75
echo "    Setting up some n75 data sets"
../../script/MakeColonyCollectionFromSibAssessFiles.sh -n 15 /tmp/SibAssessDataSets1/{5,10,15,20,25}_Alleles/{allhalf,onelarge_noh,sfs_noh,slfsg_noh,allpathalf,nosibs,onelarge_wh,sfs_wh,slfsg_wh}/
echo



####  Now we run Colony
# note that I can run colony like this to use the old version of colony and put output in 
# a directory called "OldColony"  (note that the -o option tells it to use the old colony)
#    ./script/SimpleColonyRun.sh -l 10 -L -o  huge-output/n75/Collections/akABaabn OldColony input 0 
# and I can run it with the new colony like this:
#    ./script/SimpleColonyRun.sh -l 10 -L  huge-output/n75/Collections/akABaabn NewColony input 0
#


######### Here we make some stuff to run these all in parallel.
# Now we prepare a list of commands to pipe to the GNU parallel script that will queue up a bunch 
# of colony runs.  We do this for all the different data sets and also for different numbers of 
# loci and different colony options:
cd $CURDIR   # get back to the correct top directory



# 1. do the  n75 data sets using the new version of colony. Be sure to use the
# -f option to infer allele freqs taking account of sibship structure
for NUMLOC in 5 10 15 20 25; do
	OPTSTR=" -l $NUMLOC -L -f -d .02 -m .02  ";
	OPTNAME=$(echo $OPTSTR | sed 's/ //g; s/-//g;')
	./script/RunAllColony.sh -f -d huge-output/n75/Collections -o " $OPTSTR "  $OPTNAME 0 4 
done > colony-commands-for-parallel.txt 




# 2. compile up the commands to do the lotta_large data sets.  Use the -f option!
# Once again append this stuff to colony-commands-for-parallel.txt 
for NUMLOC in 5 10 15 20 25; do
	OPTSTR=" -l $NUMLOC -L -f -d .02 -m .02  ";
	OPTNAME=$(echo $OPTSTR | sed 's/ //g; s/-//g;')
	./script/RunAllColony.sh -f -d huge-output/LottaLarge/Collections -o " $OPTSTR "  $OPTNAME 0 4 
done >> colony-commands-for-parallel.txt 

# finally, we make a simple script to launch under nohup.  This requires that GNU parallel is on the system!
# It is set here to put stuff onto 16 cores
echo "cat colony-commands-for-parallel.txt | parallel -P 16 "   > run-colony-in-parallel.sh
chmod u+x run-colony-in-parallel.sh


# now we can just run that script...
echo "Starting up the colony runs as listed in colony-commands-for-parallel.txt"
echo "Consult the file ColonyRuns_ProgressLog.txt to see how those runs are coming along..."
nohup ./run-colony-in-parallel.sh &


























