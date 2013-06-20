module ConstructorPages
  module TreeviewHelper
    def render_tree(roots, &block)
      output = '<ul>'

      roots.each do |root|
        level, last = root.level, nil

        root.self_and_descendants.each do |item|
          if item.level > level
            output += '<ul>'
          elsif item.level < level
            output += '</li>'
            output += '</ul></li>' * (level-item.level)
          elsif !item.root?
            output += '</li>'
          end

          output += '<li>'

          output += capture(item, &block)

          level, last = item.level, item
        end

        output += '</li>'
        output += '</ul></li>' * last.level
      end

      output.html_safe
    end
  end
end