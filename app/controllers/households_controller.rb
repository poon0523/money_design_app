class HouseholdsController < ApplicationController
  # ログイン成功の場合のみhouseholds_controllerの全アクション実行可能とする
  before_action :authenticate_user!
  before_action :correct_user, only: %i[ show edit ]
  before_action :set_household, only: %i[ show edit update destroy ]


  def index
    # ログインユーザーが持つすべての家計情報をインスタンス変数に格納
    @households = current_user.households.all

    if params[:child_create] == "true" 
      flash[:notice] = "アカウントと子どもの情報を登録しました"
      render :index
    elsif params[:child_update] == "true"
      flash[:notice] = "アカウントと子どもの情報を更新しました"
    else
    end

  end

  def show
    binding.pry

    # 詳細画面で表示する必要がある情報を以下(1)~(5)の通りインスタンス変数に格納
    # (1)収支項目のカテゴリ順に並べた（家計と収支項目の）中間テーブルを家計の詳細情報としてインスタンス変数に格納
    @household_detail = Household.order_expense_revenue_amounts(@household)

    # (2)収支比率の計算の分母として収入項目の金額をインスタンス変数に格納
    @revenue = @household.expense_revenue_amounts.find_by(expense_revenue_item_id: 1).amount

    # (3)ログインユーザーの配偶者有無、子ども人数に一致する家計基準の値をインスタンス変数に格納
    @match_household_standard = HouseholdStandard.all.where(marital_status: current_user.marital_status, children_number: current_user.children_number)

    # (4)目標となる家計情報の登録のために新規のhouseholdインスタンスを生成し、インスタンス変数に格納
    @ideal_households = current_user.households.new

    # (4)の情報を登録する際に収支項目の目標金額も登録できるように中間テーブルを経由して全収支項目分のインスタンスを作成
    # 全収支項目のidを取得するため、ExpenseRevunueItemテーブルにある全idを配列として取得
    expense_revenue_item_id_list = Household.get_expense_revenue_items_order_category
    # idリストにあるidをインプットに全収支項目分のインスタンスを作成
    expense_revenue_item_id_list.each do |expense_revenue_item|
      @ideal_households.expense_revenue_amounts.build(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
    end

    # (5)詳細画面で表示する家計情報の調整版をtitleで検索しインスタンス変数に格納（詳細画面にて調整版作成有無により処理を分岐させるため）
    if current_user.households.find_by(title: "（調整版）#{@household.title}").present?
      @ideal_created_id = current_user.households.find_by(title: "（調整版）#{@household.title}").id
    else 
      @ideal_created_id = false
    end

  end

  def new

    # ログインユーザーの現在の家計情報の登録のために新規のhouseholdインスタンスを生成し、インスタンス変数に格納
    @household = current_user.households.new

    # 中間テーブル（expense_revenue_amounts）を経由し、現在の家計の収支項目を登録できるように全収支項目分のインスタンスを作成
    # 全収支項目のidを取得するため、ExpenseRevunueItemテーブルにある全idを配列として取得
    expense_revenue_item_id_list = ExpenseRevenueItem.select("id")
    # idリストにあるidをインプットに全収支項目分のインスタンスを作成
    expense_revenue_item_id_list.each do |expense_revenue_item|
      @household.expense_revenue_amounts.build(expense_revenue_item_id: expense_revenue_item.id, amount: 0)
    end

  end

  def edit
    binding.pry
  end

  def create
    @household = current_user.households.new(household_params)
    respond_to do |format|
      if @household.save
        format.html { redirect_to household_url(@household), notice: t('notice.successful_create') }
        format.json { render :show, status: :created, location: @household }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @household.update(household_params)
        format.html { redirect_to household_url(@household), notice: t('notice.successful_update') }
        format.json { render :show, status: :ok, location: @household }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @household.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @household.destroy

    respond_to do |format|
      format.html { redirect_to households_url, notice: t('notice.successful_delete') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_household
      @household = Household.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def household_params
      params.require(:household).permit(:id, :title, expense_revenue_amounts_attributes: [:id,:expense_revenue_item_id,:amount])
    end

    def correct_user
      @household_user = Household.find(params[:id]).user
      redirect_to households_path, notice: "家計状況を登録したユーザーと異なるため参照できません" unless current_user?(@household_user,current_user)
    end

end
