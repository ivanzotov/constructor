# encoding: utf-8

module ConstructorPages
  class PagesController < ApplicationController
    movable :page

    before_filter {@roots, @template_exists = Page.roots, Template.count > 0}

    def index
      flash.notice = 'Create at least one template' unless @template_exists
    end

    def new
      redirect_to pages_path and return unless @template_exists
      @page, @template_id, @multipart = Page.new, Template.first.id, false

      if params[:page] and (@page.parent = Page.find(params[:page]))
        @template_id = @page.parent.template.child.id
      end
    end

    def show
      @page = Page.find_by_request_or_first("/#{params[:all]}")

      error_404 and return if @page.nil? or !@page.active?

      redirect_to @page.link if @page.redirect?

      _code_name = @page.template.code_name.to_s

      instance_variable_set('@'+_code_name, @page)

      respond_to do |format|
        format.html { render template: "html_templates/#{_code_name}" }
        format.json {
          _template = render_to_string partial: "json_templates/#{_code_name}.json.erb", layout: false, locals: {_code_name.to_sym => @page, page: @page}
          _js = render_to_string partial: "js_partials/#{_code_name}.js"

          render json: @page, self_and_ancestors: @page.self_and_ancestors.map(&:id), template: _template.gsub(/\n/, '\\\\n'), js: _js
        }
      end
    end

=begin
    def search
      if params[:all].nil?
        @page = Page.first
      else
        @request = '/' + params[:all]
        @page = Page.where(:full_url => @request).first
      end

      instance_variable_set('@'+@page.template.code_name.to_s, @page)

      what_search = params[:what_search]
      params_selection = request.query_parameters

      template = Template.find_by_code_name(what_search.singularize)

      if template.nil?
        render :action => "error_404", :layout => false
        return
      end

      @pages = @page.descendants.where(:template_id => template.id)

      params_selection.each_pair do |code_name, value|
        if value.numeric?
          value = value.to_f
        elsif value.boolean?
          value = value.to_bool
        end

        @pages = @pages.select do |page|
          if code_name == 'name'
            page.name == value
          else
            page.field(code_name) == value
          end
        end
      end

      instance_variable_set('@'+template.code_name.pluralize, @pages)

      render :template => "templates/#{template.code_name}_search"
    end
=end

    def edit
      @page = Page.find(params[:id])
      @page.template ||= Template.first
      @template_id = @page.template.id

      @multipart = @page.fields.map{|f| f.type_value == 'image'}.include?(true) ? true : false
    end

    def create
      @page = Page.new page_params

      if @page.save
        redirect_to pages.pages_url, notice: t(:page_success_added, name: @page.name)
      else
        render action: :new
      end
    end

    def update
      @page = Page.find params[:id]

      _template_changed = @page.template.id != params[:page][:template_id].to_i

      @page.remove_fields_values if _template_changed

      if @page.update page_params
        @page.create_fields_values if _template_changed
        @page.update_fields_values params[:fields]

        redirect_to pages_url, notice: t(:page_success_updated, name: @page.name)
      else
        render action: :edit
      end
    end

    def destroy
      @page = Page.find(params[:id])
      _name = @page.name
      @page.destroy
      redirect_to pages_url, notice: t(:page_success_removed, name: _name)
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
      render file: "#{Rails.root}/public/404", layout: false, status: 404
    end
  end
end
