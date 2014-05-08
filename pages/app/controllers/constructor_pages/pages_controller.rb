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
      instance_variable_set('@'+_code_name, _code_name.classify.constantize.find(@page.id))

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

    def create_child
      @page = Page.create parent_id: params[:id], template_id: params[:template_id]
      render partial: 'pages/child', locals: {page: @page}
    end

    def update
      if @page.update page_params
        @page.update_fields_values params[:fields]
        if params[:remove_image]
          params[:remove_image].each do |name, trash|
            f_id = ConstructorPages::Field.where(code_name: name).where(template_id: @page.template_id).first.id
            image_for_delete = ConstructorPages::Types::ImageType.where(page_id: @page.id).where(field_id: f_id)
            puts image_for_delete
            image_for_delete.delete_all
        end
        end
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
