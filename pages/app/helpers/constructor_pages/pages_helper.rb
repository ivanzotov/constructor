module ConstructorPages
  module PagesHelper
    def for_select(roots)
      result = []
      roots.each do |r|
        r.self_and_descendants.each {|i| result.push(["#{'--'*i.level} #{i.name}", i.id, {'data-full_url' => i.full_url}])}
      end
      result
    end

    def templates
      Template.all.map{|t| ["#{'--'*t.level} #{t.name}", t.id]}
    end
  end
end