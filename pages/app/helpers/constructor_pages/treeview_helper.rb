module ConstructorPages
  module TreeviewHelper
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