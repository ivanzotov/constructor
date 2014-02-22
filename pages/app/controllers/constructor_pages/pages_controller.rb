module ConstructorPages
  class PagesController < ConstructorCore::ApplicationController
    include TheSortableTreeController::Rebuild
    include TheSortableTreeController::ExpandNode

    skip_before_filter :authenticate_user!, only: [:show]

    before_action :set_page, only: [:edit, :update, :destroy]

    def index
      @pages = Page.roots
    end

    def new
      @page, @templates = Page.new, Template.all

      if @templates.blank?
        redirect_to pages_path, notice: t(:create_template_first)
      end
    end

    def show
      @page = Page.find_by_path request.path

      redirect_to(@page.redirect) && return if @page.redirect?

      _code_name = @page.template.code_name
      instance_variable_set('@'+_code_name, @page)

      render "templates/#{_code_name}", layout: 'application'
    end

    def edit
    end

    def create
      @page = Page.new page_params

      if @page.save
        redirect_to pages_path, notice: t(:page_success_added, name: @page.name)
      else
        render :new
      end
    end

    def update
      if @page.update page_params
        @page.update_fields_values params[:fields]

        redirect_to pages_path, notice: t(:page_success_updated, name: @page.name)
      else
        render :edit
      end
    end

    def destroy
      @page.destroy
      redirect_to pages_path, notice: t(:page_success_removed, name: @page.name)
    end

    def sortable_model; Page end

    private

    def set_page
      @page = Page.find params[:id]
    end

    def page_params
      params.require(:page).permit(
          :active,
          :name,
          :url,
          :title,
          :keywords,
          :description,
          :auto_url,
          :template_id,
          :in_nav,
          :in_map,
          :in_menu,
          :in_url,
          :redirect
      )
    end
  end
end
