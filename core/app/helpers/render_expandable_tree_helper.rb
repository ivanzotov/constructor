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
            "#{ show_actions }"+
          "</div>" +
          "#{ children }" +
        "</li>"
      end

      def show_actions
        if options[:node].is_a? ConstructorPages::Page
          "<div class='b-tree__actions'>" +
              "#{h.link_to('+', '#', data: {id: options[:node].id}, class: 'b-tree__add') unless options[:node].template.leaf?}" +
              "#{h.link_to('×', '#', data: {id: options[:node].id}, class: 'b-tree__remove')}" +
          "</div>"
        end
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

        "#{ h.link_to(edit_path, class: 'b-tree__link'){ node.send(title_field).html_safe + show_template } }"
      end

      def show_template
        if options[:node].is_a? ConstructorPages::Page
          '<span class="b-tree__template">'.html_safe+options[:node].template.name+'</span>'.html_safe
        end
      end

      def children
        unless options[:children].blank?
          "<ol class='b-tree__nested-set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end