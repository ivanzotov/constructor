module ConstructorPages
  module ForSelect
    def for_select(items, full_url = false)
      result = []
      items && items.each do |i|
        arr = ["#{'--'*i.level} #{i.name}", i.id]
        arr << {'data-full_url' => i.full_url} if full_url
        result.push(arr)
      end
      result
    end
  end
end