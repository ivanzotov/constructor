# encoding: utf-8

module ConstructorPages
  class ApplicationController < ConstructorCore::ApplicationController
    def self.movable(what)
      %w{up down}.each {|m| define_method "move_#{m}" do move_to what, params[:id], m.to_sym end}
    end

    def move_to(what, id, to)
      from = ('constructor_pages/'+what.to_s).classify.constantize.find(id)
      to_sibling = to == :up ? from.left_sibling : from.right_sibling

      if not to_sibling.nil? and from.move_possible?(to_sibling)
        to == :up ? from.move_left : from.move_right
      end

      redirect_to :back
    end
  end
end
