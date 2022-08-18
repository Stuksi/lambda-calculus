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

#define ACCEPTED_VARS 26
static char avars[ACCEPTED_VARS] = {
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
  'g', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
  's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
};

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

var pvar(const ltoken_pool *ltp, size_t *curt)
{
  var v = {0};
  assert(ltp->tn[*curt].type == var_e);
  v.sym = ltp->tn[(*curt)++].sym;
  return v;
}

vartexpr pvartexpr(const ltoken_pool *ltp, size_t *curt)
{
  vartexpr varte = {0};
  size_t vi = 0;
  assert(ltp->tn[*curt].type == var_e);
  while (ltp->tn[*curt].type == var_e)
  {
    assert(vi < MAX_VARTEXPR_VARS);
    varte.vars[vi++] = pvar(ltp, curt);
  }
  varte.sz = vi;
  return varte;
}

ltexpr pltexpr(const ltoken_pool *ltp, size_t *curt)
{
  ltexpr lte = {0};
  assert(ltp->tn[(*curt)++].type == lambda_e);
  lte.bvarte = pvartexpr(ltp, curt);
  assert(ltp->tn[(*curt)++].type == dot_e);
  lte.fvarte = pvartexpr(ltp, curt);
  return lte;
}

texpr pnbtexpr(const ltoken_pool *ltp, size_t *curt)
{
  texpr te = {0};
  if (ltp->tn[*curt].type == lambda_e)
  {
    te.lte = pltexpr(ltp, curt);
    te.tep.type = ltexpr_e;
  }
  else
  {
    te.varte = pvartexpr(ltp, curt);
    te.tep.type = vartexpr_e;
  }
  return te;
}

texpr pbtexpr(const ltoken_pool *ltp, size_t *curt)
{
  assert(ltp->tn[(*curt)++].type == op_br_e);
  texpr te = pnbtexpr(ltp, curt);
  te.tep.br = true;
  assert(ltp->tn[(*curt)++].type == cl_br_e);
  return te;
}

texpr ptexpr(const ltoken_pool *ltp, size_t *curt)
{
  texpr te = {0};
  if (ltp->tn[*curt].type == op_br_e)
    te = pbtexpr(ltp, curt);
  else
    te = pnbtexpr(ltp, curt);
  return te;
}

subexpr psubexpr(const ltoken_pool *ltp, size_t *curt)
{
  assert(ltp->tn[(*curt)++].type == op_sqbr_e);
  subexpr sube = {0};
  sube.v = pvar(ltp, curt);
  assert(ltp->tn[(*curt)++].type == dash_e);
  assert(ltp->tn[(*curt)++].type == arrow_e);
  sube.te = ptexpr(ltp, curt);
  assert(ltp->tn[(*curt)++].type == cl_sqbr_e);
  return sube;
}

void ptokens(const ltoken_pool *ltp, texpr_pool *tep, subexpr_pool *subep)
{
  size_t curt = 0, tei = 0, subei = 0;
  while (curt < ltp->sz)
  {
    assert(tei < MAX_TEXPRS);
    tep->te[tei] = ptexpr(ltp, &curt);
    if (ltp->tn[curt].type == op_sqbr_e)
    {
      subep->sube[subei] = psubexpr(ltp, &curt);
      subep->sube[subei].tei = tei;
      ++subei;    
    }
    ++tei;
  }
  tep->sz = tei;
  subep->sz = subei;
}

void strvartexpr(const vartexpr *varte, char* strvartexpr)
{
  for (size_t i = 0; i < varte->sz; ++i)
    strvartexpr[i] = varte->vars[i].sym;
  strvartexpr[varte->sz] = '\0';
}

void strltexpr(const ltexpr *lte, char* strltexpr)
{
  strltexpr[0] = '^';
  char strbvarte[MAX_VARTEXPR_VARS] = {0};
  strvartexpr(&lte->bvarte, strbvarte);
  strcat(strltexpr, strbvarte);
  strltexpr[lte->bvarte.sz + 1] = '.';
  char strfvarte[MAX_VARTEXPR_VARS] = {0};
  strvartexpr(&lte->bvarte, strfvarte);
  strcat(strltexpr, strfvarte);
}

void strtexpr(const texpr *te, char* strtexpr)
{
  if (te->tep.br) strcpy(strtexpr, "(");
  if (te->tep.type == ltexpr_e)
  {
    char strlte[MAX_LTOKENS] = {0};
    strltexpr(&te->lte, strlte);
    strcat(strtexpr, strlte);
  }
  else
  {
    char varte[MAX_VARTEXPR_VARS] = {0};
    strvartexpr(&te->varte, varte);
    strcat(strtexpr, varte);
  }
  if (te->tep.br) strcat(strtexpr, ")");
}

void strsubexpr(const subexpr *sube, char *strsube)
{
  strcpy(strsube, "[");
  strcat(strsube, &sube->v.sym);
  strcat(strsube, "->");
  char strte[MAX_LTOKENS] = {0};
  strtexpr(&sube->te, strte);
  strcat(strsube, strte);
  strcat(strsube, "]");
}

bool avar(char sym)
{
  return sym >= 'a' && sym <= 'z';
}

void subtexpr(const texpr_pool *tep, const subexpr_pool *subep, texpr_pool *step)
{
  for (size_t i = 0; i < subep->sz; ++i)
  {
    bool ravars[ACCEPTED_VARS] = {0};
    char strte[MAX_LTOKENS] = {0};
    strtexpr(&tep->te[subep->sube[i].tei], strte);
    for (size_t j = 0; j < strlen(strte); ++j)
      if (avar(strte[j])) ravars[strte[j] - 'a'] = true;
  }
}

void dbgtexprs(const texpr_pool *tep)
{
  printf("DEBUG: Term Expressions\n");
  for (size_t i = 0; i < tep->sz; ++i)
  {
    char strte[MAX_LTOKENS] = {0};
    strtexpr(&tep->te[i], strte);
    printf("  %s, index: %zu\n", strte, i);
  }
  printf("\n");
}

void dbgsubexprs(const subexpr_pool *subep)
{
  printf("DEBUG: Substitute Expressions\n");
  for (size_t i = 0; i < subep->sz; ++i)
  {
    char strsube[MAX_LTOKENS] = {0};
    strsubexpr(&subep->sube[i], strsube);
    printf("  %s, target term: %zu\n", strsube, subep->sube[i].tei);
  }
  printf("\n");
}

#endif
