/**
 * Auto generated using GLPKTranslate framework. 
 * Please inspect and fix translation errors.
 **/
#include <Rdefines.h>
#include "glplpx.h"
#include "R_glpk.h"

#define R_LPX_NIL_CHECK(s) do {\
    if (R_ExternalPtrAddr(s) == NULL) \
        error("nil value passed"); \
} while (0)

#define R_LPX_TYPE_CHECK(s) do { \
    if (TYPEOF(s) != EXTPTRSXP || \
        R_ExternalPtrTag(s) != LPX_type_tag) \
        error("bad type passed"); \
} while (0)

#define R_LPX_CHECK(s) do { \
    R_LPX_NIL_CHECK(s); \
    R_LPX_TYPE_CHECK(s); \
} while (0)

static SEXP LPX_type_tag;

/** Initialization for this class -- for .First.lib or equivalent **/
SEXP R_lpx_init(void)
{
    LPX_type_tag = install("LPX_TYPE_TAG");
    return R_NilValue;
} 
/*** void lpx_delete_prob(LPX *lp); ***/
SEXP R_lpx_delete_prob(SEXP lp)
{
    SEXP ret = R_NilValue;
    LPX *lpx = NULL;

    R_LPX_TYPE_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    lpx = R_ExternalPtrAddr(lp);
    if (lpx)
      {
        lpx_delete_prob(lpx);
        R_ClearExternalPtr(lp);
      }
end:
    return ret;
}
/** glpk api: LPX *lpx_create_prob(void); **/
SEXP R_lpx_create_prob()
{
    SEXP ret = R_NilValue;
    LPX * xret = 0;


    if (R_glpk_setjmp()) goto end;

    xret = lpx_create_prob();
    if (xret)
      {
        ret = R_MakeExternalPtr(xret, LPX_type_tag, R_NilValue);
        R_RegisterCFinalizer(ret, (R_CFinalizer_t) R_lpx_delete_prob);
      } 
end:
    return ret;
} 
/** glpk api: void lpx_set_prob_name(LPX *lp, char *name); **/
SEXP R_lpx_set_prob_name(SEXP lp, SEXP name)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_prob_name(R_ExternalPtrAddr(lp), CHARACTER_VALUE(name)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_class(LPX *lp, int klass); **/
SEXP R_lpx_set_class(SEXP lp, SEXP klass)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_class(R_ExternalPtrAddr(lp), INTEGER_VALUE(klass)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_obj_name(LPX *lp, char *name); **/
SEXP R_lpx_set_obj_name(SEXP lp, SEXP name)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_obj_name(R_ExternalPtrAddr(lp), CHARACTER_VALUE(name)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_obj_dir(LPX *lp, int dir); **/
SEXP R_lpx_set_obj_dir(SEXP lp, SEXP dir)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_obj_dir(R_ExternalPtrAddr(lp), INTEGER_VALUE(dir)); 
end:
    return ret;
} 
/** glpk api: int lpx_add_rows(LPX *lp, int nrs); **/
SEXP R_lpx_add_rows(SEXP lp, SEXP nrs)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_add_rows(R_ExternalPtrAddr(lp), INTEGER_VALUE(nrs));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_add_cols(LPX *lp, int ncs); **/
SEXP R_lpx_add_cols(SEXP lp, SEXP ncs)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_add_cols(R_ExternalPtrAddr(lp), INTEGER_VALUE(ncs));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: void lpx_set_row_name(LPX *lp, int i, char *name); **/
SEXP R_lpx_set_row_name(SEXP lp, SEXP i, SEXP name)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_row_name(R_ExternalPtrAddr(lp), INTEGER_VALUE(i), CHARACTER_VALUE(name)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_col_name(LPX *lp, int j, char *name); **/
SEXP R_lpx_set_col_name(SEXP lp, SEXP j, SEXP name)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_col_name(R_ExternalPtrAddr(lp), INTEGER_VALUE(j), CHARACTER_VALUE(name)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_col_kind(LPX *lp, int j, int kind); **/
SEXP R_lpx_set_col_kind(SEXP lp, SEXP j, SEXP kind)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_col_kind(R_ExternalPtrAddr(lp), INTEGER_VALUE(j), INTEGER_VALUE(kind)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_row_bnds(LPX *lp, int i, int type, double lb, double ub); **/
SEXP R_lpx_set_row_bnds(SEXP lp, SEXP i, SEXP type, SEXP lb, SEXP ub)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_row_bnds(R_ExternalPtrAddr(lp), INTEGER_VALUE(i), INTEGER_VALUE(type), NUMERIC_VALUE(lb), NUMERIC_VALUE(ub)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_col_bnds(LPX *lp, int j, int type, double lb, double ub); **/
SEXP R_lpx_set_col_bnds(SEXP lp, SEXP j, SEXP type, SEXP lb, SEXP ub)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_col_bnds(R_ExternalPtrAddr(lp), INTEGER_VALUE(j), INTEGER_VALUE(type), NUMERIC_VALUE(lb), NUMERIC_VALUE(ub)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_obj_coef(LPX *lp, int j, double coef); **/
SEXP R_lpx_set_obj_coef(SEXP lp, SEXP j, SEXP coef)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_obj_coef(R_ExternalPtrAddr(lp), INTEGER_VALUE(j), NUMERIC_VALUE(coef)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_mat_row(LPX *lp, int i, int len, int ind[], double val[]); **/
SEXP R_lpx_set_mat_row(SEXP lp, SEXP i, SEXP len, SEXP ind, SEXP val)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_mat_row(R_ExternalPtrAddr(lp), INTEGER_VALUE(i), INTEGER_VALUE(len), INTEGER_POINTER(ind), NUMERIC_POINTER(val)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_mat_col(LPX *lp, int j, int len, int ind[], double val[]); **/
SEXP R_lpx_set_mat_col(SEXP lp, SEXP j, SEXP len, SEXP ind, SEXP val)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_mat_col(R_ExternalPtrAddr(lp), INTEGER_VALUE(j), INTEGER_VALUE(len), INTEGER_POINTER(ind), NUMERIC_POINTER(val)); 
end:
    return ret;
} 
/** glpk api: void lpx_load_matrix(LPX *lp, int ne, int ia[], int ja[], double ar[]); **/
SEXP R_lpx_load_matrix(SEXP lp, SEXP ne, SEXP ia, SEXP ja, SEXP ar)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_load_matrix(R_ExternalPtrAddr(lp), INTEGER_VALUE(ne), INTEGER_POINTER(ia), INTEGER_POINTER(ja), NUMERIC_POINTER(ar)); 
end:
    return ret;
} 
/** glpk api: void lpx_order_matrix(LPX *lp); **/
SEXP R_lpx_order_matrix(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_order_matrix(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_rii(LPX *lp, int i, double rii); **/
SEXP R_lpx_set_rii(SEXP lp, SEXP i, SEXP rii)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_rii(R_ExternalPtrAddr(lp), INTEGER_VALUE(i), NUMERIC_VALUE(rii)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_sjj(LPX *lp, int j, double sjj); **/
SEXP R_lpx_set_sjj(SEXP lp, SEXP j, SEXP sjj)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_sjj(R_ExternalPtrAddr(lp), INTEGER_VALUE(j), NUMERIC_VALUE(sjj)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_row_stat(LPX *lp, int i, int stat); **/
SEXP R_lpx_set_row_stat(SEXP lp, SEXP i, SEXP stat)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_row_stat(R_ExternalPtrAddr(lp), INTEGER_VALUE(i), INTEGER_VALUE(stat)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_col_stat(LPX *lp, int j, int stat); **/
SEXP R_lpx_set_col_stat(SEXP lp, SEXP j, SEXP stat)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_col_stat(R_ExternalPtrAddr(lp), INTEGER_VALUE(j), INTEGER_VALUE(stat)); 
end:
    return ret;
} 
/** glpk api: void lpx_del_rows(LPX *lp, int nrs, int num[]); **/
SEXP R_lpx_del_rows(SEXP lp, SEXP nrs, SEXP num)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_del_rows(R_ExternalPtrAddr(lp), INTEGER_VALUE(nrs), INTEGER_POINTER(num)); 
end:
    return ret;
} 
/** glpk api: void lpx_del_cols(LPX *lp, int ncs, int num[]); **/
SEXP R_lpx_del_cols(SEXP lp, SEXP ncs, SEXP num)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_del_cols(R_ExternalPtrAddr(lp), INTEGER_VALUE(ncs), INTEGER_POINTER(num)); 
end:
    return ret;
} 
/** glpk api: void lpx_create_index(LPX *lp); **/
SEXP R_lpx_create_index(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_create_index(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: int lpx_find_row(LPX *lp, char *name); **/
SEXP R_lpx_find_row(SEXP lp, SEXP name)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_find_row(R_ExternalPtrAddr(lp), CHARACTER_VALUE(name));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_find_col(LPX *lp, char *name); **/
SEXP R_lpx_find_col(SEXP lp, SEXP name)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_find_col(R_ExternalPtrAddr(lp), CHARACTER_VALUE(name));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: void lpx_delete_index(LPX *lp); **/
SEXP R_lpx_delete_index(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_delete_index(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: void lpx_put_ray_info(LPX *lp, int k); **/
SEXP R_lpx_put_ray_info(SEXP lp, SEXP k)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_put_ray_info(R_ExternalPtrAddr(lp), INTEGER_VALUE(k)); 
end:
    return ret;
} 
/** glpk api: char *lpx_get_prob_name(LPX *lp); **/
SEXP R_lpx_get_prob_name(SEXP lp)
{
    SEXP ret = R_NilValue;
    char * xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_prob_name(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_CHARACTER(1));
        SET_STRING_ELT(ret, 0, mkChar(xret));
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_class(LPX *lp); **/
SEXP R_lpx_get_class(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_class(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: char *lpx_get_obj_name(LPX *lp); **/
SEXP R_lpx_get_obj_name(SEXP lp)
{
    SEXP ret = R_NilValue;
    char * xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_obj_name(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_CHARACTER(1));
        SET_STRING_ELT(ret, 0, mkChar(xret));
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_obj_dir(LPX *lp); **/
SEXP R_lpx_get_obj_dir(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_obj_dir(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_num_rows(LPX *lp); **/
SEXP R_lpx_get_num_rows(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_num_rows(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_num_cols(LPX *lp); **/
SEXP R_lpx_get_num_cols(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_num_cols(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_num_int(LPX *lp); **/
SEXP R_lpx_get_num_int(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_num_int(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_num_bin(LPX *lp); **/
SEXP R_lpx_get_num_bin(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_num_bin(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: char *lpx_get_row_name(LPX *lp, int i); **/
SEXP R_lpx_get_row_name(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    char * xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_name(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_CHARACTER(1));
        SET_STRING_ELT(ret, 0, mkChar(xret));
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: char *lpx_get_col_name(LPX *lp, int j); **/
SEXP R_lpx_get_col_name(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    char * xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_name(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_CHARACTER(1));
        SET_STRING_ELT(ret, 0, mkChar(xret));
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_col_kind(LPX *lp, int j); **/
SEXP R_lpx_get_col_kind(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_kind(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_row_type(LPX *lp, int i); **/
SEXP R_lpx_get_row_type(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_type(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_row_lb(LPX *lp, int i); **/
SEXP R_lpx_get_row_lb(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_lb(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_row_ub(LPX *lp, int i); **/
SEXP R_lpx_get_row_ub(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_ub(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_col_type(LPX *lp, int j); **/
SEXP R_lpx_get_col_type(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_type(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_col_lb(LPX *lp, int j); **/
SEXP R_lpx_get_col_lb(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_lb(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_col_ub(LPX *lp, int j); **/
SEXP R_lpx_get_col_ub(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_ub(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_obj_coef(LPX *lp, int j); **/
SEXP R_lpx_get_obj_coef(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_obj_coef(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_num_nz(LPX *lp); **/
SEXP R_lpx_get_num_nz(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_num_nz(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** R-specifc routine for in-out parameters **/
/** glpk api: int lpx_get_mat_row(LPX *lp, int i, int ind[], double val[]); **/
SEXP R_lpx_get_mat_row(SEXP lp, SEXP i)
{
    int len, xret = 0;
    SEXP ret, ind, val, listret = R_NilValue;

    R_LPX_CHECK(lp);

    len = lpx_get_num_rows(R_ExternalPtrAddr(lp));

    PROTECT(ind = NEW_INTEGER(len+1));
    PROTECT(val = NEW_NUMERIC(len+1));

    if (!R_glpk_setjmp())
      {
        xret = lpx_get_mat_row(R_ExternalPtrAddr(lp), 
                               INTEGER_VALUE(i), 
                               INTEGER_POINTER(ind), 
                               NUMERIC_POINTER(val));
        if (xret)
          {
            PROTECT(ret = NEW_INTEGER(1));
            INTEGER_POINTER(ret)[0] = xret;
            PROTECT(listret = NEW_LIST(3));
            SET_ELEMENT(listret, 0, ret);
            SET_ELEMENT(listret, 1, ind);
            SET_ELEMENT(listret, 2, val);
            UNPROTECT(2);
          }
      }
    UNPROTECT(2);
    return listret;

} 
/** R-specifc routine for in-out parameters **/
/** glpk api: int lpx_get_mat_col(LPX *lp, int j, int ind[], double val[]); **/
SEXP R_lpx_get_mat_col(SEXP lp, SEXP j)
{
    int len, xret = 0;
    SEXP ret, ind, val, listret = R_NilValue;

    R_LPX_CHECK(lp);

    len = lpx_get_num_rows(R_ExternalPtrAddr(lp));

    PROTECT(ind = NEW_INTEGER(len+1));
    PROTECT(val = NEW_NUMERIC(len+1));

    if (!R_glpk_setjmp())
      {
        xret = lpx_get_mat_col(R_ExternalPtrAddr(lp), 
                               INTEGER_VALUE(j), 
                               INTEGER_POINTER(ind), 
                               NUMERIC_POINTER(val));
        if (xret)
          {
            PROTECT(ret = NEW_INTEGER(1));
            INTEGER_POINTER(ret)[0] = xret;
            PROTECT(listret = NEW_LIST(3));
            SET_ELEMENT(listret, 0, ret);
            SET_ELEMENT(listret, 1, ind);
            SET_ELEMENT(listret, 2, val);
            UNPROTECT(2);
          }
      }
    UNPROTECT(2);
    return listret;
} 
/** glpk api: double lpx_get_rii(LPX *lp, int i); **/
SEXP R_lpx_get_rii(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_rii(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_sjj(LPX *lp, int j); **/
SEXP R_lpx_get_sjj(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_sjj(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_is_b_avail(LPX *lp); **/
SEXP R_lpx_is_b_avail(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_is_b_avail(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_b_info(LPX *lp, int i); **/
SEXP R_lpx_get_b_info(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_b_info(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_row_b_ind(LPX *lp, int i); **/
SEXP R_lpx_get_row_b_ind(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_b_ind(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_col_b_ind(LPX *lp, int j); **/
SEXP R_lpx_get_col_b_ind(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_b_ind(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_status(LPX *lp); **/
SEXP R_lpx_get_status(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_status(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_prim_stat(LPX *lp); **/
SEXP R_lpx_get_prim_stat(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_prim_stat(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_dual_stat(LPX *lp); **/
SEXP R_lpx_get_dual_stat(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_dual_stat(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_obj_val(LPX *lp); **/
SEXP R_lpx_get_obj_val(SEXP lp)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_obj_val(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_row_stat(LPX *lp, int i); **/
SEXP R_lpx_get_row_stat(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_stat(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_row_prim(LPX *lp, int i); **/
SEXP R_lpx_get_row_prim(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_prim(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_row_dual(LPX *lp, int i); **/
SEXP R_lpx_get_row_dual(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_row_dual(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_col_stat(LPX *lp, int j); **/
SEXP R_lpx_get_col_stat(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_stat(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_col_prim(LPX *lp, int j); **/
SEXP R_lpx_get_col_prim(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_prim(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_get_col_dual(LPX *lp, int j); **/
SEXP R_lpx_get_col_dual(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_col_dual(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_get_ray_info(LPX *lp); **/
SEXP R_lpx_get_ray_info(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_ray_info(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_ipt_status(LPX *lp); **/
SEXP R_lpx_ipt_status(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_ipt_status(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_ipt_obj_val(LPX *lp); **/
SEXP R_lpx_ipt_obj_val(SEXP lp)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_ipt_obj_val(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_ipt_row_prim(LPX *lp, int i); **/
SEXP R_lpx_ipt_row_prim(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_ipt_row_prim(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_ipt_row_dual(LPX *lp, int i); **/
SEXP R_lpx_ipt_row_dual(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_ipt_row_dual(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_ipt_col_prim(LPX *lp, int j); **/
SEXP R_lpx_ipt_col_prim(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_ipt_col_prim(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_ipt_col_dual(LPX *lp, int j); **/
SEXP R_lpx_ipt_col_dual(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_ipt_col_dual(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_mip_status(LPX *lp); **/
SEXP R_lpx_mip_status(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_mip_status(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_mip_obj_val(LPX *lp); **/
SEXP R_lpx_mip_obj_val(SEXP lp)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_mip_obj_val(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_mip_row_val(LPX *lp, int i); **/
SEXP R_lpx_mip_row_val(SEXP lp, SEXP i)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_mip_row_val(R_ExternalPtrAddr(lp), INTEGER_VALUE(i));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: double lpx_mip_col_val(LPX *lp, int j); **/
SEXP R_lpx_mip_col_val(SEXP lp, SEXP j)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_mip_col_val(R_ExternalPtrAddr(lp), INTEGER_VALUE(j));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: void lpx_reset_parms(LPX *lp); **/
SEXP R_lpx_reset_parms(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_reset_parms(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: void lpx_set_int_parm(LPX *lp, int parm, int val); **/
SEXP R_lpx_set_int_parm(SEXP lp, SEXP parm, SEXP val)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_int_parm(R_ExternalPtrAddr(lp), INTEGER_VALUE(parm), INTEGER_VALUE(val)); 
end:
    return ret;
} 
/** glpk api: int lpx_get_int_parm(LPX *lp, int parm); **/
SEXP R_lpx_get_int_parm(SEXP lp, SEXP parm)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_int_parm(R_ExternalPtrAddr(lp), INTEGER_VALUE(parm));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: void lpx_set_real_parm(LPX *lp, int parm, double val); **/
SEXP R_lpx_set_real_parm(SEXP lp, SEXP parm, SEXP val)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_set_real_parm(R_ExternalPtrAddr(lp), INTEGER_VALUE(parm), NUMERIC_VALUE(val)); 
end:
    return ret;
} 
/** glpk api: double lpx_get_real_parm(LPX *lp, int parm); **/
SEXP R_lpx_get_real_parm(SEXP lp, SEXP parm)
{
    SEXP ret = R_NilValue;
    double xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_get_real_parm(R_ExternalPtrAddr(lp), INTEGER_VALUE(parm));
    if (xret)
      {
        PROTECT(ret = NEW_NUMERIC(1));
        NUMERIC_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: void lpx_scale_prob(LPX *lp); **/
SEXP R_lpx_scale_prob(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_scale_prob(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: void lpx_unscale_prob(LPX *lp); **/
SEXP R_lpx_unscale_prob(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_unscale_prob(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: void lpx_std_basis(LPX *lp); **/
SEXP R_lpx_std_basis(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_std_basis(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: void lpx_adv_basis(LPX *lp); **/
SEXP R_lpx_adv_basis(SEXP lp)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_adv_basis(R_ExternalPtrAddr(lp)); 
end:
    return ret;
} 
/** glpk api: int lpx_simplex(LPX *lp); **/
SEXP R_lpx_simplex(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_simplex(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_interior(LPX *lp); **/
SEXP R_lpx_interior(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_interior(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_integer(LPX *lp); **/
SEXP R_lpx_integer(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_integer(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_intopt(LPX *mip); **/
SEXP R_lpx_intopt(SEXP mip)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(mip);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_intopt(R_ExternalPtrAddr(mip));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_invert(LPX *lp); **/
SEXP R_lpx_invert(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_invert(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: void lpx_ftran(LPX *lp, double x[]); **/
SEXP R_lpx_ftran(SEXP lp, SEXP x)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_ftran(R_ExternalPtrAddr(lp), NUMERIC_POINTER(x)); 
end:
    return ret;
} 
/** glpk api: void lpx_btran(LPX *lp, double x[]); **/
SEXP R_lpx_btran(SEXP lp, SEXP x)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_btran(R_ExternalPtrAddr(lp), NUMERIC_POINTER(x)); 
end:
    return ret;
} 
/** glpk api: void lpx_eval_b_prim(LPX *lp, double row_prim[], double col_prim[]); **/
SEXP R_lpx_eval_b_prim(SEXP lp, SEXP row_prim, SEXP col_prim)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_eval_b_prim(R_ExternalPtrAddr(lp), NUMERIC_POINTER(row_prim), NUMERIC_POINTER(col_prim)); 
end:
    return ret;
} 
/** glpk api: void lpx_eval_b_dual(LPX *lp, double row_dual[], double col_dual[]); **/
SEXP R_lpx_eval_b_dual(SEXP lp, SEXP row_dual, SEXP col_dual)
{
    SEXP ret = R_NilValue;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;
    lpx_eval_b_dual(R_ExternalPtrAddr(lp), NUMERIC_POINTER(row_dual), NUMERIC_POINTER(col_dual)); 
end:
    return ret;
} 
/** glpk api: int lpx_warm_up(LPX *lp); **/
SEXP R_lpx_warm_up(SEXP lp)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_warm_up(R_ExternalPtrAddr(lp));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_eval_tab_row(LPX *lp, int k, int ind[], double val[]); **/
SEXP R_lpx_eval_tab_row(SEXP lp, SEXP k, SEXP ind, SEXP val)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_eval_tab_row(R_ExternalPtrAddr(lp), INTEGER_VALUE(k), INTEGER_POINTER(ind), NUMERIC_POINTER(val));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_eval_tab_col(LPX *lp, int k, int ind[], double val[]); **/
SEXP R_lpx_eval_tab_col(SEXP lp, SEXP k, SEXP ind, SEXP val)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_eval_tab_col(R_ExternalPtrAddr(lp), INTEGER_VALUE(k), INTEGER_POINTER(ind), NUMERIC_POINTER(val));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_transform_row(LPX *lp, int len, int ind[], double val[]); **/
SEXP R_lpx_transform_row(SEXP lp, SEXP len, SEXP ind, SEXP val)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_transform_row(R_ExternalPtrAddr(lp), INTEGER_VALUE(len), INTEGER_POINTER(ind), NUMERIC_POINTER(val));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_transform_col(LPX *lp, int len, int ind[], double val[]); **/
SEXP R_lpx_transform_col(SEXP lp, SEXP len, SEXP ind, SEXP val)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_transform_col(R_ExternalPtrAddr(lp), INTEGER_VALUE(len), INTEGER_POINTER(ind), NUMERIC_POINTER(val));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: LPX *lpx_read_mps(char *fname); **/
SEXP R_lpx_read_mps(SEXP fname)
{
    SEXP ret = R_NilValue;
    LPX * xret = 0;


    if (R_glpk_setjmp()) goto end;

    xret = lpx_read_mps(CHARACTER_VALUE(fname));
    if (xret)
      {
        ret = R_MakeExternalPtr(xret, LPX_type_tag, R_NilValue);
        R_RegisterCFinalizer(ret, (R_CFinalizer_t) R_lpx_delete_prob);
      } 
end:
    return ret;
} 
/** glpk api: int lpx_write_mps(LPX *lp, char *fname); **/
SEXP R_lpx_write_mps(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_write_mps(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_read_bas(LPX *lp, char *fname); **/
SEXP R_lpx_read_bas(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_read_bas(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_write_bas(LPX *lp, char *fname); **/
SEXP R_lpx_write_bas(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_write_bas(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: LPX *lpx_read_freemps(char *fname); **/
SEXP R_lpx_read_freemps(SEXP fname)
{
    SEXP ret = R_NilValue;
    LPX * xret = 0;


    if (R_glpk_setjmp()) goto end;

    xret = lpx_read_freemps(CHARACTER_VALUE(fname));
    if (xret)
      {
        ret = R_MakeExternalPtr(xret, LPX_type_tag, R_NilValue);
        R_RegisterCFinalizer(ret, (R_CFinalizer_t) R_lpx_delete_prob);
      } 
end:
    return ret;
} 
/** glpk api: int lpx_write_freemps(LPX *lp, char *fname); **/
SEXP R_lpx_write_freemps(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_write_freemps(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_print_prob(LPX *lp, char *fname); **/
SEXP R_lpx_print_prob(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_print_prob(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_print_sol(LPX *lp, char *fname); **/
SEXP R_lpx_print_sol(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_print_sol(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_print_ips(LPX *lp, char *fname); **/
SEXP R_lpx_print_ips(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_print_ips(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_print_mip(LPX *lp, char *fname); **/
SEXP R_lpx_print_mip(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_print_mip(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: int lpx_print_sens_bnds(LPX *lp, char *fname); **/
SEXP R_lpx_print_sens_bnds(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_print_sens_bnds(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: LPX *lpx_read_cpxlp(char *fname); **/
SEXP R_lpx_read_cpxlp(SEXP fname)
{
    SEXP ret = R_NilValue;
    LPX * xret = 0;


    if (R_glpk_setjmp()) goto end;

    xret = lpx_read_cpxlp(CHARACTER_VALUE(fname));
    if (xret)
      {
        ret = R_MakeExternalPtr(xret, LPX_type_tag, R_NilValue);
        R_RegisterCFinalizer(ret, (R_CFinalizer_t) R_lpx_delete_prob);
      } 
end:
    return ret;
} 
/** glpk api: int lpx_write_cpxlp(LPX *lp, char *fname); **/
SEXP R_lpx_write_cpxlp(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_write_cpxlp(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
} 
/** glpk api: LPX *lpx_extract_prob(void *mpl); **/
SEXP R_lpx_extract_prob(SEXP mpl)
{
    SEXP ret = R_NilValue;
    LPX * xret = 0;


    if (R_glpk_setjmp()) goto end;

    xret = lpx_extract_prob(R_ExternalPtrAddr(mpl));
    if (xret)
      {
        ret = R_MakeExternalPtr(xret, LPX_type_tag, R_NilValue);
        R_RegisterCFinalizer(ret, (R_CFinalizer_t) R_lpx_delete_prob);
      } 
end:
    return ret;
} 
/** glpk api: LPX *lpx_read_model(char *model, char *data, char *output); **/
SEXP R_lpx_read_model(SEXP model, SEXP data, SEXP output)
{
    SEXP ret = R_NilValue;
    LPX * xret = 0;


    if (R_glpk_setjmp()) goto end;

    xret = lpx_read_model(CHARACTER_VALUE(model), 
                          R_GLPK_CHARACTER_VALUE(data), 
                          R_GLPK_CHARACTER_VALUE(output));
    if (xret)
      {
        ret = R_MakeExternalPtr(xret, LPX_type_tag, R_NilValue);
        R_RegisterCFinalizer(ret, (R_CFinalizer_t) R_lpx_delete_prob);
      } 
end:
    return ret;
} 
/** glpk api: LPX *lpx_read_prob(char *fname); **/
SEXP R_lpx_read_prob(SEXP fname)
{
    SEXP ret = R_NilValue;
    LPX * xret = 0;


    if (R_glpk_setjmp()) goto end;

    xret = lpx_read_prob(CHARACTER_VALUE(fname));
    if (xret)
      {
        ret = R_MakeExternalPtr(xret, LPX_type_tag, R_NilValue);
        R_RegisterCFinalizer(ret, (R_CFinalizer_t) R_lpx_delete_prob);
      } 
end:
    return ret;
} 
/** glpk api: int lpx_write_prob(LPX *lp, char *fname); **/
SEXP R_lpx_write_prob(SEXP lp, SEXP fname)
{
    SEXP ret = R_NilValue;
    int xret = 0;

    R_LPX_CHECK(lp);

    if (R_glpk_setjmp()) goto end;

    xret = lpx_write_prob(R_ExternalPtrAddr(lp), CHARACTER_VALUE(fname));
    if (xret)
      {
        PROTECT(ret = NEW_INTEGER(1));
        INTEGER_POINTER(ret)[0] = xret;
        UNPROTECT(1); 
      } 
end:
    return ret;
}
