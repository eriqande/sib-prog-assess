\name{lpx_variables}
\alias{lpx_variables}
\alias{LPX_LP}
\alias{LPX_MIP}
\alias{LPX_MIN}
\alias{LPX_MAX}
\alias{LPX_B_UNDEF}
\alias{LPX_B_VALID}
\alias{LPX_P_UNDEF}
\alias{LPX_P_FEAS}
\alias{LPX_P_INFEAS}
\alias{LPX_P_NOFEAS}
\alias{LPX_D_UNDEF}
\alias{LPX_D_FEAS}
\alias{LPX_D_INFEAS}
\alias{LPX_D_NOFEAS}
\alias{LPX_T_UNDEF}
\alias{LPX_T_OPT}
\alias{LPX_I_UNDEF}
\alias{LPX_I_OPT}
\alias{LPX_I_FEAS}
\alias{LPX_I_NOFEAS}
\alias{LPX_FR}
\alias{LPX_LO}
\alias{LPX_UP}
\alias{LPX_DB}
\alias{LPX_FX}
\alias{LPX_BS}
\alias{LPX_NL}
\alias{LPX_NU}
\alias{LPX_NF}
\alias{LPX_NS}
\alias{LPX_CV}
\alias{LPX_IV}
\alias{LPX_FR}
\alias{LPX_LO}
\alias{LPX_UP}
\alias{LPX_DB}
\alias{LPX_FX}
\alias{LPX_BS}
\alias{LPX_NL}
\alias{LPX_NU}
\alias{LPX_NF}
\alias{LPX_NS}
\alias{LPX_OPT}
\alias{LPX_FEAS}
\alias{LPX_INFEAS}
\alias{LPX_NOFEAS}
\alias{LPX_UNBND}
\alias{LPX_UNDEF}
\alias{LPX_E_OK}
\alias{LPX_E_EMPTY}
\alias{LPX_E_BADB}
\alias{LPX_E_INFEAS}
\alias{LPX_E_FAULT}
\alias{LPX_E_OBJLL}
\alias{LPX_E_OBJUL}
\alias{LPX_E_ITLIM}
\alias{LPX_E_TMLIM}
\alias{LPX_E_NOFEAS}
\alias{LPX_E_INSTAB}
\alias{LPX_E_SING}
\alias{LPX_E_NOCONV}
\alias{LPX_E_NOPFS}
\alias{LPX_E_NODFS}
\alias{LPX_K_MSGLEV}
\alias{LPX_K_SCALE}
\alias{LPX_K_DUAL}
\alias{LPX_K_PRICE}
\alias{LPX_K_RELAX}
\alias{LPX_K_TOLBND}
\alias{LPX_K_TOLDJ}
\alias{LPX_K_TOLPIV}
\alias{LPX_K_ROUND}
\alias{LPX_K_OBJLL}
\alias{LPX_K_OBJUL}
\alias{LPX_K_ITLIM}
\alias{LPX_K_ITCNT}
\alias{LPX_K_TMLIM}
\alias{LPX_K_OUTFRQ}
\alias{LPX_K_OUTDLY}
\alias{LPX_K_BRANCH}
\alias{LPX_K_BTRACK}
\alias{LPX_K_TOLINT}
\alias{LPX_K_TOLOBJ}
\alias{LPX_K_MPSINFO}
\alias{LPX_K_MPSOBJ}
\alias{LPX_K_MPSORIG}
\alias{LPX_K_MPSWIDE}
\alias{LPX_K_MPSFREE}
\alias{LPX_K_MPSSKIP}
\alias{LPX_K_LPTORIG}
\alias{LPX_K_PRESOL}
\title{
    Constant or return codes for the GLPK lpx class.
}
\description{
    This is a constant or return code used in the GLPK API.

    The function \code{glpk_strerror} may be used to convert this value
    into a string.

    The global data frame \code{lpx_variables} contains symbolic, string,
    and numeric values associated with these variables.

    Please see the GLPK documentation for more info.
}
\details{

    \code{LPX_LP} =  linear programming (LP)  = 100


    \code{LPX_MIP} =  mixed integer programming (MIP)  = 101


    \code{LPX_MIN} =  minimization  = 120


    \code{LPX_MAX} =  maximization  = 121


    \code{LPX_B_UNDEF} =  current basis is undefined  = 130


    \code{LPX_B_VALID} =  current basis is valid  = 131


    \code{LPX_P_UNDEF} =  primal solution is undefined  = 132


    \code{LPX_P_FEAS} =  solution is primal feasible  = 133


    \code{LPX_P_INFEAS} =  solution is primal infeasible  = 134


    \code{LPX_P_NOFEAS} =  no primal feasible solution exists  = 135


    \code{LPX_D_UNDEF} =  dual solution is undefined  = 136


    \code{LPX_D_FEAS} =  solution is dual feasible  = 137


    \code{LPX_D_INFEAS} =  solution is dual infeasible  = 138


    \code{LPX_D_NOFEAS} =  no dual feasible solution exists  = 139


    \code{LPX_T_UNDEF} =  interior solution is undefined  = 150


    \code{LPX_T_OPT} =  interior solution is optimal  = 151


    \code{LPX_I_UNDEF} =  integer solution is undefined  = 170


    \code{LPX_I_OPT} =  integer solution is optimal  = 171


    \code{LPX_I_FEAS} =  integer solution is feasible  = 172


    \code{LPX_I_NOFEAS} =  no integer solution exists  = 173


    \code{LPX_FR} =  free variable  = 110


    \code{LPX_LO} =  variable with lower bound  = 111


    \code{LPX_UP} =  variable with upper bound  = 112


    \code{LPX_DB} =  double-bounded variable  = 113


    \code{LPX_FX} =  fixed variable  = 114


    \code{LPX_BS} =  basic variable  = 140


    \code{LPX_NL} =  non-basic variable on lower bound  = 141


    \code{LPX_NU} =  non-basic variable on upper bound  = 142


    \code{LPX_NF} =  non-basic free variable  = 143


    \code{LPX_NS} =  non-basic fixed variable  = 144


    \code{LPX_CV} =  continuous variable  = 160


    \code{LPX_IV} =  integer variable  = 161


    \code{LPX_FR} =  free variable  = 110


    \code{LPX_LO} =  variable with lower bound  = 111


    \code{LPX_UP} =  variable with upper bound  = 112


    \code{LPX_DB} =  double-bounded variable  = 113


    \code{LPX_FX} =  fixed variable  = 114


    \code{LPX_BS} =  basic variable  = 140


    \code{LPX_NL} =  non-basic variable on lower bound  = 141


    \code{LPX_NU} =  non-basic variable on upper bound  = 142


    \code{LPX_NF} =  non-basic free variable  = 143


    \code{LPX_NS} =  non-basic fixed variable  = 144


    \code{LPX_OPT} =  optimal  = 180


    \code{LPX_FEAS} =  feasible  = 181


    \code{LPX_INFEAS} =  infeasible  = 182


    \code{LPX_NOFEAS} =  no feasible  = 183


    \code{LPX_UNBND} =  unbounded  = 184


    \code{LPX_UNDEF} =  undefined  = 185


    \code{LPX_E_OK} =  success  = 200


    \code{LPX_E_EMPTY} =  empty problem  = 201


    \code{LPX_E_BADB} =  invalid initial basis  = 202


    \code{LPX_E_INFEAS} =  infeasible initial solution  = 203


    \code{LPX_E_FAULT} =  unable to start the search  = 204


    \code{LPX_E_OBJLL} =  objective lower limit reached  = 205


    \code{LPX_E_OBJUL} =  objective upper limit reached  = 206


    \code{LPX_E_ITLIM} =  iterations limit exhausted  = 207


    \code{LPX_E_TMLIM} =  time limit exhausted  = 208


    \code{LPX_E_NOFEAS} =  no feasible solution  = 209


    \code{LPX_E_INSTAB} =  numerical instability  = 210


    \code{LPX_E_SING} =  problems with basis matrix  = 211


    \code{LPX_E_NOCONV} =  no convergence (interior)  = 212


    \code{LPX_E_NOPFS} =  no primal feas. sol. (LP presolver)  = 213


    \code{LPX_E_NODFS} =  no dual feas. sol. (LP presolver)  = 214


    \code{LPX_K_MSGLEV} =  lp->msg\_lev  = 300


    \code{LPX_K_SCALE} =  lp->scale  = 301


    \code{LPX_K_DUAL} =  lp->dual  = 302


    \code{LPX_K_PRICE} =  lp->price  = 303


    \code{LPX_K_RELAX} =  lp->relax  = 304


    \code{LPX_K_TOLBND} =  lp->tol\_bnd  = 305


    \code{LPX_K_TOLDJ} =  lp->tol\_dj  = 306


    \code{LPX_K_TOLPIV} =  lp->tol\_piv  = 307


    \code{LPX_K_ROUND} =  lp->round  = 308


    \code{LPX_K_OBJLL} =  lp->obj\_ll  = 309


    \code{LPX_K_OBJUL} =  lp->obj\_ul  = 310


    \code{LPX_K_ITLIM} =  lp->it\_lim  = 311


    \code{LPX_K_ITCNT} =  lp->it\_cnt  = 312


    \code{LPX_K_TMLIM} =  lp->tm\_lim  = 313


    \code{LPX_K_OUTFRQ} =  lp->out\_frq  = 314


    \code{LPX_K_OUTDLY} =  lp->out\_dly  = 315


    \code{LPX_K_BRANCH} =  lp->branch  = 316


    \code{LPX_K_BTRACK} =  lp->btrack  = 317


    \code{LPX_K_TOLINT} =  lp->tol\_int  = 318


    \code{LPX_K_TOLOBJ} =  lp->tol\_obj  = 319


    \code{LPX_K_MPSINFO} =  lp->mps\_info  = 320


    \code{LPX_K_MPSOBJ} =  lp->mps\_obj  = 321


    \code{LPX_K_MPSORIG} =  lp->mps\_orig  = 322


    \code{LPX_K_MPSWIDE} =  lp->mps\_wide  = 323


    \code{LPX_K_MPSFREE} =  lp->mps\_free  = 324


    \code{LPX_K_MPSSKIP} =  lp->mps\_skip  = 325


    \code{LPX_K_LPTORIG} =  lp->lpt\_orig  = 326


    \code{LPX_K_PRESOL} =  lp->presol  = 327

}
\note{
    Code should not rely on the numeric values.

    Inquiries regarding this interface (R-GLPK) should NOT be sent to
    GNU GLPK mailing lists.
}
\seealso{
    \code{\link{glpk_strerror}}
}
\references{
    The GNU GLPK home page at http://www.gnu.org/software/glpk/glpk.html
}
\author{
    Lopaka Lee      <rlee@fpcc.net> (R-GLPK)

    Andrew Makhorin <mao@gnu.org>   (GLPK)
} 
%\examples{
%}
\keyword{optimize}
