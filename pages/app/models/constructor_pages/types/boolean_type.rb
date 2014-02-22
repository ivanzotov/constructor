module ConstructorPages
  module Types
    # Boolean type. Render as checkbox.
    class BooleanType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page, touch: true
    end
  end
end