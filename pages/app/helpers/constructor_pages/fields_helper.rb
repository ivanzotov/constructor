# encoding: utf-8

module ConstructorPages
  module FieldsHelper
    def types_value
      [
          ["Строка", "string"],
          ["Целое число", "integer"],
          ["Дробное число", "float"],
          ["Булево", "boolean"],
          ["Дата", "date"],
          ["Текст", "text"],
          ["HTML", "html"],
          ["Изображение", "image"],
          ["Адрес", "address"]
      ]
    end
  end
end