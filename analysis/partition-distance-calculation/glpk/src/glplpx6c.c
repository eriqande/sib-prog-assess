/* glplpx6c.c (branch-and-bound solver routine) */

/*----------------------------------------------------------------------
-- Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005 Andrew Makhorin,
-- Department for Applied Informatics, Moscow Aviation Institute,
-- Moscow, Russia. All rights reserved. E-mail: <mao@mai2.rcnet.ru>.
--
-- This file is part of GLPK (GNU Linear Programming Kit).
--
-- GLPK is free software; you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2, or (at your option)
-- any later version.
--
-- GLPK is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-- or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
-- License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with GLPK; see the file COPYING. If not, write to the Free
-- Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
-- 02111-1307, USA.
----------------------------------------------------------------------*/

#include <math.h>
#include <stddef.h>
#include "glplib.h"
#include "glpmip.h"

/*----------------------------------------------------------------------
-- lpx_integer - easy-to-use driver to the branch-and-bound method.
--
-- *Synopsis*
--
-- #include "glplpx.h"
-- int lpx_integer(LPX *mip);
--
-- *Description*
--
-- The routine lpx_integer is intended to solve a MIP problem, which is
-- specified by the parameter mip.
--
-- On entry the problem object should contain an optimal solution of LP
-- relaxation (it can be obtained with the simplex method).
--
-- *Returns*
--
-- The routine lpx_integer returns one of the following exit codes:
--
-- LPX_E_OK       the MIP problem has been successfully solved.
--
-- LPX_E_FAULT    the solver cannot start the search because either
--                the problem is not of MIP class, or
--                the problem object doesn't contain optimal solution
--                for LP relaxation, or
--                some integer variable has non-integer lower or upper
--                bound.
--
-- LPX_E_ITLIM    iterations limit exceeded.
--
-- LPX_E_TMLIM    time limit exceeded.
--
-- LPX_E_SING     an error occurred on solving LP relaxation of some
--                subproblem.
--
-- Should note that additional exit codes may appear in future versions
-- of this routine. */

