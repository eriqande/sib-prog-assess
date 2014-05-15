


# gotta be sure that you are in the same directory as sib-prog-assess.Rproj
# then go for it


source("R/all_smearograms.R")  # make the smearogram plots.  Ouput goes to ./tmp/plots/smearograms
source("R/BiggestSibshipAndSingletons.R") # output goes to ./tmp/plots/biggest_sibship
source("R/make_boxplots.R")   # output goes to  ./tmp/plots/boxplots
source("R/make_running_time_supplement_plots.R")  # output goes to  ./tmp/plots/running_times

