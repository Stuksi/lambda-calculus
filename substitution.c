#include "lambda_tokens.h"
#include "lambda_expressions.h"

int main()
{
  ltokens tokens = tokenize_expr("       ^abcde.abcde(abc) [x -> b] ");
  debug_tokens(tokens);
  return 0;
}
