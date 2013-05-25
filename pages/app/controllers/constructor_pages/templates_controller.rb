# encoding: utf-8

module ConstructorPages
  class TemplatesController < ConstructorCore::AdminController
    # TODO
    include ConstructorCore::DeviseHelper

    before_filter :authenticate_user!
    before_filter {@roots = Template.roots}
    layout 'constructor_core/application_admin'

    def new
      @template = Template.new

      if params[:template]
        @parent = Template.find(params[:template])
        @template.parent_id = @parent.id
      end
    end

    def edit
      @template = Template.find(params[:id])
    end

    def create
      @template = Template.new params[:template]

      if @template.save
        redirect_to templates_url, :notice => "Шаблон «#{@template.name}» успешно добавлен."
      else
        render :action => "new"
      end
    end

    def update
      @template = Template.find params[:id]

      if @template.update_attributes params[:template]
        redirect_to templates_url, :notice => "Шаблон «#{@template.name}» успешно обновлен."
      else
        render :action => "edit"
      end
    end

    def destroy
      @template = Template.find(params[:id])
      name = @template.name
      @template.destroy
      redirect_to templates_url, :notice => "Шаблон «#{name}» успешно удален."
    end

    def move_up
      from = Template.find(params[:id])
      ls = from.left_sibling
      if not ls.nil? and from.move_possible?(ls)
        from.move_left
      end

      redirect_to :back
    end

    def move_down
      from = Template.find(params[:id])
      rs = from.right_sibling
      if not rs.nil? and from.move_possible?(rs)
        from.move_right
      end

      redirect_to :back
    end
  end
end
