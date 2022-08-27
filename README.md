# Lamba Calculus
Implementation of core Lambda Calculus concepts

## Implemented:
- Named Lambda Expression Parsing
- Named Lambda Expression Substitutions
- Nameless Lambda Expressions Parsing
- Nameless Lambda Expressions Substitutions
- Named To Nameless Expression Conversion
- Nameless To Named Expression Conversion
- Named Lambda Expressions Alpha Equivalence
- Expressions Subterms

## To Do:
- Examples
- Code Optimization / Expression Object Cleaning

## Tokens
### Named Lambda Expression:
`( ) [ ] a-z ^ . - >`

### Nameless Lambda Expression:
`( ) [ ] 0-9 ^ - >`

## Grammar
### Named Lambda Expression:
```
NamedExpression  := (NonBracketedTerm | BracketedTerm), [SubstitutionTerm], (NamedExpression | "")
BracketedTerm    := (, NonBracketedTerm, )
NonBracketedTerm := LambdaTerm | VariableTerm
SubstitutionTerm := [, VariableTerm, -, >, NamedExpression, ]
LambdaTerm       := ^, VariableTerm+, ., NamedExpression
VariableTerm     := a | ... | z
```

### Nameless Lambda Expression:
```
NamelessExpression := (NonBracketedTerm | BracketedTerm), [SubstitutionTerm], (NamelessExpression | "")
BracketedTerm      := (, NonBracketedTerm, )
NonBracketedTerm   := LambdaTerm | VariableTerm
SubstitutionTerm   := [, VariableTerm, -, >, NamelessExpression, ]
LambdaTerm         := ^, NamelessExpression
VariableTerm       := 0 | ... | 9
```
