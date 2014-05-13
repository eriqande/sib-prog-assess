# sib-prog-assess

This is LaTeX code to typeset a paper for Molecular Ecology Resources
that evaluates a variety of sibship reconstruction software 
programs using simulated microsatellite data

In order to typeset it, `cd` into the `sib_assess_tex` directory and issue these
commands (note that you have to have a TeX system installed on your
system):
```
pdflatex sib_prog_eval_two_columns.tex
bibtex sib_prog_eval_two_columns
pdflatex sib_prog_eval_two_columns.tex
pdflatex sib_prog_eval_two_columns.tex
```
The resulting PDF file, `sib_prog_eval_two_columns/pdf` should then be complete.

## NOTE
I have set this up, somewhat klugily and hastily, to allow typesetting in either
a nice-looking two column format, much as the paper would be typeset at a 
journal, and also in a single column version suitable for submission to a 
journal.  However, it is not all seamless.  If you want to typeset the 
*single column version* then you have to modify the file `./sib_assess_tex/main-body-text.tex`
by changing every occurrence of `sidewaysfigure*` to `sidewaysfigure`.  This is 
necessary since `endfloat` and the starred floats from `rotating` don't play 
nicely together.  After doing that you can do:
```
pdflatex sib_prog_eval.tex
bibtex sib_prog_eval
pdflatex sib_prog_eval.tex
pdflatex sib_prog_eval.tex
```
to get a submission-ready version, `sib_prog_eval.tex`.

Of course, if you want to typeset the two-column version you have to put the 
asterisks back in there.

## To-Dos.  
I still need to add the supplements in here and incorporate
all of Tony's recent edits.


## Terms 

As a work partially of the United States Government, this package is in the
public domain within the United States. 

See TERMS.md for more information.

