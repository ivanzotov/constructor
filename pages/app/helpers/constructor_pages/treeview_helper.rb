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

    def arrow_buttons_for(item)
      output = "<div class='btn-group'>"

      {down: :right, up: :left}.each_pair do |a, b|
        sibling = item.send(b.to_s+'_sibling')
        if sibling and item.move_possible?(sibling)
          output += link_to("<i class='icon-arrow-#{a}'></i>".html_safe, "/admin/#{item.class.to_s.demodulize.downcase.pluralize}/move/#{a}/#{item.id}", class: 'btn btn-mini')
        end
      end

      output += "</div>"
      output.html_safe
    end
  end
end