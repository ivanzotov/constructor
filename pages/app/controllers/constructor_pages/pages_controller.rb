# encoding: utf-8

module ConstructorPages
  class PagesController < ConstructorCore::AdminController
    # TODO
    include ConstructorCore::DeviseHelper

    caches_page :show
    
    before_filter :authenticate_user!, :except => [:show, :search, :sitemap]
    before_filter {@roots = Page.roots}
    layout 'constructor_core/application_admin', :except => [:show, :search, :sitemap]
    before_filter :cache, :only => [:create, :update, :destroy, :move_up, :move_down]
        
    # TODO
    def index
      @user_signed_in = user_signed_in?
    end

    def sitemap
      @pages = Page.all
      @title = "Карта сайта"
    end

    def new
      @page = Page.new
      @template = Template.first.id
      @multipart = false

      if params[:page]
        @parent = Page.find(params[:page])        
        @page.parent_id = @parent.id

        if @parent.template.child_id.nil? and !@parent.template.leaf?
          @template = @parent.template.descendants.first.id
        else
          @template = @parent.template.child_id
        end
      end
    end
    
    def show
      if params[:all].nil?
        @page = Page.first
      else
        @request = '/' + params[:all]
        @page = Page.where(:full_url => @request).first
      end

      if @page.nil? or !@page.active
        render :action => "error_404", :layout => false
        return
      end

      if @page.url != @page.link and !@page.link.empty?
        redirect_to @page.link
      end

      instance_variable_set('@'+@page.template.code_name.to_s, @page)

      @children_of_current_root = Page.children_of(@page.root)
      @children_of_current_page = Page.children_of(@page)

      respond_to do |format|
        format.html { render :template => "html_templates/#{@page.template.code_name}" }
        format.json {
          _template = render_to_string :partial => "json_templates/#{@page.template.code_name}.json.erb", :layout => false, :locals => {@page.template.code_name.to_sym => @page, :page => @page}
          _js = render_to_string :partial => "js_partials/#{@page.template.code_name}.js"

          render :json => @page, :template => _template.gsub(/\n/, '\\\\n'), :js => _js
        }
      end
    end

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

      @children_of_current_root = Page.children_of(@page.root)
      @children_of_current_page = Page.children_of(@page)

      render :template => "templates/#{template.code_name}_search"
    end
    
    def edit
      @page = Page.find(params[:id])
      @page.template ||= Template.first
      @template = @page.template.id

      @multipart = @page.template.fields.map{|f| f.type_value == "image"}.include?(true) ? true : false
    end

    def create              
      @page = Page.new params[:page]

      if @page.save
        redirect_to pages_url, :notice => "Страница «#{@page.name}» успешно добавлена."
      else
        render :action => "new"
      end
    end

    def update   
      @page = Page.find params[:id]

      @page.template.fields.each do |field|
        f = "constructor_pages/types/#{field.type_value}_type".classify.constantize.where(
            :field_id => field.id,
            :page_id => @page.id).first_or_create

        if params[:fields]
          f.value = 0 if field.type_value == 'boolean'

          if params[:fields][field.type_value]
            if field.type_value == "date"
              value = params[:fields][field.type_value][field.id.to_s]
              f.value = Date.new(value["date(1i)"].to_i, value["date(2i)"].to_i, value["date(3i)"].to_i).to_s
            else
              f.value = params[:fields][field.type_value][field.id.to_s]
            end
          end

          f.save
        end
      end

      if @page.update_attributes params[:page]
        redirect_to pages_url, :notice => "Страница «#{@page.name}» успешно обновлена."
      else
        render :action => "edit"
      end
    end

    def destroy
      @page = Page.find(params[:id])
      title = @page.name
      @page.destroy
      redirect_to pages_url, :notice => "Страница «#{title}» успешно удалена."
    end

    def move_up
      from = Page.find(params[:id])
      ls = from.left_sibling
      if not ls.nil? and from.move_possible?(ls)
        from.move_left
      end

      redirect_to :back
    end

    def move_down
      from = Page.find(params[:id])
      rs = from.right_sibling
      if not rs.nil? and from.move_possible?(rs)
        from.move_right
      end

      redirect_to :back
    end
    
    private
        
    def cache
      expire_page :action => :show
      cache_dir = ActionController::Base.page_cache_directory
      unless cache_dir == Rails.root.to_s+"/public"
        FileUtils.rm_r(Dir.glob(cache_dir+"/*")) rescue Errno::ENOENT
      end
    end
  end  
end
