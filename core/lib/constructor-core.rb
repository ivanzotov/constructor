require 'devise'
require 'constructor_core/engine'

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

  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end