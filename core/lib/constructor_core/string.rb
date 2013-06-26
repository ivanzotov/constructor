class String
  def numeric?
    return true if self =~ /^\d+$/
    true if Float(self) rescue false
  end

  def boolean?
    if self =~ (/(true|yes)$/i) || self =~ (/(false|no)$/i)
      return true
    else
      return false
    end
  end

  def to_boolean
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def accusative
    self.sub(/а$/, 'у').sub(/я$/, 'ю')
  end

end