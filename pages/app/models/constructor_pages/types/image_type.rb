module ConstructorPages
  module Types
    # Image type. Render select file field.
    class ImageType < ActiveRecord::Base
      extend Dragonfly::Model

      belongs_to :field
      belongs_to :page, touch: true

      dragonfly_accessor :value

      validates :value, presence: true
      # Max size is 5 MB
      validates_size_of :value, maximum: 15.megabytes, message: :incorrect_size
      # Accept only jpeg, png, gif
      validates_property :mime_type, of: :value, in: %w(image/jpeg image/png image/gif), message: :incorrect_format
    end
  end
end