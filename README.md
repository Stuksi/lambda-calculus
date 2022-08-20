# Lamba Calculus
An easy implementation of some core lambda calculus concepts

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
LambdaTerm         := ^, VariableTerm+
VariableTerm       := 0 | ... | 9
```

## Already Implemented:
- Named Lambda Expression Parsing
- Named Lambda Expression Substitutions
- Nameless Expressions Parsing
- Nameless Expressions Substitutions

## To Do:
- Bidirectional Named To Nameless Expressions Conversion
- Examples
- Specs
