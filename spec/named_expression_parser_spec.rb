require_relative 'spec_helper'

describe Lambda::NamedExpressionParser do
  subject { described_class.parse(expression) }

  describe '#parse' do
    shared_examples 'parsing example' do
      it 'parses the term' do
        expect(subject).to eq(parsed_expression)
      end
    end

    context 'with variable only terms' do
      let(:expression) { 'xyz' }
      let(:parsed_expression) do
        Lambda::NamedExpression::NamedExpression.new(
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
              ),
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
              ),
              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('z')]
              )
            ]
          )
        )
      end

      it_behaves_like 'parsing example'
    end

    context 'with lambda terms' do
      let(:expression) { '^x.xy^y.yx' }
      let(:parsed_expression) do
        Lambda::NamedExpression::NamedExpression.new(
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::LambdaTerm.new(
                [Lambda::NamedExpression::Terms::VariableTerm.new('x')],
                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                  [
                    Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                    ),
                    Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
                    ),
                    Lambda::NamedExpression::Terms::LambdaTerm.new(
                      [Lambda::NamedExpression::Terms::VariableTerm.new('y')],
                      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                        [
                          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                            [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
                          ),
                          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                            [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                          )
                        ]
                      )
                    )
                  ]
                )
              )
            ]
          )
        )
      end

      it_behaves_like 'parsing example'
    end

    context 'with bracketed terms' do
      let(:expression) { '(((^x.x))(x))' }
      let(:parsed_expression) do
        Lambda::NamedExpression::NamedExpression.new(
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::BracketedTerm.new(
                [
                  Lambda::NamedExpression::Terms::BracketedTerm.new(
                    [
                      Lambda::NamedExpression::Terms::BracketedTerm.new(
                        [
                          Lambda::NamedExpression::Terms::LambdaTerm.new(
                            [Lambda::NamedExpression::Terms::VariableTerm.new('x')],
                            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                              [
                                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                  [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                                )
                              ]
                            )
                          )
                        ]
                      )
                    ]
                  ),
                  Lambda::NamedExpression::Terms::BracketedTerm.new(
                    [
                      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                        [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                      )
                    ]
                  )
                ]
              )
            ]
          )
        )
      end

      it_behaves_like 'parsing example'
    end

    context 'with substitution terms' do
      context 'which are unbound' do
        let(:expression) { '[x->y]' }

        it 'raises an error' do
          expect { subject }.to raise_error(Lambda::NamedExpressionParserException, 'FATAL: ivalid expression')
        end
      end

      context 'which are bound' do
        let(:expression) { '^x.xy^y.yx' }
        let(:parsed_expression) do
          Lambda::NamedExpression::NamedExpression.new(
            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
              [
                Lambda::NamedExpression::Terms::LambdaTerm.new(
                  [Lambda::NamedExpression::Terms::VariableTerm.new('x')],
                  Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                    [
                      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                        [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                      ),
                      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                        [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
                      ),
                      Lambda::NamedExpression::Terms::LambdaTerm.new(
                        [Lambda::NamedExpression::Terms::VariableTerm.new('y')],
                        Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                          [
                            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                              [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
                            ),
                            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                              [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                            )
                          ]
                        )
                      )
                    ]
                  )
                )
              ]
            )
          )
        end

        it_behaves_like 'parsing example'
      end

      context 'with bracketed terms' do
        let(:expression) { 'x[x->y]' }
        let(:parsed_expression) do
          Lambda::NamedExpression::NamedExpression.new(
            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
              [
                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                  [Lambda::NamedExpression::Terms::VariableTerm.new('x')],
                  Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                    Lambda::NamedExpression::Terms::VariableTerm.new('x'),
                    Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                      [
                        Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                          [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
                        )
                      ]
                    )
                  )
                )
              ]
            )
          )
        end

        it_behaves_like 'parsing example'
      end
    end

    context 'with combined expression' do
      let(:expression) { '(xy((^x.z)[z->y[y->x]]y))[y->(^wu.vwu)]' }
      let(:parsed_expression) do
        Lambda::NamedExpression::NamedExpression.new(
          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamedExpression::Terms::BracketedTerm.new(
                [
                  Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                    [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                  ),
                  Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                    [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
                  ),
                  Lambda::NamedExpression::Terms::BracketedTerm.new(
                    [
                      Lambda::NamedExpression::Terms::BracketedTerm.new(
                        [
                          Lambda::NamedExpression::Terms::LambdaTerm.new(
                            [Lambda::NamedExpression::Terms::VariableTerm.new('x')],
                            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                              [
                                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                  [Lambda::NamedExpression::Terms::VariableTerm.new('z')]
                                )
                              ]
                            )
                          )
                        ],
                        Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                          Lambda::NamedExpression::Terms::VariableTerm.new('z'),
                          Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                            [
                              Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                [Lambda::NamedExpression::Terms::VariableTerm.new('y')],
                                Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                                  Lambda::NamedExpression::Terms::VariableTerm.new('y'),
                                  Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                    [
                                      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                        [Lambda::NamedExpression::Terms::VariableTerm.new('x')]
                                      )
                                    ]
                                  )
                                )
                              )
                            ]
                          )
                        )
                      ),
                      Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                        [Lambda::NamedExpression::Terms::VariableTerm.new('y')]
                      )
                    ]
                  ),
                ],
                Lambda::NamedExpression::Terms::SubstitutionTerm.new(
                  Lambda::NamedExpression::Terms::VariableTerm.new('y'),
                  Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                    [
                      Lambda::NamedExpression::Terms::BracketedTerm.new(
                        [
                          Lambda::NamedExpression::Terms::LambdaTerm.new(
                            [
                              Lambda::NamedExpression::Terms::VariableTerm.new('w'),
                              Lambda::NamedExpression::Terms::VariableTerm.new('u')
                            ],
                            Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                              [
                                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                  [Lambda::NamedExpression::Terms::VariableTerm.new('v')]
                                ),
                                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                  [Lambda::NamedExpression::Terms::VariableTerm.new('w')]
                                ),
                                Lambda::NamedExpression::Terms::NonBracketedTerm.new(
                                  [Lambda::NamedExpression::Terms::VariableTerm.new('u')]
                                )
                              ]
                            )
                          )
                        ]
                      )
                    ]
                  )
                )
              )
            ]
          )
        )
      end

      it_behaves_like 'parsing example'
    end

    context 'with invalid characters' do
      let(:expression) { 'xyz[x->y]0x' }

      it 'raises an error' do
        expect { subject }.to raise_error(Lambda::NamedExpression::Tokens::NamedExpressionTokenizerException, "FATAL: invalid token 0")
      end
    end
  end
end
