# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def general_guest_sign_in
    user = User.general_guest
    if Household.where(user_id: user.id).empty?
      user.households.create(title: "general_guest_sample_household")
    end
    sign_in user
    flash[:notice] = "ゲストユーザー（一般）としてログインしました。"
    redirect_to households_path
  end

  def admin_guest_sign_in
    user = User.admin_guest
    if Household.where(user_id: user.id).empty?
      user.households.create(title: "admin_guest_sample_household")
    end
    sign_in user
    flash[:notice] = "ゲストユーザー（管理者）としてログインしました。"
    redirect_to households_path
  end

  # before_action :configure_sign_in_params, only: [:create]

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
end
