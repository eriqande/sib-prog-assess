#### This is a bash shell script to run a subset of the colony analyses  ####





#### Some checks to make sure we are running this in the right directory, etc ####
# check to make sure that we are in the right directory
if [ $(basename $(pwd)) != "colony" ]; then
	echo "You started $0 in the wrong directory.  Must be started in the ./analysis/colony directory"
	echo "Exiting..."
	exit 1
fi

# check to make sure that the other directories we expect to be there are there:
if [ ! -d script ] || [ ! -d colony-arena-parts ]; then 
	echo "Did not find directories \"script\" or \"colony-arena-parts\".  You must have started the
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
# lotta_large  10 Loci, all alleles reps 1-5
# no_sibs 5 and 10 loci 10 alleles reps 1-15
# allhalf 5 and 10 loci 10 alleles reps 1-15

# So, we make some commmand lines that will pick these out with 