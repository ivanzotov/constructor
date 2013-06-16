# encoding: utf-8

module ConstructorPages
  class TemplatesController < ConstructorCore::ApplicationController
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

    def move_up; move_to :up end

    def move_down; move_to :down end

    private

    def move_to(to)
      from = Template.find(params[:id])
      to_sibling = to == :up ? from.left_sibling : from.right_sibling

      if not to_sibling.nil? and from.move_possible?(to_sibling)
        to == :up ? from.move_left : from.move_right
      end

      redirect_to :back
    end
  end
end
