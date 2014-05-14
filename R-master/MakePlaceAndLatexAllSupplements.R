


##### ------------------------------------------------------
##### Make supplement 1  --  The Smearograms
# 1. Make all the plots and put them in a folder /tmp/sib_assess_plots
#    Note that this takes a few minutes
source("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/all_smearograms.R")

# 2. Copy the latex input file created in 1 to the latex directory:
file.copy("/tmp/sib_assess_plots/OrderedListOfFiles.txt", 
          "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl1/suppl1_figure_calls.tex",
          overwrite=T
          )
          

# 3. pdflatex the supplement.  Three times to get all the references correct
setwd("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl1")
lapply(1:3, function(x) system("pdflatex suppl1.tex"))









##### -----------------------------------------------------------
##### Make supplement 2
# 1. Copy over the mega_boxplots from the plot directory
#    NOTE DEPENDENCY: those mega_boxplots should have been recreated with the latest output
#    using the script: /Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/MakeAndPlaceAllMainTextFigures.R
bpfiles <- paste("mega_boxplot_alles", rep(seq(5, 25, 5), each=3), "_num", 1:3, ".pdf", sep="")
FROMDIR <- "/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot"
TODIR <- "/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl2"
file.copy(file.path(FROMDIR, bpfiles), TODIR, overwrite=T)

# 2. Copy over the latex input file created when the boxplots were made
file.copy(file.path(FROMDIR, "suppl2_boxplot_figure_calls.tex"), TODIR, overwrite=T)

# 3. pdflatex the supplement. Three times to get the references right.
setwd("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl2")
lapply(1:3, function(x) system("pdflatex suppl2.tex"))








##### -----------------------------------------------------------
##### Make supplement 3
# 1. First make the plots (and this also puts them in the suppl3 latex folder):
source("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/ProcessingOutputs/script/BiggestSibshipAndSingletons.R")
#  NOTE: If anything has changed in the output, you have to go back and regenerate some intermediate
#  lists and data frames after modifying the above file to reflect the new changed data.  To do that you 
#  will set REGENERATE_SAVED_DATA to TRUE in the above sourced BiggestSibshipAndSingletons.R script.  It takes a **LONG** time to re-crunch
#  everything.  It would be nice to be able to update just part of the output, but I don't have that
#  set up.  REGENERATE_SAVED_DATA should be FALSE most of the time.

# 2. pdflatex the supplement. Three times to get the references right.
setwd("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl3")
lapply(1:3, function(x) system("pdflatex suppl3.tex"))







##### ----------------------------------------------------------------------------------
##### Make supplement 4 (running time boxplots)
# 1. First make all the plots
source("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/FinalOutputs/plot/make_running_time_supplement_plots.R")

# 2. Copy the output files to the latex directory
SUPP4DIR <- "/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl4"
system(paste("cp running_times_*.pdf ", SUPP4DIR))
system(paste("cp running_times_latex_include.tex ", SUPP4DIR))

# 3. latex the supplement.  Three times to get references right.
setwd("/Users/eriq/Documents/work/prj/AlmudevarCollab/SibProgramsEvaluation/doc/suppl4")
lapply(1:3, function(x) system("pdflatex suppl4.tex"))







##### ------------------------------------------------------------
##### Process and copy over the file of cross references to the sib_assess_tex folder
##### so that the cross references in the main document are right.
setwd("/Users/eriq/prj/AlmudevarCollab/SibProgramsEvaluation/doc")
system("./CompileSuppRefs.sh")












