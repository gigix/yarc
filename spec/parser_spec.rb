require File.dirname(__FILE__) + "/spec_helper"

describe Parser do
  describe :expr do
    it "generates postfix expression" do
      tokens = Lexer.new("3+2-5").scan_all
      parser = Parser.new(tokens)
      expr = parser.expr
      
      expr.to_s.should == "3 2 + 5 -"
      expr.execute.should == 0
    end    
  end
end