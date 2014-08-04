
Porting of GLPK routines to R is accomplished using Perl-based parser and
translation routines.  These routines parse header files and translate
symbols to R functions, C routines for the R API, and R documentation.
The translation routines are not always correct -- hand coding of certain
outputs is always required.  Regardless, this approach saves considerable
development time and allows files to be quickly regenerated when GLPK
sources are updated.  Use and development of these translation routines
requires the Perl Template Toolkit <http://www.template-toolkit.org/>.

-Lopaka Lee <rlee@fpcc.net>

