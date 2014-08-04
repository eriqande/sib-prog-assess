#ifndef R_GLPK_H
#define R_GLPK_H
#include <setjmp.h>

#define R_glpk_setjmp() setjmp(R_glpk_env)

#define R_GLPK_CHARACTER_VALUE(a) \
  (a == R_NilValue ? NULL : CHARACTER_VALUE(a))

jmp_buf R_glpk_env;

SEXP R_lpx_init(void);

#endif /* R_GLPK_H */
