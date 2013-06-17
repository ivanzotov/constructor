module ConstructorPages
  module MoveHelper
    def move_to(what, to)
      from = ('constructor_pages/'+what.to_s).classify.constantize.find(params[:id])
      to_sibling = to == :up ? from.left_sibling : from.right_sibling

      if not to_sibling.nil? and from.move_possible?(to_sibling)
        to == :up ? from.move_left : from.move_right
      end

      redirect_to :back
    end
  end
end