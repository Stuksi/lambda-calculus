module Lambda
  module NamedExpression
    module Terms
      class BracketedTerm < NonBracketedTerm
        def to_s
          "(#{terms.map(&:to_s).join})#{substitution}"
        end
      end
    end
  end
end
