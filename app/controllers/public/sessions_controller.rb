# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :user_state, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_in_path_for(resource)
    user_path(current_user.id)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

   private

  # 退会済みユーザーがログインしようとしたときの処理
  def user_state
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    if user.is_active
      return unless user.valid_password?(params[:user][:password])
    else
      flash[:danger] = 'このアカウントは退会済みです。別のアカウントでログインまたは新規登録をお願いします。'
      redirect_to new_user_session_path
    end
  end

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
  end

end
