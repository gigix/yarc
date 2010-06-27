class Token
  attr_reader :content
  alias_method :tag, :content
  
  def initialize(content)
    @content = content
  end
  
  def finish?
    tag == Tag::FINISH
  end
  
  def comment?
    tag == Tag::COMMENT
  end
end

class NumberToken < Token
  alias_method :value, :content
end

class WordToken < Token
  attr_reader :tag
  alias_method :lexeme, :content
  
  def initialize(tag, lexeme)
    @tag = tag
    @content = lexeme
  end
end

class OperatorToken < Token
end