# encoding: utf-8

module ConstructorPages
  class FieldsController < ConstructorCore::ApplicationController
    include TheSortableTreeController::Rebuild
    include TheSortableTreeController::ExpandNode

    def new
      @field = Field.new.tap {|f| @template = f.template = Template.find(params[:template_id])}
    end

    def edit
      @field = Field.find(params[:id]).tap {|f| @template = f.template = Template.find(params[:template_id])}
    end

    def create
      @field = Field.new field_params
      @template = @field.template

      if @field.save
        redirect_to edit_template_path(@template), notice: t(:field_success_added, name: @field.name)
      else
        render action: :new
      end
    end

    def update
      @field = Field.find params[:id]
      @template = @field.template

      unless @field.type_value == params[:field][:type_value]
        @field.type_class.where(field_id: @field.id).each do |field|
          "constructor_pages/types/#{params[:field][:type_value]}_type".classify.constantize.new(
              field_id: @field.id, page_id: field.page_id).tap {|f|
            f.value = field.value unless [@field.type_value, params[:field][:type_value]].include?('image') and
                                  (@field.type_value == 'string' and field.value.strip == '')
            f.save; field.destroy
          }
        end
      end

      if @field.update field_params
        redirect_to edit_template_path(@template.id), notice: t(:field_success_updated, name: @field.name)
      else
        render action: :edit
      end
    end

    def destroy
      @field = Field.find(params[:id])
      name, template = @field.name, @field.template.id
      @field.destroy
      redirect_to edit_template_url(template), notice: t(:field_success_removed, name: name)
    end

    def sortable_model
      Field
    end

    def sortable_collection
      ConstructorPages::Field
    end

    private

    def field_params
      params.require(:field).permit(
          :name,
          :code_name,
          :template_id,
          :type_value
      )
    end
  end
end
