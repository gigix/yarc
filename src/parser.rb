class Parser
  def initialize(tokens)
    @tokens = tokens.reject{|token| token.comment?}
    @lookahead = next_token
    @result = Postfix.new
  end
  
  def expr
    term
    while @lookahead.operator?
      op = @lookahead.clone
      match(op)
      term
      @result << op
    end 
    @result
  end
  
  private
  def term
    raise "syntax error" unless @lookahead.number?
    @result << @lookahead
    match(@lookahead)
  end
  
  def match(token)
    raise "syntax error" unless @lookahead == token
    @lookahead = next_token
  end
  
  def next_token
    @tokens.shift
  end
end

class Postfix
  def initialize
    @tokens = []
  end
  
  def <<(token)
    @tokens << token
  end
  
  def execute
    return @tokens.first.value if @tokens.size == 1
    
    operands = []
    until((token = @tokens.shift).operator?)
      operands << token
    end
    result = eval("#{operands[0].value} #{token.tag} #{operands[1].value}")
    @tokens.unshift(NumberToken.new(result))
    execute
  end
  
  def to_s
    @tokens.map{|token| token.content}.join(" ")
  end
end