module ConstructorPages
  module PagesHelper
    def templates_tree(templates)
      templates.map{|t| ["#{'--'*t.level} #{t.name}", t.id]}
    end
  end
end