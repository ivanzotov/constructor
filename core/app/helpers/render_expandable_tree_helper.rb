module RenderExpandableTreeHelper
  module Render 
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]

        "<li class='b-tree__li' data-node-id='#{ node.id }'>" +
          "<div class='b-tree__item'>" +
            "<i class='fa fa-bars b-tree__handle'></i>" +
            "#{ show_plus }" +
            "#{ show_link }" +
          "</div>" +
          "#{ children }" +
        "</li>"
      end

      def show_plus
        unless options[:node].leaf?
          "<i class='fa fa-plus-square-o b-tree__expand b-tree__plus'></i>"
        end
      end

      def show_link
        node = options[:node]
        ns   = options[:namespace]
        title_field = options[:title]
        edit_path = h.url_for(controller: options[:klass].pluralize, action: :edit, id: node)

        "#{ h.link_to(node.send(title_field), edit_path, class: 'b-tree__link') }"
      end

      def children
        unless options[:children].blank?
          "<ol class='b-tree__nested-set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end