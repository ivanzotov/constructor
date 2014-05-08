module ConstructorPages
  class FieldsController < ConstructorCore::ApplicationController
    include TheSortableTreeController::Rebuild
    include TheSortableTreeController::ExpandNode

    before_action :set_field, only: [:edit, :update, :destroy]

    def new
      @field = Field.new template_id: params[:template_id]
    end

    def edit
    end

    def create
      @field = Field.new field_params

      if @field.save
        redirect_to edit_template_path(@field.template), notice: t(:field_success_added, name: @field.name)
      else
        render :new
      end
    end

    def update
      unless @field.type_value == params[:field][:type_value]
        @field.type_class.where(field_id: @field.id).each do |field|
          _field = "constructor_pages/types/#{params[:field][:type_value]}_type".classify.constantize.new(field_id: @field.id, page_id: field.page_id)

          unless ([@field.type_value, params[:field][:type_value]].include?('image') || [@field.type_value, params[:field][:type_value]].include?('file')) \
            && (@field.type_value == 'string' && field.value.strip == '')
            _field.value = field.value
          end

          _field.save
          field.destroy
        end
      end

      if @field.update field_params
        redirect_to edit_template_path(@field.template.id), notice: t(:field_success_updated, name: @field.name)
      else
        render :edit
      end
    end

    def destroy
      @field.destroy
      redirect_to edit_template_url(@field.template), notice: t(:field_success_removed, name: @field.name)
    end

    def sortable_model; Field end
    def sortable_collection; ConstructorPages::Field end

    private

    def set_field
      @field = Field.find params[:id]
    end

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