int lpx_integer(LPX *mip)
{     int m = lpx_get_num_rows(mip);
      int n = lpx_get_num_cols(mip);
      MIPTREE *tree;
      LPX *lp;
      int ret, i, j, stat, type, len, *ind;
      double lb, ub, coef, *val;
      /* the problem must be of MIP class */
      if (lpx_get_class(mip) != LPX_MIP)
      {  print("lpx_integer: problem is not of MIP class");
         ret = LPX_E_FAULT;
         goto done;
      }
      /* an optimal solution of LP relaxation must be known */
      if (lpx_get_status(mip) != LPX_OPT)
      {  print("lpx_integer: optimal solution of LP relaxation required"
            );
         ret = LPX_E_FAULT;
         goto done;
      }
      /* bounds of all integer variables must be integral */
      for (j = 1; j <= n; j++)
      {  if (lpx_get_col_kind(mip, j) != LPX_IV) continue;
         type = lpx_get_col_type(mip, j);
         if (type == LPX_LO || type == LPX_DB || type == LPX_FX)
         {  lb = lpx_get_col_lb(mip, j);
            if (lb != floor(lb))
            {  print("lpx_integer: integer column %d has non-integer lo"
                  "wer bound or fixed value %g", j, lb);
               ret = LPX_E_FAULT;
               goto done;
            }
         }
         if (type == LPX_UP || type == LPX_DB)
         {  ub = lpx_get_col_ub(mip, j);
            if (ub != floor(ub))
            {  print("lpx_integer: integer column %d has non-integer up"
                  "per bound %g", j, ub);
               ret = LPX_E_FAULT;
               goto done;
            }
         }
      }
      /* it seems all is ok */
      if (lpx_get_int_parm(mip, LPX_K_MSGLEV) >= 2)
         print("Integer optimization begins...");
      /* create the branch-and-bound tree */
      tree = mip_create_tree(m, n, lpx_get_obj_dir(mip));
      /* set up column kinds */
      for (j = 1; j <= n; j++)
         tree->int_col[j] = (lpx_get_col_kind(mip, j) == LPX_IV);
      /* access the LP relaxation template */
      lp = tree->lp;
      /* set up the objective function */
      tree->int_obj = 1;
      for (j = 0; j <= tree->n; j++)
      {  coef = lpx_get_obj_coef(mip, j);
         lpx_set_obj_coef(lp, j, coef);
         if (coef != 0.0 && !(tree->int_col[j] && coef == floor(coef)))
            tree->int_obj = 0;
      }
      if (lpx_get_int_parm(mip, LPX_K_MSGLEV) >= 2 && tree->int_obj)
         print("Objective function is integral");
      /* set up the constraint matrix */
      ind = ucalloc(1+n, sizeof(int));
      val = ucalloc(1+n, sizeof(double));
      for (i = 1; i <= m; i++)
      {  len = lpx_get_mat_row(mip, i, ind, val);
         lpx_set_mat_row(lp, i, len, ind, val);
      }
      ufree(ind);
      ufree(val);
      /* set up scaling matrices */
      for (i = 1; i <= m; i++)
         lpx_set_rii(lp, i, lpx_get_rii(mip, i));
      for (j = 1; j <= n; j++)
         lpx_set_sjj(lp, j, lpx_get_sjj(mip, j));
      /* revive the root subproblem */
      mip_revive_node(tree, 1);
      /* set up row attributes for the root subproblem */
      for (i = 1; i <= m; i++)
      {  type = lpx_get_row_type(mip, i);
         lb = lpx_get_row_lb(mip, i);
         ub = lpx_get_row_ub(mip, i);
         stat = lpx_get_row_stat(mip, i);
         lpx_set_row_bnds(lp, i, type, lb, ub);
         lpx_set_row_stat(lp, i, stat);
      }
      /* set up column attributes for the root subproblem */
      for (j = 1; j <= n; j++)
      {  type = lpx_get_col_type(mip, j);
         lb = lpx_get_col_lb(mip, j);
         ub = lpx_get_col_ub(mip, j);
         stat = lpx_get_col_stat(mip, j);
         lpx_set_col_bnds(lp, j, type, lb, ub);
         lpx_set_col_stat(lp, j, stat);
      }
      /* freeze the root subproblem */
      mip_freeze_node(tree);
      /* inherit some control parameters and statistics */
      tree->msg_lev = lpx_get_int_parm(mip, LPX_K_MSGLEV);
      if (tree->msg_lev > 2) tree->msg_lev = 2;
      tree->branch = lpx_get_int_parm(mip, LPX_K_BRANCH);
      tree->btrack = lpx_get_int_parm(mip, LPX_K_BTRACK);
      tree->tol_int = lpx_get_real_parm(mip, LPX_K_TOLINT);
      tree->tol_obj = lpx_get_real_parm(mip, LPX_K_TOLOBJ);
      tree->tm_lim = lpx_get_real_parm(mip, LPX_K_TMLIM);
      lpx_set_int_parm(lp, LPX_K_PRICE, lpx_get_int_parm(mip,
         LPX_K_PRICE));
      lpx_set_real_parm(lp, LPX_K_RELAX, lpx_get_real_parm(mip,
         LPX_K_RELAX));
      lpx_set_real_parm(lp, LPX_K_TOLBND, lpx_get_real_parm(mip,
         LPX_K_TOLBND));
      lpx_set_real_parm(lp, LPX_K_TOLDJ, lpx_get_real_parm(mip,
         LPX_K_TOLDJ));
      lpx_set_real_parm(lp, LPX_K_TOLPIV, lpx_get_real_parm(mip,
         LPX_K_TOLPIV));
      lpx_set_int_parm(lp, LPX_K_ITLIM, lpx_get_int_parm(mip,
         LPX_K_ITLIM));
      lpx_set_int_parm(lp, LPX_K_ITCNT, lpx_get_int_parm(mip,
         LPX_K_ITCNT));
      /* reset the status of MIP solution */
      lpx_put_mip_soln(mip, LPX_I_UNDEF, NULL, NULL);
      /* try solving the problem */
      ret = mip_driver(tree);
      /* if an integer feasible solution has been found, copy it to the
         MIP problem object */
      if (tree->found)
         lpx_put_mip_soln(mip, LPX_I_FEAS, &tree->mipx[0],
            &tree->mipx[m]);
      /* copy back statistics about spent resources */
      lpx_set_real_parm(mip, LPX_K_TMLIM, tree->tm_lim);
      lpx_set_int_parm(mip, LPX_K_ITLIM, lpx_get_int_parm(lp,
         LPX_K_ITLIM));
      lpx_set_int_parm(mip, LPX_K_ITCNT, lpx_get_int_parm(lp,
         LPX_K_ITCNT));
      /* analyze exit code reported by the mip driver */
      switch (ret)
      {  case MIP_E_OK:
            if (tree->found)
            {  if (lpx_get_int_parm(mip, LPX_K_MSGLEV) >= 3)
                  print("INTEGER OPTIMAL SOLUTION FOUND");
               lpx_put_mip_soln(mip, LPX_I_OPT, NULL, NULL);
            }
            else
            {  if (lpx_get_int_parm(mip, LPX_K_MSGLEV) >= 3)
                  print("PROBLEM HAS NO INTEGER FEASIBLE SOLUTION");
               lpx_put_mip_soln(mip, LPX_I_NOFEAS, NULL, NULL);
            }
            ret = LPX_E_OK;
            break;
         case MIP_E_ITLIM:
            if (lpx_get_int_parm(mip, LPX_K_MSGLEV) >= 3)
               print("ITERATIONS LIMIT EXCEEDED; SEARCH TERMINATED");
            ret = LPX_E_ITLIM;
            break;
         case MIP_E_TMLIM:
            if (lpx_get_int_parm(mip, LPX_K_MSGLEV) >= 3)
               print("TIME LIMIT EXCEEDED; SEARCH TERMINATED");
            ret = LPX_E_TMLIM;
            break;
         case MIP_E_ERROR:
            if (lpx_get_int_parm(mip, LPX_K_MSGLEV) >= 1)
               print("lpx_integer: cannot solve current LP relaxation");
            ret = LPX_E_SING;
            break;
         default:
            insist(ret != ret);
      }
      /* delete the branch-and-bound tree */
      mip_delete_tree(tree);
done: /* return to the application program */
      return ret;
}

/* eof */
