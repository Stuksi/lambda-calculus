require_relative 'spec_helper'

describe Lambda::NamelessExpressionParser do
  subject { described_class.parse(expression) }

  describe '#parse' do
    shared_examples 'parsing example' do
      it 'parses the term' do
        expect(subject).to eq(parsed_expression)
      end
    end

    context 'with variable only terms' do
      let(:expression) { '012' }
      let(:parsed_expression) do
        Lambda::NamelessExpression::NamelessExpression.new(
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
              ),
              Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
              ),
              Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                [Lambda::NamelessExpression::Terms::VariableTerm.new(2)]
              )
            ]
          )
        )
      end

      it_behaves_like 'parsing example'
    end

    context 'with lambda terms' do
      let(:expression) { '^01^10' }
      let(:parsed_expression) do
        Lambda::NamelessExpression::NamelessExpression.new(
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamelessExpression::Terms::LambdaTerm.new(
                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                  [
                    Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
                    ),
                    Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                      [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
                    ),
                    Lambda::NamelessExpression::Terms::LambdaTerm.new(
                      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                        [
                          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                            [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
                          ),
                          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                            [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
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
      let(:expression) { '(((^0))(0))' }
      let(:parsed_expression) do
        Lambda::NamelessExpression::NamelessExpression.new(
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamelessExpression::Terms::BracketedTerm.new(
                [
                  Lambda::NamelessExpression::Terms::BracketedTerm.new(
                    [
                      Lambda::NamelessExpression::Terms::BracketedTerm.new(
                        [
                          Lambda::NamelessExpression::Terms::LambdaTerm.new(
                            Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                              [
                                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                  [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
                                )
                              ]
                            )
                          )
                        ]
                      )
                    ]
                  ),
                  Lambda::NamelessExpression::Terms::BracketedTerm.new(
                    [
                      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                        [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
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
        let(:expression) { '[0->1]' }

        it 'raises an error' do
          expect { subject }.to raise_error(
            Lambda::ParserException,
            'FATAL: ivalid expression'
          )
        end
      end

      context 'which are bound' do
        let(:expression) { '0[0->1]' }
        let(:parsed_expression) do
          Lambda::NamelessExpression::NamelessExpression.new(
            Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
              [
                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                  [Lambda::NamelessExpression::Terms::VariableTerm.new(0)],
                  Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
                    Lambda::NamelessExpression::Terms::VariableTerm.new(0),
                    Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                      [
                        Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                          [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
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
      let(:expression) { '(00((^1)[0->1[1->2]]0))[0->(^^210)]' }
      let(:parsed_expression) do
        Lambda::NamelessExpression::NamelessExpression.new(
          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
            [
              Lambda::NamelessExpression::Terms::BracketedTerm.new(
                [
                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                    [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
                  ),
                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                    [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
                  ),
                  Lambda::NamelessExpression::Terms::BracketedTerm.new(
                    [
                      Lambda::NamelessExpression::Terms::BracketedTerm.new(
                        [
                          Lambda::NamelessExpression::Terms::LambdaTerm.new(
                            Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                              [
                                Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                  [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
                                )
                              ]
                            )
                          )
                        ],
                        Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
                          Lambda::NamelessExpression::Terms::VariableTerm.new(0),
                          Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                            [
                              Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                [Lambda::NamelessExpression::Terms::VariableTerm.new(1)],
                                Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
                                  Lambda::NamelessExpression::Terms::VariableTerm.new(1),
                                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                    [
                                      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                        [Lambda::NamelessExpression::Terms::VariableTerm.new(2)]
                                      )
                                    ]
                                  )
                                )
                              )
                            ]
                          )
                        )
                      ),
                      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                        [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
                      )
                    ]
                  ),
                ],
                Lambda::NamelessExpression::Terms::SubstitutionTerm.new(
                  Lambda::NamelessExpression::Terms::VariableTerm.new(0),
                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                    [
                      Lambda::NamelessExpression::Terms::BracketedTerm.new(
                        [
                          Lambda::NamelessExpression::Terms::LambdaTerm.new(
                            Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                              [
                                Lambda::NamelessExpression::Terms::LambdaTerm.new(
                                  Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                    [
                                      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                        [Lambda::NamelessExpression::Terms::VariableTerm.new(2)]
                                      ),
                                      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                        [Lambda::NamelessExpression::Terms::VariableTerm.new(1)]
                                      ),
                                      Lambda::NamelessExpression::Terms::NonBracketedTerm.new(
                                        [Lambda::NamelessExpression::Terms::VariableTerm.new(0)]
                                      )
                                    ]
                                  )
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
      let(:expression) { '000[0->1]x0' }

      it 'raises an error' do
        expect { subject }.to raise_error(
          Lambda::NamelessExpression::Tokens::TokenizerException,
          "FATAL: invalid token x"
        )
      end
    end
  end
end
