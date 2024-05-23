# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def general_guest_sign_in
    user = User.general_guest
    if Household.where(user_id: user.id).empty?
      @household = user.households.create(title: "general_guest_sample_household")
      # 中間テーブル（expense_revenue_amounts）を経由し、現在の家計の収支項目を登録できるように全収支項目分のインスタンスを作成
      # 全収支項目のidを取得するため、ExpenseRevunueItemテーブルにある全idを配列として取得
      expense_revenue_item_id_list = ExpenseRevenueItem.select("id")
      # idリストにあるidをインプットに全収支項目分のインスタンスを作成
      expense_revenue_item_id_list.each do |expense_revenue_item|
        @household.expense_revenue_amounts.create(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
      end
    end
    sign_in user
    flash[:notice] = "ゲストユーザー（一般）としてログインしました。"
    redirect_to households_path
  end

  def admin_guest_sign_in
    user = User.admin_guest
    if Household.where(user_id: user.id).empty?
      @household = user.households.create(title: "admin_guest_sample_household")
      # 中間テーブル（expense_revenue_amounts）を経由し、現在の家計の収支項目を登録できるように全収支項目分のインスタンスを作成
      # 全収支項目のidを取得するため、ExpenseRevunueItemテーブルにある全idを配列として取得
      expense_revenue_item_id_list = ExpenseRevenueItem.select("id")
      # idリストにあるidをインプットに全収支項目分のインスタンスを作成
      expense_revenue_item_id_list.each do |expense_revenue_item|
        @household.expense_revenue_amounts.create(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
      end
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
