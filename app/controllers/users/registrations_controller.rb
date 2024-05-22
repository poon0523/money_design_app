# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create] →application_controllerに設定済み
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer. →application_controllerに設定済み
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer. →application_controllerに設定済み
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # By default we want to require a password checks on update.
  # You can overwrite this method in your own RegistrationsController.
  # 継承元（Devise::RegistrationsController）よりupdate_resourceメソッドがdef updateにて呼び出されていることを確認済み
  # 「現在のパスワードの入力なしでレコードを更新する」というメソッドがdeviseにないため、update_without_current_passwordメソッドをモデルで独自に定義済み
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

   # deviseのビルドインメソッドを通して、アカウント作成後のリダイレクト先を指定
  def after_sign_up_path_for(resource)
    # 子どもがいる場合は「子ども情報登録」に遷移する
    if current_user.children_number > 0
      flash[:notice] = 'アカウントを作成しました。続けて、お子様の情報をご登録ください'
      new_child_path
    else
      flash[:notice] = 'アカウントを作成しました'
      households_path
    end
  end

   # deviseのビルドインメソッドを通して、アカウント編集後のリダイレクト先を指定
  def after_update_path_for(resource)
    # 子どもがいる場合は「子ども情報登録」に遷移する
    if current_user.children_number > 0  && current_user.children.all.present?
      edit_child_path(current_user.children.first)
    elsif current_user.children_number > 0  && current_user.children.all.empty?
      flash[:notice] = 'アカウントを更新しました。お子様の情報が未登録のためご登録ください'
      new_child_path
    else
      flash[:notice] = 'アカウントを更新しました'
      households_path
    end
  end    

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
end
