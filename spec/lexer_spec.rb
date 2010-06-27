require File.dirname(__FILE__) + "/spec_helper"

describe Lexer do
  describe :scan do
    it "finishes with an 'end' token" do
      lexer = Lexer.new(" \t\n")
      token = lexer.scan
      token.should_not be_nil
      token.tag.should == Tag::FINISH
    end
    
    it "returns general token when input is an undefined character" do
      lexer = Lexer.new("^")
      token = lexer.scan
      token.should_not be_nil
      token.tag.should == "^"
    end
    
    it "skips whitespaces" do
      lexer = Lexer.new(" \t\n^")
      token = lexer.scan
      token.tag.should == "^"
    end
    
    it "recognizes number token" do
      lexer = Lexer.new("12345")
      token = lexer.scan
      token.class.should == NumberToken
      token.value.should == 12345
    end
    
    it "recognizes float point number" do
      lexer = Lexer.new("3.14")
      token = lexer.scan
      token.class.should == NumberToken
      token.value.should == 3.14
    end
    
    it "recognizes word token" do
      keyword = "if"
      id_1 = "ruby_style_identifier_1"
      id_2 = "javaStyleIdentifier2"
      lexer = Lexer.new("#{keyword}\n\t#{id_1} #{id_2}")
      
      token_1 = lexer.scan
      token_1.class.should == WordToken
      token_1.tag.should == Tag::IF
      
      token_2 = lexer.scan
      token_2.class.should == WordToken
      token_2.tag.should == Tag::ID
      token_2.lexeme.should == id_1
      
      token_3 = lexer.scan
      token_3.class.should == WordToken
      token_3.tag.should == Tag::ID
      token_3.lexeme.should == id_2
    end
  end
  
  describe :scan_all do  
    it "recognizes single line comment" do
      src = %Q(
        // Single line comment
        this_is_1st_identifier
      )
      lexer = Lexer.new(src)
      
      tokens = lexer.scan_all
      
      tokens.should have(3).tokens
      tokens[0].should be_comment
      tokens[1].lexeme.should == "this_is_1st_identifier"
      tokens[2].should be_finish
    end

    it "recognizes multi line comment" do
      src = %Q(
      /*
        multiple line comment
        crosses more than one lines
      */
      thisIs2ndIdentifier
      )
      lexer = Lexer.new(src)
      
      tokens = lexer.scan_all
      
      # tokens.should have(3).word_tokens
      tokens[0].should be_comment
      tokens[1].lexeme.should == "thisIs2ndIdentifier"
      tokens[2].should be_finish
    end    
  end
end