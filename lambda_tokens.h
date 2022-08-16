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

typedef enum ltoken_e ltoken_e;
typedef struct ltoken ltoken;
typedef struct ltokens ltokens;

enum ltoken_e
{
  op_br_e,
  cl_br_e,
  op_sqbr_e,
  cl_sqbr_e,
  var_e,
  lambda_e,
  dot_e,
  dash_e,
  arrow_e
};

struct ltoken
{
  ltoken_e type;
  char sym;
};

struct ltokens
{
  ltoken tn[MAX_LTOKENS];
  size_t sz;
};

ltokens tokenize_expr(const char *expr)
{
  size_t tokeni = 0;
  ltokens ltokens = {0};

  while (*expr != '\0')
  {
    while(*expr == ' ') expr++;
    if (*expr == '\0') break;
    assert(tokeni < MAX_LTOKENS);

    ltoken token = { .sym = *expr };

    if      (*expr == '(') token.type = op_br_e;
    else if (*expr == ')') token.type = cl_br_e;
    else if (*expr == '[') token.type = op_sqbr_e;
    else if (*expr == ']') token.type = cl_sqbr_e;
    else if (*expr == '^') token.type = lambda_e;
    else if (*expr == '.') token.type = dot_e;
    else if (*expr == '-') token.type = dash_e;
    else if (*expr == '>') token.type = arrow_e;
    else if (*expr >= 'a' && *expr <= 'z') token.type = var_e;
    else assert(false);

    ltokens.tn[tokeni++] = token;
    expr++;
  }

  ltokens.sz = tokeni;
  return ltokens;
}

void debug_tokens(ltokens ltokens)
{
  for (size_t i = 0; i < ltokens.sz; ++i)
    printf("%d, %c\n", ltokens.tn[i].type, ltokens.tn[i].sym);
}

#endif
