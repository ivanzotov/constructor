module ConstructorPages
  module Types
    # Image type. Render select file field.
    class FileType < ActiveRecord::Base
      extend Dragonfly::Model

      belongs_to :field
      belongs_to :page, touch: true

      dragonfly_accessor :value

      validates :value, presence: true
      # Max size is 5 MB
      validates_size_of :value, maximum: 5.megabytes, message: :incorrect_size
    end
  end
end