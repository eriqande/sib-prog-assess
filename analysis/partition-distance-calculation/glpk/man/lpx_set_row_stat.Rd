%% BEGIN doc for: lpx_set_row_stat
\name{lpx_set_row_stat}
\alias{lpx_set_row_stat}
\title{
    Low-level interface to the GLPK function
}
\description{
    This function is a low-level interface to the GNU Linear Programming
    Kit (GLPK) function \code{lpx_set_row_stat}.  The parameter
    names, associated types, and return values are identical to the
    GLPK function.  Please see the GLPK documentation for more info.
}
\usage{
    lpx_set_row_stat(lp, i, stat)
}
\arguments{

    \item{lp}{ see GLPK doc } 
    \item{i}{ see GLPK doc } 
    \item{stat}{ see GLPK doc }  

}   
\details{
    This function is the interface to the R-glpk C function 
    \code{R_lpx_set_row_stat} which converts R objects and 
    calls GLPK \code{lpx_set_row_stat}.
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
%% END doc for: lpx_set_row_stat
