%% BEGIN doc for: lpx_ipt_col_prim
\name{lpx_ipt_col_prim}
\alias{lpx_ipt_col_prim}
\title{
    Low-level interface to the GLPK function
}
\description{
    This function is a low-level interface to the GNU Linear Programming
    Kit (GLPK) function \code{lpx_ipt_col_prim}.  The parameter
    names, associated types, and return values are identical to the
    GLPK function.  Please see the GLPK documentation for more info.
}
\usage{
    lpx_ipt_col_prim(lp, j)
}
\arguments{

    \item{lp}{ see GLPK doc } 
    \item{j}{ see GLPK doc }  

}  
\value{
        Returns  a numeric value.
} 
\details{
    This function is the interface to the R-glpk C function 
    \code{R_lpx_ipt_col_prim} which converts R objects and 
    calls GLPK \code{lpx_ipt_col_prim}.
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
%% END doc for: lpx_ipt_col_prim
