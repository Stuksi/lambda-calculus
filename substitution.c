#include "lambda_tokens.h"
#include "lambda_expressions.h"

int main()
{
  ltoken_pool ltp = tokenize_expr("^ab.ab");
  debug_tokens(&ltp);
  subexpr_pool subep = {0};
  texpr_pool tep = {0};
  parse_expr_from_tokens_to_pool(&ltp, &tep, &subep);
  debug_texpr(&tep);
  return 0;
}
