/*
  Lambda Expression Tokens:
    ( ) [ ] a-z ^ . - > 
*/

#ifndef _LAMBDA_TOKENS_H
#define _LAMBDA_TOKENS_H

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

#define MAX_LTOKENS 1024

typedef enum {
  op_br_e,
  cl_br_e,
  op_sqbr_e,
  cl_sqbr_e,
  var_e,
  lambda_e,
  dot_e,
  dash_e,
  arrow_e
} ltoken_e;

typedef struct {
  ltoken_e type;
  char sym;
} ltoken;

typedef struct {
  ltoken tn[MAX_LTOKENS];
  size_t sz;
} ltoken_pool;

void tkzexpr(ltoken_pool *ltp, const char *expr)
{
  size_t lti = 0;

  while (*expr != '\0')
  {
    while(*expr == ' ') expr++;
    if (*expr == '\0') break;
    assert(lti < MAX_LTOKENS);

    ltoken lt = {0};
    lt.sym = *expr;

    if      (*expr == '(') lt.type = op_br_e;
    else if (*expr == ')') lt.type = cl_br_e;
    else if (*expr == '[') lt.type = op_sqbr_e;
    else if (*expr == ']') lt.type = cl_sqbr_e;
    else if (*expr == '^') lt.type = lambda_e;
    else if (*expr == '.') lt.type = dot_e;
    else if (*expr == '-') lt.type = dash_e;
    else if (*expr == '>') lt.type = arrow_e;
    else if (*expr >= 'a' && *expr <= 'z') lt.type = var_e;
    else assert(false);

    ltp->tn[lti++] = lt;
    expr++;
  }

  ltp->sz = lti;
}

char *strltokentype(ltoken_e type)
{
  switch (type)
  {
  case op_br_e:
    return "open_bracket";
  case cl_br_e:
    return "closed_bracket";
  case op_sqbr_e:
    return "open_square_bracket";
  case cl_sqbr_e:
    return "closed_square_bracket";
  case var_e:
    return "variable";
  case lambda_e:
    return "lambda";
  case dot_e:
    return "dot";
  case dash_e:
    return "dash";
  case arrow_e:
    return "arrow";
  }
  assert(false);
}

void dbgltokens(const ltoken_pool *ltp)
{
  printf("DEBUG: Lambda Tokens\n");
  for (size_t i = 0; i < ltp->sz; ++i)
    printf("  %s, %c\n", strltokentype(ltp->tn[i].type), ltp->tn[i].sym);
  printf("\n");
}

#endif
