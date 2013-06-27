module ConstructorPages
  module PagesHelper
    include TreeviewHelper

    def for_select(items)
      result = []
      items.each do |i|
        result.push(["#{'--'*i.level} #{i.name}", i.id, {'data-full_url' => i.full_url}])
      end
      result
    end

    def templates
      Template.all.map{|t| ["#{'--'*t.level} #{t.name}", t.id]}
    end

    def image_tag_with_at2x(name_at_1x, options={})
      name_at_2x = name_at_1x.gsub(%r{\.\w+$}, '@2x\0')
      image_tag(name_at_1x, options.merge("data-at2x" => asset_path(name_at_2x)))
    end
  end
end