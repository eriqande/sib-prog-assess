# sib-prog-assess

This is LaTeX code to typeset a paper I wrote with Anthony Almudevar for Molecular Ecology Resources that evaluates a variety of sibship reconstruction software programs using simulated microsatellite data.  We are planning to submit it in July 2014. We are just awaiting the conclusion of the internal NMFS review process before sending it in.

It also includes a lot of data and scripts to create most of the plots for the paper.

Here are some quick instructions on reproducing the documents, assuming you have R and LaTeX on your system.
```
# clone the repository 
git clone https://github.com/eriqande/sib-prog-assess.git

# then, from within R, navigate to the sib-prog-assess
# directory (top level of the repository) and do this in R:

install.packages("reshape")  # if you don't have the reshape package
source("compile-documents.R")

```
The plots are made and placed in subdirectories of `./tmp/plots`.  You shouldn't need to deal with these ever, as they will get placed into the PDF files where they need to be

The PDF documents are typeset and placed into `./Compiled_Documents`

The whole process takes about 2 to 3 minutes on my laptop.

## NOTE 1
Currently the figures for the main document do not get regenerated by running `compile-documents.R`.  This is because there are some non-portable elements (ps-fragging and ghostscript hacking).  There is a script (commented out of `compile-documents.R` that shows what one would do to get new/updated figures for the main documents.)

## NOTE 2
I have set this up, somewhat klugily and hastily, to allow typesetting in either a nice-looking two column format, much as the paper would be typeset at a journal, and also in a single column version suitable for submission to a journal.  To typeset the single column version the script creates a new file `./sib_assess_tex/main-body-text-one-col.tex` frmo `./sib_assess_tex/main-body-text.tex` by changing every occurrence of `sidewaysfigure*` to `sidewaysfigure`.  This is necessary since `endfloat` and the starred floats from `rotating` don't play nicely together. 

## Terms 

As a work partially of the United States Government, this package is in the
public domain within the United States. 

See TERMS.md for more information.



## Doing the Analyses Themselves
Many of the analyses were done over the course of several weeks to months of computation over multiple machines and spread over a number of months if not years, with a substantial amount of hand curation to re-do analyses that might have failed the first time due to any number of reasons (like power failures or disconnects, etc.  Given that, it is not, in Eric's opinion, reasonable to provide a single script that users can expect will flawlessly replicate all the analyses performed by all the different programs.  However, at the end of the process, we re-ran COLONY on a subset of the data sets using a few different options.  In the directory `analysis/colony` we provide scripts that should run reliably.  It should be clear from these scripts how one would replicate the COLONY analyses.  The following section documents this.  Below, in a following section, we also provide the scripts used to send jobs to the KINALYZER server.

### Running Colony on the Simulated data
Here is how to run colony on a handful of data sets (about 500 separate colony runs...)
```sh
# clone the repository:
git clone https://github.com/eriqande/sib-prog-assess.git

# change into the analysis/colony directory:
cd sib-prog-assess/analysis/colony/

# from that directory, launch the run-and-analyze-colony-subset.sh script:
./run-and-analyze-colony-subset.sh


```




