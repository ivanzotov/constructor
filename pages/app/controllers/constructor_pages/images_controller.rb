# encoding: utf-8

module ConstructorPages
  class ImagesController < ConstructorCore::AdminController
    layout 'constructor_core/application_admin'
    
    include ConstructorCore::DeviseHelper     
    before_filter :authenticate_user!    
        
    def new
      @image = Image.new
      @image.page_id = params[:page]
    end
    
    def sizes
      @image = Image.find params[:id]
    end
    
    def edit
      @image = Image.find params[:id]
      @image.page_id = params[:page]
    end
    
    def create
      @image = Image.new(params[:image])

      if @image.save
        redirect_to edit_page_path(@image.page), :notice => 'Изображение успешно добавлено.'
      else
        render :action => "new"
      end      
    end
    
    def update
      @image = Image.find params[:id]
            
      if @image.update_attributes params[:image]
        redirect_to edit_page_path(@image.page), :notice => 'Изображение успешно обновлено.'
      else
        render :action => "edit"
      end
    end
    
    def destroy
      @image = Image.find params[:id]
      @image.destroy
      
      redirect_to edit_page_path(@image.page), :notice => 'Изображение успешно удалено.'      
    end
  end
end