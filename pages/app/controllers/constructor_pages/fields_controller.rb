# encoding: utf-8

module ConstructorPages
  class FieldsController < ConstructorCore::AdminController
    # TODO
    include ConstructorCore::DeviseHelper

    before_filter :authenticate_user!
    layout 'constructor_core/application_admin'

    def new
      @field = Field.new
      @field.template = Template.find(params[:template_id])
    end

    def edit
      @field = Field.find(params[:id])
      @field.template = Template.find(params[:template_id])
    end

    def create
      @field = Field.new params[:field]

      if @field.save
        redirect_to edit_template_path(@field.template_id), :notice => "Поле «#{@field.name}» успешно добавлено."
      else
        render :action => 'new', :template_id => @field.template_id
      end
    end

    def update
      @field = Field.find params[:id]

      if @field.update_attributes params[:field]
        redirect_to edit_template_url(@field.template.id), :notice => "Поле «#{@field.name}» успешно обновлено."
      else
        render :action => "edit"
      end
    end

    def destroy
      @field = Field.find(params[:id])
      name = @field.name
      template = @field.template.id
      @field.destroy
      redirect_to edit_template_url(template), :notice => "Поле «#{name}» успешно удалено."
    end

    def move_up
      @field = Field.find(params[:id])
      @field.move_higher
      redirect_to :back, :notice => 'Поле успешно перемещено.'
    end

    def move_down
      @field = Field.find(params[:id])
      @field.move_lower
      redirect_to :back, :notice => 'Поле успешно перемещено.'
    end
  end
end
