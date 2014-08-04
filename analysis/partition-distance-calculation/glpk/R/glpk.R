
# Package initialization
.First.lib =
function(lib, pkg)
{
    library.dynam(.glpkPackageDLLName, pkg, lib)
    .Call("R_glpk_init", PACKAGE=.glpkPackageName)
}

# General methods

glpk_strerror = 
function(i) 
{
    ecodes = lpx_variables
    as.character(ecodes$string[which(ecodes$value == i)])
}

# Global variables

.glpkPackageName = "glpk"
.glpkPackageDLLName = paste(.glpkPackageName, .Platform$dynlib.ext, sep="")

LPX_LP = 100
LPX_MIP = 101
LPX_MIN = 120
LPX_MAX = 121
LPX_B_UNDEF = 130
LPX_B_VALID = 131
LPX_P_UNDEF = 132
LPX_P_FEAS = 133
LPX_P_INFEAS = 134
LPX_P_NOFEAS = 135
LPX_D_UNDEF = 136
LPX_D_FEAS = 137
LPX_D_INFEAS = 138
LPX_D_NOFEAS = 139
LPX_T_UNDEF = 150
LPX_T_OPT = 151
LPX_I_UNDEF = 170
LPX_I_OPT = 171
LPX_I_FEAS = 172
LPX_I_NOFEAS = 173
LPX_FR = 110
LPX_LO = 111
LPX_UP = 112
LPX_DB = 113
LPX_FX = 114
LPX_BS = 140
LPX_NL = 141
LPX_NU = 142
LPX_NF = 143
LPX_NS = 144
LPX_CV = 160
LPX_IV = 161
LPX_OPT = 180
LPX_FEAS = 181
LPX_INFEAS = 182
LPX_NOFEAS = 183
LPX_UNBND = 184
LPX_UNDEF = 185
LPX_E_OK = 200
LPX_E_EMPTY = 201
LPX_E_BADB = 202
LPX_E_INFEAS = 203
LPX_E_FAULT = 204
LPX_E_OBJLL = 205
LPX_E_OBJUL = 206
LPX_E_ITLIM = 207
LPX_E_TMLIM = 208
LPX_E_NOFEAS = 209
LPX_E_INSTAB = 210
LPX_E_SING = 211
LPX_E_NOCONV = 212
LPX_E_NOPFS = 213
LPX_E_NODFS = 214

