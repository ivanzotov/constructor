module ConstructorPages
  module Types
    # Float type. Render small text field.
    class FloatType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page, touch: true
    end
  end
end