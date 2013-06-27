# encoding: utf-8

module ConstructorPages
  class PagesController < ApplicationController
    layout 'constructor_core/application_core', except: [:show, :search]

    movable :page

    before_filter -> {@pages = Page.all}, only: [:new, :edit]

    def index
      @pages = Page.includes(:template).all
      @pages_cache = Digest::MD5.hexdigest(@pages.map{|p| [p.name, p.lft, p.template_id]}.join)
      @template_exists = Template.count != 0
      flash[:notice] = 'Create at least one template' unless @template_exists
    end

    def new
      @page = Page.new
    end

    def new_child
      @page, @parent_id = Page.new, params[:id]
      @template_id = Page.find(@parent_id).try(:template).child.id
    end

    def show
      @page = Page.find_by_request_or_first("/#{params[:all]}")
      error_404 and return unless @page.try(:published?)
      redirect_to @page.link if @page.redirect?
      _code_name = @page.template.code_name
      instance_variable_set('@'+_code_name, @page)
      render template: "templates/#{_code_name}"
    end

    def search
      @page = Page.find_by_request_or_first("/#{params[:all]}")

      _params = request.query_parameters
      _params.each_pair {|k,v| v || (_params.delete(k); next)
        _params[k] = v.numeric? ? v.to_f : (v.to_boolean if v.boolean?)}

      @pages = Page.in(@page).by(_params).search(params[:what_search])

      @page.template.code_name.tap {|c| [c.pluralize, c.singularize].each {|name|
        instance_variable_set('@'+name, @pages)}
        render template: "templates/#{c}_search"}
    end

    def edit
      @page = Page.find(params[:id])
      @parent_id, @template_id = @page.parent.try(:id), @page.template.id
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
      @page = Page.find params[:id]

      _template_changed = @page.template.id != params[:page][:template_id].to_i

      @page.remove_fields_values if _template_changed

      if @page.update page_params
        @page.create_fields_values if _template_changed
        @page.update_fields_values params[:fields]

        redirect_to pages_path, notice: t(:page_success_updated, name: @page.name)
      else
        render :edit
      end
    end

    def destroy
      @page = Page.find(params[:id]).destroy
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
          :link
      )
    end

    def error_404
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
    end
  end
end
