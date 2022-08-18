#include "lambda_tokens.h"
#include "lambda_expressions.h"

static ltoken_pool g_ltp = {0};
static subexpr_pool g_subep = {0};
static texpr_pool g_tep = {0};

int main()
{
  tkzexpr(&g_ltp, "^ab.ab[a->^z.z]");
  dbgltokens(&g_ltp);

  ptokens(&g_ltp, &g_tep, &g_subep);
  dbgtexprs(&g_tep);
  dbgsubexprs(&g_subep);

  return 0;
}
