# sib-prog-assess

This is LaTeX code to typeset a paper I wrote with Anthony Almudevar for Molecular Ecology Resources that evaluates a variety of sibship reconstruction software programs using simulated microsatellite data.  We are planning to submit it in late May or early June 2014.

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

## NOTE 1
Currently the figures for the main document do not get regenerated by running `compile-documents.R`.  This is because there are some non-portable elements (ps-fragging and ghostscript hacking).  There is a script (commented out of `compile-documents.R` that shows what one would do to get new/updated figures for the main documents.)

## NOTE 2
I have set this up, somewhat klugily and hastily, to allow typesetting in either a nice-looking two column format, much as the paper would be typeset at a journal, and also in a single column version suitable for submission to a journal.  To typeset the single column version the script creates a new file `./sib_assess_tex/main-body-text-one-col.tex` frmo `./sib_assess_tex/main-body-text.tex` by changing every occurrence of `sidewaysfigure*` to `sidewaysfigure`.  This is necessary since `endfloat` and the starred floats from `rotating` don't play nicely together. 

## Terms 

As a work partially of the United States Government, this package is in the
public domain within the United States. 

See TERMS.md for more information.

