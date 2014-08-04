#include <Rinternals.h>
#include "glplib.h"
#include "R_glpk.h"

static int 
R_glpk_print(void *not_used, char *mesg)
{
    Rprintf("%s\n", mesg);
    return 1; /* Tell GLPK not to print */
}

static int
R_glpk_fault(void *not_used, char *mesg)
{
    Rprintf("%s\n", mesg);
    longjmp(R_glpk_env, 1); 
}

SEXP R_glpk_init(void)
{
    SEXP ret = R_NilValue;

    R_lpx_init();

    lib_set_print_hook(NULL, R_glpk_print);

    lib_set_fault_hook(NULL, R_glpk_fault);

    return ret;
}