"lpx_variables" <-
structure(list(symbol = structure(as.integer(c(63, 66, 65, 64, 
2, 3, 76, 73, 74, 75, 9, 6, 7, 8, 78, 77, 32, 31, 28, 30, 26, 
62, 81, 5, 27, 1, 68, 71, 67, 70, 4, 33, 72, 25, 29, 69, 79, 
80, 22, 11, 10, 13, 12, 20, 21, 15, 24, 18, 14, 23, 16, 19, 17
)), .Label = c("LPX_BS", "LPX_B_UNDEF", "LPX_B_VALID", "LPX_CV", 
"LPX_DB", "LPX_D_FEAS", "LPX_D_INFEAS", "LPX_D_NOFEAS", "LPX_D_UNDEF", 
"LPX_E_BADB", "LPX_E_EMPTY", "LPX_E_FAULT", "LPX_E_INFEAS", "LPX_E_INSTAB", 
"LPX_E_ITLIM", "LPX_E_NOCONV", "LPX_E_NODFS", "LPX_E_NOFEAS", 
"LPX_E_NOPFS", "LPX_E_OBJLL", "LPX_E_OBJUL", "LPX_E_OK", "LPX_E_SING", 
"LPX_E_TMLIM", "LPX_FEAS", "LPX_FR", "LPX_FX", "LPX_I_FEAS", 
"LPX_INFEAS", "LPX_I_NOFEAS", "LPX_I_OPT", "LPX_I_UNDEF", "LPX_IV", 
"LPX_K_BRANCH", "LPX_K_BTRACK", "LPX_K_DUAL", "LPX_K_ITCNT", 
"LPX_K_ITLIM", "LPX_K_LPTORIG", "LPX_K_MPSFREE", "LPX_K_MPSINFO", 
"LPX_K_MPSOBJ", "LPX_K_MPSORIG", "LPX_K_MPSSKIP", "LPX_K_MPSWIDE", 
"LPX_K_MSGLEV", "LPX_K_OBJLL", "LPX_K_OBJUL", "LPX_K_OUTDLY", 
"LPX_K_OUTFRQ", "LPX_K_PRESOL", "LPX_K_PRICE", "LPX_K_RELAX", 
"LPX_K_ROUND", "LPX_K_SCALE", "LPX_K_TMLIM", "LPX_K_TOLBND", 
"LPX_K_TOLDJ", "LPX_K_TOLINT", "LPX_K_TOLOBJ", "LPX_K_TOLPIV", 
"LPX_LO", "LPX_LP", "LPX_MAX", "LPX_MIN", "LPX_MIP", "LPX_NF", 
"LPX_NL", "LPX_NOFEAS", "LPX_NS", "LPX_NU", "LPX_OPT", "LPX_P_FEAS", 
"LPX_P_INFEAS", "LPX_P_NOFEAS", "LPX_P_UNDEF", "LPX_T_OPT", "LPX_T_UNDEF", 
"LPX_UNBND", "LPX_UNDEF", "LPX_UP"), class = "factor"), value = as.integer(c(100, 
101, 120, 121, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 
150, 151, 170, 171, 172, 173, 110, 111, 112, 113, 114, 140, 141, 
142, 143, 144, 160, 161, 180, 181, 182, 183, 184, 185, 200, 201, 
202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214
)), string = structure(as.integer(c(21, 52, 51, 50, 3, 4, 69, 
73, 74, 63, 6, 71, 72, 54, 18, 17, 15, 14, 13, 58, 10, 80, 81, 
5, 9, 1, 61, 62, 60, 59, 2, 16, 68, 8, 11, 56, 78, 79, 75, 7, 
19, 12, 77, 66, 67, 20, 76, 57, 65, 70, 53, 64, 55)), .Label = c("basic variable", 
"continuous variable", "current basis is undefined", "current basis is valid", 
"double-bounded variable", "dual solution is undefined", "empty problem", 
"feasible", "fixed variable", "free variable", "infeasible", 
"infeasible initial solution", "integer solution is feasible", 
"integer solution is optimal", "integer solution is undefined", 
"integer variable", "interior solution is optimal", "interior solution is undefined", 
"invalid initial basis", "iterations limit exhausted", "linear programming (LP)", 
"lp->branch", "lp->btrack", "lp->dual", "lp->it_cnt", "lp->it_lim", 
"lp->lpt_orig", "lp->mps_free", "lp->mps_info", "lp->mps_obj", 
"lp->mps_orig", "lp->mps_skip", "lp->mps_wide", "lp->msg_lev", 
"lp->obj_ll", "lp->obj_ul", "lp->out_dly", "lp->out_frq", "lp->presol", 
"lp->price", "lp->relax", "lp->round", "lp->scale", "lp->tm_lim", 
"lp->tol_bnd", "lp->tol_dj", "lp->tol_int", "lp->tol_obj", "lp->tol_piv", 
"maximization", "minimization", "mixed integer programming (MIP)", 
"no convergence (interior)", "no dual feasible solution exists", 
"no dual feas. sol. (LP presolver)", "no feasible", "no feasible solution", 
"no integer solution exists", "non-basic fixed variable", "non-basic free variable", 
"non-basic variable on lower bound", "non-basic variable on upper bound", 
"no primal feasible solution exists", "no primal feas. sol. (LP presolver)", 
"numerical instability", "objective lower limit reached", "objective upper limit reached", 
"optimal", "primal solution is undefined", "problems with basis matrix", 
"solution is dual feasible", "solution is dual infeasible", "solution is primal feasible", 
"solution is primal infeasible", "success", "time limit exhausted", 
"unable to start the search", "unbounded", "undefined", "variable with lower bound", 
"variable with upper bound"), class = "factor")), .Names = c("symbol", 
"value", "string"), row.names = c("1", "2", "3", "4", "5", "6", 
"7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", 
"18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", 
"29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", 
"40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", 
"51", "52", "53"), class = "data.frame")
