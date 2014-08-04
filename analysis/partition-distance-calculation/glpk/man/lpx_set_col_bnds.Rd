%% BEGIN doc for: lpx_set_col_bnds
\name{lpx_set_col_bnds}
\alias{lpx_set_col_bnds}
\title{
    Low-level interface to the GLPK function
}
\description{
    This function is a low-level interface to the GNU Linear Programming
    Kit (GLPK) function \code{lpx_set_col_bnds}.  The parameter
    names, associated types, and return values are identical to the
    GLPK function.  Please see the GLPK documentation for more info.
}
\usage{
    lpx_set_col_bnds(lp, j, type, lb, ub)
}
\arguments{

    \item{lp}{ see GLPK doc } 
    \item{j}{ see GLPK doc } 
    \item{type}{ see GLPK doc } 
    \item{lb}{ see GLPK doc } 
    \item{ub}{ see GLPK doc }  

}   
\details{
    This function is the interface to the R-glpk C function 
    \code{R_lpx_set_col_bnds} which converts R objects and 
    calls GLPK \code{lpx_set_col_bnds}.
}
\references{
    The GNU GLPK home page at http://www.gnu.org/software/glpk/glpk.html
}
\author{
    Lopaka Lee      <rlee@fpcc.net> (R-GLPK)

    Andrew Makhorin <mao@gnu.org>   (GLPK)
} 
\note{
    This function, documentation, and associated R-API code has been
    automatically generated using translation utilities developed for this
    package (distributed with the R-glpk source).  Caveat Emptor. 

    The full documentation for GLPK has not been converted to Rd format --
    it is available in the GLPK source distribution. 

    Inquiries regarding this interface (R-GLPK) should not be sent to
    GNU GLPK mailing lists.
}
%\seealso{
%}
%\examples{
%}
\keyword{optimize}
%% END doc for: lpx_set_col_bnds
