module ConstructorPages
  module FieldsHelper
    def types_value
      [
          [t(:string), "string"],
          [t(:integer), "integer"],
          [t(:float), "float"],
          [t(:boolean), "boolean"],
          [t(:date), "date"],
          [t(:text), "text"],
          [t(:html), "html"],
          [t(:image), "image"],
          [t(:file), "file"]
      ]
    end
  end
end