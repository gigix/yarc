String.class_eval do
  alias_method :blank?, :empty?
  
  def digit?
    return false if blank?
    return (to_char >= '0'.to_char and to_char <= '9'.to_char)
  end
  
  def letter?
    return false if blank?
    return ((to_char >= 'a'.to_char and to_char <= 'z'.to_char) or (to_char >= 'A'.to_char and to_char <= 'Z'.to_char))
  end
  
  def to_char
    self[0]
  end
  
  def operator?
    [Tag::ADD, Tag::MINUS, Tag::MULTIPLY, Tag::DIVIDE].include?(self)
  end
end

NilClass.class_eval do
  def blank?
    true
  end
  
  def character?
    false
  end

  alias_method :digit?, :character?
  alias_method :letter?, :character?  
end