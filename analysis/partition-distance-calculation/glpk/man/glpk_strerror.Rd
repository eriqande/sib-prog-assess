\name{glpk_strerror}
\alias{glpk_strerror}
\title{
    Return a string describing a GLPK constant, return value, or error code.
}
\description{
    Translates a GLPK constant, return value, or error code into its
    string representation or description.
}
\usage{
    glpk_strerror(i)
} 
\arguments{
    \item{i}{Integer value.  A GLPK constant, return value, or error code.}
}
\value{
        Returns the string associated with the integer.
} 
\references{
    The GNU GLPK home page at http://www.gnu.org/software/glpk/glpk.html
}
\author{
    Lopaka Lee      <rlee@fpcc.net> (R-GLPK)

    Andrew Makhorin <mao@gnu.org>   (GLPK)
} 
\note{
    The global data frame \code{lpx_variables} contains symbolic, string,
    and numeric values associated with these variables.

    Inquiries regarding this interface (R-GLPK) should NOT be sent to
    GNU GLPK mailing lists.
}
\seealso{
    \code{\link{lpx_variables}}
}
%\examples{
%}
\keyword{optimize}
