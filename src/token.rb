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
  
  def recognized_token?
    false
  end
  
  alias_method :operator?, :recognized_token?
  alias_method :word?, :recognized_token?
  alias_method :number?, :recognized_token?
end

class NumberToken < Token
  alias_method :value, :content
  
  def number?
    true
  end
end

class WordToken < Token
  attr_reader :tag
  alias_method :lexeme, :content
  
  def initialize(tag, lexeme)
    @tag = tag
    @content = lexeme
  end
  
  def word?
    true
  end
end

class OperatorToken < Token
  def operator?
    true
  end
end