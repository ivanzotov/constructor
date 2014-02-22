# encoding: utf-8

module ConstructorPages
  class TemplatesController < ConstructorCore::ApplicationController
    include TheSortableTreeController::Rebuild
    include TheSortableTreeController::ExpandNode

    def index
      @templates = Template.roots
      @templates_cache = Digest::MD5.hexdigest(@templates.map{|t| [t.id, t.name, t.lft]}.join)
    end

    def new
      @template = Template.new
    end

    def edit
      @template = Template.find(params[:id])
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
      @template = Template.find params[:id]

      if @template.update template_params
        redirect_to templates_url, notice: t(:template_success_updated, name: @template.name)
      else
        render :edit
      end
    end

    def destroy
      @template = Template.find(params[:id])

      if @template.pages.count == 0
        name = @template.name
        @template.destroy
        redirect_to templates_url, notice: t(:template_success_removed, name: name)
      else
        redirect_to :back, alert: t(:template_error_delete_pages)
      end
    end

    def sortable_model
      Template
    end

    private

    def template_params
      params.require(:template).permit(
          :name,
          :code_name,
          :child_id
      )
    end
  end
end
