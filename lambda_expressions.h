/*
  Lambda Expression Grammar:
    TExpr := (BTExpr | NBTExpr), [SubExpr], ATExpr
    BTExpr := (, NBTExpr, )
    NBTExpr := LTExpr | VarTExpr
    ATExpr := TExpr | ETExpr
    ETExpr := ""
    SubExpr := [, Var, -, >, TExpr, ]
    LTExpr := ^, VarTExpr, ., VarTExpr
    VarTExpr := Var, (VarTExpr | ETExpr)
    Var := a | ... | z

  TExpr - Term Expression
  BTExpr - Bracket Term Erxpression
  NBTExpr - Non Bracket Term Expression
  ATExpr - Applicated Term Expression
  ETExpr - Empty Term Expression
  SubExpr - Substitute Expression
  LTExpr - Lambda Term Expression
  VarTExpr - Variable Term Expression
  Var - Variable
*/

#ifndef _LAMBDA_EXPRESSIONS_H
#define _LAMBDA_EXPRESSIONS_H

#include "lambda_tokens.h"

typedef struct {
  char sym;
} var;

#define MAX_VARTEXPR_VARS 32
typedef struct {
  var vars[MAX_VARTEXPR_VARS];
  size_t sz;
} vartexpr;

typedef struct {
  vartexpr bvarte;
  vartexpr fvarte;
} ltexpr;

typedef enum {
  ltexpr_e,
  vartexpr_e
} texprte;

typedef struct {
  bool br;
  bool sub;
  texprte type;
} texprp;

typedef struct {
  ltexpr lte;
  vartexpr varte;
  texprp tep;
} texpr;

typedef struct {
  var v;
  texpr te;
  size_t tei;
} subexpr;

#define MAX_TEXPRS 16
typedef struct {
  texpr te[MAX_TEXPRS];
  size_t sz;
} texpr_pool;

typedef struct {
  subexpr sube[MAX_TEXPRS];
  size_t sz;
} subexpr_pool;

var parse_var(const ltoken_pool *ltp, size_t *curt)
{
  var v = {0};
  assert(ltp->tn[*curt].type == var_e);
  v.sym = ltp->tn[(*curt)++].sym;
  return v;
}

vartexpr parse_vartexpr(const ltoken_pool *ltp, size_t *curt)
{
  vartexpr varte = {0};
  size_t vi = 0;
  assert(ltp->tn[*curt].type == var_e);
  while (ltp->tn[*curt].type == var_e)
  {
    assert(vi < MAX_VARTEXPR_VARS);
    varte.vars[vi++] = parse_var(ltp, curt);
  }
  varte.sz = vi;
  return varte;
}

ltexpr parse_ltexpr(const ltoken_pool *ltp, size_t *curt)
{
  ltexpr lte = {0};
  assert(ltp->tn[(*curt)++].type == lambda_e);
  lte.bvarte = parse_vartexpr(ltp, curt);
  assert(ltp->tn[(*curt)++].type == dot_e);
  lte.fvarte = parse_vartexpr(ltp, curt);
  return lte;
}

texpr parse_nbtexpr(const ltoken_pool *ltp, size_t *curt)
{
  texpr te = {0};
  if (ltp->tn[*curt].type == lambda_e)
  {
    te.lte = parse_ltexpr(ltp, curt);
    te.tep.type = ltexpr_e;
  }
  else
  {
    te.varte = parse_vartexpr(ltp, curt);
    te.tep.type = vartexpr_e;
  }
  return te;
}

texpr parse_btexpr(const ltoken_pool *ltp, size_t *curt)
{
  assert(ltp->tn[(*curt)++].type == op_br_e);
  texpr te = parse_nbtexpr(ltp, curt);
  assert(ltp->tn[(*curt)++].type == cl_br_e);
  return te;
}

texpr parse_texpr(const ltoken_pool *ltp, size_t *curt)
{
  texpr te = {0};
  if (ltp->tn[*curt].type == op_br_e)
    te = parse_btexpr(ltp, curt);
  else
    te = parse_nbtexpr(ltp, curt);
  return te;
}

subexpr parse_subexpr(const ltoken_pool *ltp, size_t *curt)
{
  assert(ltp->tn[(*curt)++].type == op_sqbr_e);
  subexpr sube = {0};
  sube.v = parse_var(ltp, curt);
  assert(ltp->tn[(*curt)++].type == dash_e);
  assert(ltp->tn[(*curt)++].type == arrow_e);
  sube.te = parse_texpr(ltp, curt);
  assert(ltp->tn[(*curt)++].type == cl_sqbr_e);
  return sube;
}

void parse_expr_from_tokens_to_pool(const ltoken_pool *ltp, texpr_pool *tep, subexpr_pool *subep)
{
  size_t curt = 0, tei = 0, subei = 0;
  while (curt < ltp->sz)
  {
    assert(tei < MAX_TEXPRS);
    tep->te[tei] = parse_texpr(ltp, &curt);
    if (ltp->tn[curt].type == op_sqbr_e)
    {
      subep->sube[subei] = parse_subexpr(ltp, &curt);
      subep->sube[subei].tei = tei;
      ++subei;    
    }
    ++tei;
  }
  tep->sz = tei;
  subep->sz = subei;
}

void debug_texpr(const texpr_pool *tep)
{
}

#endif
