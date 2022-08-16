/*
  Lambda Expression Grammar:
    TExpr := (BTExpr | NBTExpr), ATExpr
    BTExpr := (, NBTExpr, )
    NBTExpr := LTExpr | VarTExpr
    ATExpr := TExpr | ""
    SubExpr := [, Var, -, >, TExpr, ]
    LTExpr := ^, VarTExpr, ., TExpr
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
  vartexpr *vartexpr;
  texpr *texpr;
};

struct vartexpr
{
  var *var;
};

struct var
{
  char sym;
};

void *process_tokenized_expr(ltokens *ltokens)
{
  return (void *)0;
}

#endif

// struct term {
//   char expr[TERM_LENGTH];
//   uint8_t expr_sz;
//   termp *props;
// };

// struct termp {
//   bool bterm;
//   bool lterm;
//   bool sub;
//   ltermp *lterm_props;
//   sub *sub_props;
// };

// struct ltermp {
//   char b_var[BVAR_LENGTH];
//   uint8_t b_var_sz;
// };

// struct sub {
//   char t_var;
//   term *s_term;
// };