# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :reject_inactive_customer, only: [:create]

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

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    root_path
    # user_path(current_user.id)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

 private

  # ログイン時、ユーザーが有効か退会済みかで処理を分けている
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
end
