module ConstructorPages
  module PagesHelper
    def for_select(roots)
      result = []
      roots.each do |r|
        r.self_and_descendants.each {|i| result.push(["#{'--'*i.level} #{i.field('name')}", i.id, {'data-full_url' => i.field('address')}])}
      end
      result
    end

    def templates
      Template.all.map{|t| ["#{'--'*t.level} #{t.name}", t.id]}
    end
  end
end