module ConstructorPages
  module TemplatesHelper
    include TreeviewHelper

    def for_select(roots)
      result = []
      roots.each do |r|
        r.self_and_descendants.each {|i| result.push(["#{'--'*i.level} #{i.name}", i.id])}
      end
      result
    end
  end
end