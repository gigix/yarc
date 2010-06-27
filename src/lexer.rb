class Tag
  # keywords
  IF = :if
  TRUE = :true
  FALSE = :false
  
  # math operators
  ADD = '+'
  MINUS = '-'
  MULTIPLY = '*'
  DIVIDE = '/'

  # others
  FINISH = :finish
  COMMENT = :comment
  ID = :identifier  
end

class Lexer
  def initialize(src)
    @input = StringIO.new(src)
    @peek = ' '
    
    @word_tokens = {}
    {
      # default keywords
      'if' => Tag::IF,
      'true' => Tag::TRUE,
      'false' => Tag::FALSE,
    }.each{|key, value| @word_tokens[key] = WordToken.new(value, key)}
  end
  
  def scan_all
    tokens = []
    begin
      token = scan
      tokens << token
    end until token.finish?
    tokens
  end
  
  def scan
    skip_whitespaces
    
    return Token.new(Tag::FINISH) if @peek.nil?
    return recognize_comment if @peek == '/'
    return recognize_operator if @peek.operator?
    return recognize_number if @peek.digit?
    return recognize_word if @peek.letter?
    
    token = Token.new(@peek)
    @peek = ' '
    return token
  end
  
  private
  def recognize_operator
    token = OperatorToken.new(@peek)
    @peek = ' '
    return token
  end
  
  def recognize_comment
    lookahead = next_char
    
    if @peek + lookahead == '//'
      @peek = next_char until(@peek == "\n")
      return Token.new(Tag::COMMENT)
    end
    
    if @peek + lookahead == '/*'
      begin 
        @peek = lookahead
        lookahead = next_char
      end until(@peek + lookahead == '*/')
      @peek = ' '
      return Token.new(Tag::COMMENT)
    end
    
    @peek = lookahead
    return OperatorToken.new(Tag::DIVIDE)
  end
  
  def recognize_number
    value_str = ''
    begin
      value_str << @peek
      @peek = next_char
    end while(@peek.digit? or @peek == '.')
    
    value = value_str.include?('.') ? value_str.to_f : value_str.to_i
    NumberToken.new(value)
  end
  
  def recognize_word
    word = ""
    begin
      word << @peek
      @peek = next_char
    end while(valid_char_in_word?(@peek))
    
    if(token = @word_tokens[word])
      return token
    end
    
    token = WordToken.new(Tag::ID, word)
    @word_tokens[word] = token
    return token
  end
  
  def skip_whitespaces
    while(@peek and @peek.strip.empty?)
      @peek = next_char
    end
  end
  
  def next_char
    @input.read(1)
  end
    
  def valid_char_in_word?(str)
    str.digit? or str.letter? or str == "_"
  end
end