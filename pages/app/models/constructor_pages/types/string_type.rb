module ConstructorPages
  module Types
    # String type. Render large text field.
    class StringType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page, touch: true
    end
  end
end