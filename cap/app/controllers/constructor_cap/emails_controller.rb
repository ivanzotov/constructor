# encoding: utf-8

module ConstructorCap
  class EmailsController < ConstructorCore::AdminController
    # TODO
    include ConstructorAuth::DeviseHelper   
    
    before_filter :authenticate_user!, :except => [:show, :add]
            
    layout 'constructor_core/application_admin', :except => [:show]    

    # TODO
    def index
      @user_signed_in = user_signed_in?
      @emails = Email.all
    end

    def new
      @email = Email.new
    end
    
    def show
      @email = Email.new  
      render :layout => false
    end
    
    def edit
      @email = Email.find(params[:id])
    end

    def create
      @email = Email.new(params[:email])

      if @email.save
        redirect_to emails_path, :notice => 'Email успешно добавлен.'
      else
        render :action => "new"
      end
    end
    
    def add
      @email = Email.new(params[:email])

      if @email.save
        redirect_to root_path, :notice => "Спасибо! Мы сообщим вам об открытии сайта."
      else
        render :action => "show", :layout => false
      end      
    end
    
    def update
      @email = Email.find(params[:id])

      if @email.update_attributes(params[:email])
        redirect_to emails_url, :notice => 'Email успешно обновлен.'
      else
        render :action => "edit"
      end
    end

    def destroy
      Email.find(params[:id]).destroy
      redirect_to emails_url, :notice => 'Email успешно удален.'
    end
    
    def delete_all
      Email.delete_all
      redirect_to emails_url
    end
  end  
end
