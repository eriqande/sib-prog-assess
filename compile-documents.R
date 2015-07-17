# This is the main R script that will create the plots and latex
# The documents.  

# Source it from the directory that contains sib-proj-assess.Rproj
# It will create the directory Compiled_Documents that has all the typeset
# PDFs in it.


# check that you are in the right directory
if(any(!file.exists("suppl", "sib-prog-assess.Rproj"))) stop("It appears you are not running compile-documents.R in the correct directory")



#### Generate the supplement plots.  Output goes to ./tmp/plots/ ####
source("R/all_smearograms.R")  # make the smearogram plots.  Ouput goes to ./tmp/plots/smearograms

######## THIS NEEDS TO BE REDONE STILL ##########
source("R/BiggestSibshipAndSingletons.R") # output goes to ./tmp/plots/biggest_sibship


source("R/make_boxplots.R")   # output goes to  ./tmp/plots/boxplots

######## THIS NEEDS TO BE REDONE STILL ##########
source("R/make_running_time_supplement_plots.R")  # output goes to  ./tmp/plots/running_times




#### Generate the figures for the main document
source("R/make-main-text-figures.R")

# now I need to copy all those new figures to sib_assess_tex/images
# I have this set to not do it automatically, since those images get
# committed with the repository
for(file in c("boxplots_for_paper10_num1.pdf",  "boxplots_for_paper25_num2.pdf",  "lotta_large_boxplots.pdf",      
              "prt_ff_and_col_pair_smears.pdf", "various_kina_smears.pdf")) {
  file.copy(file.path("tmp/plots/figures_for_main_paper", file), 
            file.path("sib_assess_tex/images/", file),
            overwrite = TRUE)
  print(file)
}



#### LaTeX the supplement plots.  Output created in subdirectories
#### under ./suppl and final PDFs are copied to Compiled_Documents  ####
# Names of supplements in desired order
SUPPS <- c("appendices", "smearograms", "boxplots", "biggest_sibship", "running_times") 
COMP_DOC_DIR <- "Compiled_Documents"
dir.create(COMP_DOC_DIR)

curdir <- getwd()

M<-1
for(i in SUPPS) {
  setwd(file.path(curdir, "suppl", i))
  latex_call <- paste("latexmk -pdf", i)
  system(latex_call)
  final.file.name <- paste("suppl_", M, "_", i, ".pdf", sep="")
  file.copy(paste(i, "pdf", sep="."), file.path(curdir, COMP_DOC_DIR, final.file.name))
  M <- M + 1
}

# at the end, change back to the original directory
setwd(curdir)

# and then a very important step: transfer the .aux files (and for some reason
# they need a little processing) over to sib_assess_tex so that the 
# cross references to the supplement figures come out correctly.
# the following call updates sib_assess_tex/suppl_cross_refs.aux
system("./script/CompileSuppRefs.sh")




#### LaTeX the 2-column and the 1-column version of the main document   ####
setwd(file.path(curdir, "sib_assess_tex"))
system("latexmk -pdf sib_prog_eval_two_columns")   # make the two column version

# now we generate a main-body-text file with no starred sidewaysfigures for the one column version
mbt <- readLines("main-body-text.tex")
mbtns <- gsub("sidewaysfigure\\*", "sidewaysfigure", mbt)  # remove the *'s
cat(mbtns, sep="\n", file = "main-body-text-one-col.tex")

# then latex the one column version
system("latexmk -pdf sib_prog_eval")

# now copy those documents to the compiled docs directory
file.copy(c("sib_prog_eval_two_columns.pdf", "sib_prog_eval.pdf"), file.path(curdir, COMP_DOC_DIR))

# at the end, change back to the original directory
setwd(curdir)

