require_relative 'non_bracketed_term'

module Lambda
  module NamelessExpression
    module Terms
      class BracketedTerm < NonBracketedTerm
        def to_s
          "(#{terms.map(&:to_s).join})#{substitution}"
        end
      end
    end
  end
end
