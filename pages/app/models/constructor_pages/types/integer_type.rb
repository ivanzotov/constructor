module ConstructorPages
  module Types
    # Integer type. Render small text field.
    class IntegerType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page, touch: true
    end
  end
end