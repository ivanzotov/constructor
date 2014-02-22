module ConstructorPages
  class TemplatesController < ConstructorCore::ApplicationController
    include TheSortableTreeController::Rebuild
    include TheSortableTreeController::ExpandNode

    before_action :set_template, only: [:edit, :update, :destroy]

    def index
      @templates = Template.roots
    end

    def new
      @template = Template.new
    end

    def edit
    end

    def create
      @template = Template.new template_params

      if @template.save
        redirect_to templates_url, notice: t(:template_success_added, name: @template.name)
      else
        render :new
      end
    end

    def update
      if @template.update template_params
        redirect_to templates_url, notice: t(:template_success_updated, name: @template.name)
      else
        render :edit
      end
    end

    def destroy
      @template.destroy
      redirect_to templates_url, notice: t(:template_success_removed, name: @template.name)
    end

    def sortable_model; Template end

    private

    def set_template
      @template = Template.find params[:id]
    end

    def template_params
      params.require(:template).permit(
          :name,
          :code_name,
          :child_id
      )
    end
  end
end
