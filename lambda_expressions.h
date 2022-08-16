/*
  Lambda Expression Grammar:
    TExpr := (BTExpr | NBTExpr), [SubExpr], ATExpr
    BTExpr := (, NBTExpr, )
    NBTExpr := LTExpr | VarTExpr
    ATExpr := TExpr | ""
    SubExpr := [, Var, -, >, TExpr, ]
    LTExpr := ^, VarTExpr, ., VarTExpr
    VarTExpr := Var, (VarTExpr | "")
    Var := a | ... | z

  TExpr - Term Expression
  BTExpr - Bracket Term Erxpression
  NBTExpr - Non Bracket Term Expression
  ATExpr - Applicated Term Expression
  SubExpr - Substitute Expression
  LTExpr - Lambda Term Expression
  VarTExpr - Variable Term Expression
  Var - Variable
*/

#ifndef _LAMBDA_EXPRESSIONS_H
#define _LAMBDA_EXPRESSIONS_H

#include "lambda_tokens.h"

#define MAX_VARTEXPR_VARS 32

typedef struct texpr texpr;
typedef struct btexpr btexpr;
typedef struct nbtexpr nbtexpr;
typedef struct ltexpr ltexpr;
typedef struct vartexpr vartexpr;
typedef struct var var;

struct texpr
{
  btexpr *btexpr;
  nbtexpr *nbtexpr;
  texpr *atexpr;
};

struct btexpr
{
  nbtexpr *nbtexpr;
};

struct nbtexpr
{
  ltexpr *ltexpr;
  vartexpr *vartexpr;
};

struct subexpr
{
  var *var;
  texpr *texpr;
};

struct ltexpr
{
  vartexpr *bvartexpr;
  vartexpr *fvartexpr;
};

struct vartexpr
{
  var *vars[MAX_VARTEXPR_VARS];
  size_t sz;
};

struct var
{
  char sym;
};

texpr* parse_texpr(const ltokens*, size_t*);
btexpr* parse_btexpr(const ltokens*, size_t*);
nbtexpr* parse_nbtexpr(const ltokens*, size_t*);
ltexpr* parse_ltexpr(const ltokens*, size_t*);
vartexpr* parse_vartexpr(const ltokens*, size_t*);
var* parse_var(const ltokens*, size_t*);

texpr* parse_expr_from_tokens(const ltokens *ltokens)
{
  size_t curt = 0;
  return parse_texpr(ltokens, &curt);
}

texpr* parse_texpr(const ltokens *ltokens, size_t *curt)
{
  if (*curt >= ltokens->sz) return NULL;
  texpr *texpr = {0};
  if (ltokens->tn[*curt].type == op_br_e)
    texpr->btexpr = parse_btexpr(ltokens, curt);
  else
    texpr->nbtexpr = parse_nbtexpr(ltokens, curt);
  // SUBEXPR !!!
  texpr->atexpr = parse_texpr(ltokens, curt);
  return texpr;
}

btexpr* parse_btexpr(const ltokens *ltokens, size_t *curt)
{
  assert(ltokens->tn[*curt++].type == op_br_e);
  btexpr *btexpr = {0};
  btexpr->nbtexpr = parse_nbtexpr(ltokens, curt);
  assert(ltokens->tn[*curt++].type == cl_br_e);
  return btexpr;
}

nbtexpr* parse_nbtexpr(const ltokens *ltokens, size_t *curt)
{
  nbtexpr *nbtexpr = {0};
  if (ltokens->tn[*curt].type == lambda_e)
    nbtexpr->ltexpr = parse_ltexpr(ltokens, curt);
  else
    nbtexpr->vartexpr = parse_vartexpr(ltokens, curt);
  return nbtexpr;
}

ltexpr* parse_ltexpr(const ltokens *ltokens, size_t *curt)
{
  ltexpr *ltexpr = {0};
  assert(ltokens->tn[*curt++].type == lambda_e);
  ltexpr->bvartexpr = parse_vartexpr(ltokens, curt);
  assert(ltokens->tn[*curt++].type == dot_e);
  ltexpr->fvartexpr = parse_vartexpr(ltokens, curt);
  return ltexpr;
}

vartexpr* parse_vartexpr(const ltokens *ltokens, size_t *curt)
{
  vartexpr *vartexpr = {0};
  size_t vari = 0;
  assert(ltokens->tn[*curt].type == var_e);
  while (ltokens->tn[*curt].type == var_e)
  {
    assert(vari < MAX_VARTEXPR_VARS);
    vartexpr->vars[vari++] = parse_var(ltokens, curt);
  }
  return vartexpr;
}

var* parse_var(const ltokens *ltokens, size_t *curt)
{
  var *var = {0};
  assert(ltokens->tn[*curt].type == var_e);
  var->sym = ltokens->tn[*curt++].sym;
  return var;
}

#endif
