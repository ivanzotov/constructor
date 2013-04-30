module ConstructorPages
  module PagesHelper
    def for_select(roots)
      result = []
      roots.each do |r|
        r.self_and_descendants.each {|i| result.push(["#{'--'*i.level} #{i.title}", i.id, {'data-full_url' => i.full_url}])}
      end
      result
    end
  end
end