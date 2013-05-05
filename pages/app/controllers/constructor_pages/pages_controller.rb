# encoding: utf-8

module ConstructorPages
  class PagesController < ConstructorCore::AdminController
    # TODO
    include ConstructorCore::DeviseHelper 
    
    caches_page :show
    
    before_filter :authenticate_user!, :except => [:show, :sitemap]
    before_filter :template_vars, :only => [:show]
    before_filter {@roots = Page.roots}
    layout 'constructor_core/application_admin', :except => [:show, :sitemap]
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
      if params[:page]
        @parent = Page.find(params[:page])        
        @page.parent_id = @parent.id
      end
    end
    
    def show
      if params[:all].nil?
        @page = Page.first
      else
        @page = Page.where(:full_url => '/' + (params[:all])).first
      end
      
      if @page.nil? or !@page.active
        render :action => "error_404", :layout => false
        return
      end

      @seo_title = @page.seo_title.empty? ? @page.title : @page.seo_title
      @title = @page.title
      @description = @page.description
      @keywords = @page.keywords      

      if @page.url != @page.link and !@page.link.empty?
        redirect_to @page.link
      end
    end
    
    def edit
      @page = Page.find(params[:id])
    end

    def create              
      @page = Page.new params[:page] 
       
      if @page.save
        redirect_to pages_url, :notice => "Страница «#{@page.title}» успешно добавлена."
      else
        render :action => "new"
      end
    end

    def update   
      if params[:field]
        params[:field].each_pair do |id, hash|
          field = ("constructor_pages/#{hash[:type]}").classify.constantize.find id
          field.value = hash[:value]
          field.save
        end
      end
      
      @page = Page.find params[:id]     
      
      if @page.update_attributes params[:page]        
        redirect_to pages_url, :notice => "Страница «#{@page.title}» успешно обновлена."
      else
        render :action => "edit"
      end
    end

    def destroy
      @page = Page.find(params[:id])
      title = @page.title           
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
    
    def template_vars
      @request = request.path.sub('//', '/')
      @current_page = Page.where(:full_url => @request).first
      
      unless @current_page.nil?
        @children_of_current_root = Page.children_of(@current_page.root)           
        @children_of_current_page = Page.children_of(@current_page)  
      end
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
