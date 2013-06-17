# encoding: utf-8

module ConstructorPages
  class PagesController < ConstructorCore::ApplicationController
    before_filter :authenticate_user!, :except => [:show, :search, :sitemap]

    caches_page :show

    before_filter {@roots = Page.roots}
    layout 'constructor_core/application_admin', :except => [:show, :search, :sitemap]
    before_filter :cache, :only => [:create, :update, :destroy, :move_up, :move_down]

    def new
      @page, @template_id, @multipart = Page.new, Template.first.id, false

      if params[:page]
        _parent = @page.parent = Page.find(params[:page])

        if _parent
          if _parent.template.child_id.nil? and !_parent.template.leaf?
            @template_id = _parent.template.children.first.id
          else
            @template_id = _parent.template.child_id
          end
        end
      end
    end

    def show
      @page = params[:all].nil? ? Page.first : Page.find_by_full_url('/' + params[:all])

      if @page.nil? or !@page.active
        render action: 'error_404', layout: false
        return
      end

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
      @page = Page.new params[:page]

      if @page.save
        redirect_to pages.pages_url, notice: t(:page_success_added, name: @page.name)
      else
        render action: :new
      end
    end

    def update
      @page = Page.find params[:id]

      if @page.template.id != params[:page][:template_id].to_i
        @page.fields.each {|f| f.remove_values_for @page}
      end

      if @page.update_attributes params[:page]
        @page.fields.each {|f| f.update_value(@page, params[:fields])}

        redirect_to pages.pages_url, notice: t(:page_success_updated, name: @page.name)
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

    %w{up down}.each {|m| define_method "move_#{m}" do move_to m.to_sym end}

    private

    def move_to(to)
      from = Page.find(params[:id])
      to_sibling = to == :up ? from.left_sibling : from.right_sibling

      if not to_sibling.nil? and from.move_possible?(to_sibling)
        to == :up ? from.move_left : from.move_right
      end

      redirect_to :back
    end

    def cache
      expire_page :action => :show
      cache_dir = ActionController::Base.page_cache_directory
      unless cache_dir == Rails.root.to_s+"/public"
        FileUtils.rm_r(Dir.glob(cache_dir+"/*")) rescue Errno::ENOENT
      end
    end
  end
end
