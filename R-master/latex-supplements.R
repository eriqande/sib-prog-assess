

# this must be run in the directory that contains the diretory "suppl"
if(any(!file.exists("suppl", "sib-prog-assess.Rproj"))) stop("It appears you are not running latex-supplements.R in the correct directory")


# Names of supplements in desired order
SUPPS <- c("appendices", "smearograms", "boxplots", "biggest_sibship", "running_times") 
COMP_DOC_DIR <- "Compiled_Document"
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
