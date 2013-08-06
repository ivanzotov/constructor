# encoding: utf-8

module ConstructorPages
  class PagesController < ApplicationController
    layout 'constructor_core/application_core', except: [:show]

    movable :page

    before_filter -> {@pages = Page.all}, only: [:new, :edit]

    def index
      @pages = Page.includes(:template).load
      @pages_cache = Digest::MD5.hexdigest(@pages.map{|p| [p.name, p.full_url, p.in_url, p.template.lft, p.lft, p.template_id]}.join)
      @template_exists = Template.count != 0
      flash[:notice] = 'Create at least one template' unless @template_exists
    end

    def new
      @page = Page.new
    end

    def show
      _request = "/#{params[:all]}"
      @page = Page.find_by_request_or_first(_request)
      error_404 and return if @page.nil? or (!@page.published? and _request != '/')
      redirect_to(@page.redirect) && return if @page.redirect?
      _code_name = @page.template.code_name
      instance_variable_set('@'+_code_name, @page)

      respond_to do |format|
        format.html { render "#{_code_name.pluralize}/show" rescue render "templates/#{_code_name}"}
        format.json { render "#{_code_name.pluralize}/show.json", layout: false rescue render json: @page }
        format.xml  { render "#{_code_name.pluralize}/show.xml",  layout: false rescue render xml: @page }
      end
    end

    def edit
      @page = Page.find(params[:id])
      @parent_id, @template_id = @page.parent.try(:id), @page.template.id
      _code_name = @page.template.code_name.pluralize
      render "#{_code_name}/edit" rescue render :edit
    end

    def create
      @page = Page.new page_params

      if @page.save
        @page.touch_branch
        redirect_to pages_path, notice: t(:page_success_added, name: @page.name)
      else
        if @page.template_id
          _template = Template.find(@page.template_id)
          _code_name = _template.code_name.pluralize if _template
          render "#{_code_name}/new" rescue render :new
        else
          render :new
        end
      end
    end

    def update
      @page = Page.find params[:id]

      _template_changed = @page.template.id != params[:page][:template_id].to_i

      @page.remove_fields_values if _template_changed

      if @page.update page_params
        @page.create_fields_values if _template_changed
        @page.update_fields_values params[:fields]
        @page.touch_branch

        redirect_to pages_path, notice: t(:page_success_updated, name: @page.name)
      else
        render "#{@page.template.code_name.pluralize}/new" rescue render :edit
      end
    end

    def destroy
      @page = Page.find(params[:id])
      @page.touch_branch
      @page.destroy
      redirect_to pages_path, notice: t(:page_success_removed, name: @page.name)
    end

    private

    def page_params
      params.require(:page).permit(
          :active,
          :name,
          :url,
          :title,
          :keywords,
          :description,
          :auto_url,
          :parent_id,
          :template_id,
          :in_nav,
          :in_map,
          :in_menu,
          :in_url,
          :redirect
      )
    end

    def error_404
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
    end
  end
end
