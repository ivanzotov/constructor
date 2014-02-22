module ConstructorPages
  module Types
    # Text type. Render textarea.
    class TextType < ActiveRecord::Base
      belongs_to :field
      belongs_to :page, touch: true

      before_save -> { self.value ||= '' }
    end
  end
end