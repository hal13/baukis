# -*- coding: utf-8 -*-
class Admin::SessionsController < Admin::Base
  def new
    if current_administrator
      redirect_to :admin_root
    else
      @form = Admin::LoginForm.new
      render action: 'new'
    end
  end

  def create
    @form = Admin::LoginForm.new(params[:admin_login_form])
    if @form.email.present?
      administrator = Administrator.find_by(email_for_index: @form.email.downcase)
    end
    
    @authenticate = Admin::Authenticator.new(administrator)
    if @authenticate.authenticate(@form.password)
      session[:administrator_id] = administrator.id
      flash.notice = 'ログインしました。'
      redirect_to :admin_root
    else
      flash.now.alert = @authenticate.authentication_alert(@form.password)
      render :new
    end
  end

  def destroy
    session.delete(:administrator_id)
    flash.notice = 'ログアウトしました。'
    redirect_to :admin_root
  end
end
