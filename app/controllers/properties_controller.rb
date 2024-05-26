class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: %i[ get_selected_household ]
  before_action :correct_user_for_edit, only: %i[ edit ]
  before_action :set_property, only: %i[ edit update destroy ]

  # （indexアクションは機能要件には含まれないが、確認用で機能として残す）
  def index
    @properties = Property.all
  end


  def show
    @households = current_user.households.all
    @household = current_user.households.first
  end

  def get_selected_household

    # 資産状況の登録画面、もしくは詳細画面で選択した家計情報のidをインスタンス変数に格納
    # 資産状況詳細画面へのアクセス制限として、@householdが格納できる場合とできない場合に処理を分岐
    # 選択した家計状況情報を登録したのが現在のログインユーザーである場合　→詳細画面、編集画面の処理を正常に実行する
    @household = current_user.households.find(params[:selected_household])
    @households = current_user.households.all

    # 1つの家計状況には1つの資産状況の情報が紐づくため、firstで資産状況を取得
    @property = @household.properties.first

    # 選択した家計情報に紐づく資産情報が登録されている場合
    if @household.properties.present?
        
      # 詳細画面から家計情報が選択された場合
      if params[:for_show_or_new_action] == "show"
        # 詳細画面で表示する各種データを60年分作成しインスタンス変数に格納（データ作成メソッドはmodelに定義）
        # 詳細画面に表示する各種データの作成に子どもの情報が必要であるため、ユーザーに紐づく子どもの情報を配列としてインスタンス変数に格納
        @children = current_user.children 
        
        # 1.現金・貯蓄
        @cash_and_saving = @property.create_cash_and_saving_list(@household.joins_data_expense_revenue_amount_and_item(@household),@children)
        # 2-1.投資資産（ベストケース）
        @best_investment_properties = @property.create_investment_list(@household.get_specific_expense_revenue_amount(@household,"積立投資額"),@property.best_annual_interest_rate.truncate(2))
        # 2-2.投資資産（ワーストケース）
        @worst_investment_properties = @property.create_investment_list(@household.get_specific_expense_revenue_amount(@household,"積立投資額"),@property.worst_annual_interest_rate.truncate(2))
        # 3-1.使用資産（車）
        @car_property = @property.create_used_properties_list(@property.car_properties_present_value,@property.car_annual_residual_value_rate)
        # 3-2.使用資産（住宅）
        @housing_property = @property.create_used_properties_list(@property.housing_properties_present_value,@property.housing_annual_residual_value_rate)
        # 3-3.使用資産（その他）
        @other_property = @property.create_used_properties_list(@property.other_properties_present_value,@property.other_annual_residual_value_rate)
        # 4-1.ローン（車）
        @car_loan = @property.create_loan_list(@property.car_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（車）"), @property.car_loan_interest_rate)
        # 4-2.ローン（住宅）
        @housing_loan = @property.create_loan_list(@property.housing_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（住宅）"), @property.housing_loan_interest_rate)
        # 4-3.ローン（その他）
        @other_loan = @property.create_loan_list(@property.other_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（その他）"), @property.other_loan_interest_rate)
        # 純資産（ベストケース）
        @best_net_property = @property.create_net_property_list(@property,@household,@children,@property.best_annual_interest_rate.truncate(2))
        # 純資産（ワーストケース）
        @worst_net_property = @property.create_net_property_list(@property,@household,@children,@property.worst_annual_interest_rate.truncate(2))

        # 資産状況の詳細画面に遷移
        render :show
      
      # 登録画面から家計情報が選択された場合
      elsif params[:for_show_or_new_action] == "new"
        flash.now[:notice] = '資産情報の編集を行います'
        # 資産状況の登録画面に遷移(@propertyにより遷移先ではすでに登録された資産情報が表示される)
        render :edit
      end
    
    # 資産情報が登録されていない場合
    else
      # Property情報を登録するためにインスタンスを生成し、インスタンス変数に格納
      @property = @household.properties.new
      flash.now[:notice] = '選択した家計情報に紐づく資産情報を登録ください'
      render :new  
    end

  end

  # 資産状況の詳細画面にある調整項目に値を入力した場合に、入力した値を受け取り、純資産を再計算し直す処理
  # 調整項目はgetメソッド、かつremote:trueでリクエストされるため「update_net_property_to_include_adjust_input.js.erb」がレンダリングされる
  # 「update_net_property_to_include_adjust_input.js.erb」では棒グラフの更新が行われるため、それらに必要なデータと本アクションで準備
  def update_net_property_to_include_adjust_input
    # property、household、childrenのデータは「update_net_property_to_include_adjust_input.js.erb」で必要であるためインスタンス変数に格納
    @property = Property.find(params[:property])
    @household = current_user.households.find(params[:household])
    if params[:child].present?
      @children = current_user.children.find(params[:child])
    else
      @children = []
    end

    # -------ここから臨時収入／支出金額を踏まえた純資産の再計算の処理-------
    # 現金・貯蓄金額を再計算するための変数として調整金額（収入）の配列をローカル変数に格納。ベストケースとワーストケースで入力フォームが分かれているため別々の変数を作成
    best_adjust_revenue_input_list = params[:best_adjust_revenue_input].map{|revenue| revenue.to_i }
    worst_adjust_revenue_input_list = params[:worst_adjust_revenue_input].map{|revenue| revenue.to_i }

    # 現金・貯蓄金額を再計算するための変数として調整金額（支出）の配列をローカル変数に格納。ベストケースとワーストケースで入力フォームが分かれているため別々の変数を作成
    best_adjust_expenditure_input_list = params[:best_adjust_expenditure_input].map{|expenditure| expenditure.to_i }
    worst_adjust_expenditure_input_list = params[:worst_adjust_expenditure_input].map{|expenditure| expenditure.to_i }

    # 現金・貯蓄金額を再計算するための変数として臨時収入／支出を加味する前の60年分の現金・貯蓄金額の配列をローカル変数に格納
    before_adjusted_cash_and_saving_list = params[:cash_and_saving].map{|cash_and_saving| cash_and_saving.to_i }

    # 現金・貯蓄金額を再計算。現金・貯蓄金額60年分の配列データをローカル変数に格納
    best_adjusted_cash_and_saving_list = @property.create_cash_and_saving_list(@household.joins_data_expense_revenue_amount_and_item(@household),@children,best_adjust_revenue_input_list, best_adjust_expenditure_input_list)
    worst_adjusted_cash_and_saving_list = @property.create_cash_and_saving_list(@household.joins_data_expense_revenue_amount_and_item(@household),@children,worst_adjust_revenue_input_list, worst_adjust_expenditure_input_list)

    # 再計算した現金・貯蓄金額のデータより総資産を再計算し、配列データとしてローカル変数に格納
    update_best_total_property_list = Property.data_extraction_every_5years(@property.create_total_property_list(@property,@household,@children,@property.best_annual_interest_rate,best_adjusted_cash_and_saving_list))
    update_worst_total_property_list = Property.data_extraction_every_5years(@property.create_total_property_list(@property,@household,@children,@property.worst_annual_interest_rate,worst_adjusted_cash_and_saving_list))

    # 純資産再計算のため総負債（ベスト、ワーストケース共通）をローカル変数に格納
    total_liability_list = Property.data_extraction_every_5years(@property.create_total_liability_list(@property,@household,@children))

    # 再計算した総資産と総負債のデータより純資産を再計算。レンダリング先の「update_net_property_to_include_adjust_input.js.erb」にてグラフの更新データとするためインスタンス変数に格納
    @update_best_net_property_list =  [update_best_total_property_list,total_liability_list].transpose.map{ |annual_net_property|
                            annual_net_property.inject(:-) }
    @update_worst_net_property_list =  [update_worst_total_property_list,total_liability_list].transpose.map{ |annual_net_property|
                            annual_net_property.inject(:-) }
   
  end

  def new
  end

  def edit
    flash.now[:notice] = '資産情報の編集を行います'
  end

  def create
    @property = Property.new(property_params)
    respond_to do |format|
      if @property.save
        # 詳細画面表示で必要なインスタンス変数を定義
        @households = current_user.households.all
        @household = Household.find(@property.household_id)
        @children = current_user.children.all
        # 詳細画面で表示する各種データを60年分作成しインスタンス変数に格納（データ作成メソッドはmodelに定義） 
        # 1.現金・貯蓄
        @cash_and_saving = @property.create_cash_and_saving_list(@household.joins_data_expense_revenue_amount_and_item(@household),@children)
        # 2-1.投資資産（ベストケース）
        @best_investment_properties = @property.create_investment_list(@household.get_specific_expense_revenue_amount(@household,"積立投資額"),@property.best_annual_interest_rate.truncate(2))
        # 2-2.投資資産（ワーストケース）
        @worst_investment_properties = @property.create_investment_list(@household.get_specific_expense_revenue_amount(@household,"積立投資額"),@property.worst_annual_interest_rate.truncate(2))
        # 3-1.使用資産（車）
        @car_property = @property.create_used_properties_list(@property.car_properties_present_value,@property.car_annual_residual_value_rate)
        # 3-2.使用資産（住宅）
        @housing_property = @property.create_used_properties_list(@property.housing_properties_present_value,@property.housing_annual_residual_value_rate)
        # 3-3.使用資産（その他）
        @other_property = @property.create_used_properties_list(@property.other_properties_present_value,@property.other_annual_residual_value_rate)
        # 4-1.ローン（車）
        @car_loan = @property.create_loan_list(@property.car_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（車）"), @property.car_loan_interest_rate)
        # 4-2.ローン（住宅）
        @housing_loan = @property.create_loan_list(@property.housing_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（住宅）"), @property.housing_loan_interest_rate)
        # 4-3.ローン（その他）
        @other_loan = @property.create_loan_list(@property.other_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（その他）"), @property.other_loan_interest_rate)
        # 純資産（ベストケース）
        @best_net_property = @property.create_net_property_list(@property,@household,@children,@property.best_annual_interest_rate.truncate(2))
        # 純資産（ワーストケース）
        @worst_net_property = @property.create_net_property_list(@property,@household,@children,@property.worst_annual_interest_rate.truncate(2))

        flash.now[:notice] = t('notice.successful_create')

        format.html { render :show }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @property.update(property_params)
        # 詳細画面表示で必要なインスタンス変数を定義
        @households = current_user.households.all
        @household = Household.find(@property.household_id)
        @children = current_user.children.all
        # 詳細画面で表示する各種データを60年分作成しインスタンス変数に格納（データ作成メソッドはmodelに定義） 
        # 1.現金・貯蓄
        @cash_and_saving = @property.create_cash_and_saving_list(@household.joins_data_expense_revenue_amount_and_item(@household),@children)
        # 2-1.投資資産（ベストケース）
        @best_investment_properties = @property.create_investment_list(@household.get_specific_expense_revenue_amount(@household,"積立投資額"),@property.best_annual_interest_rate.truncate(2))
        # 2-2.投資資産（ワーストケース）
        @worst_investment_properties = @property.create_investment_list(@household.get_specific_expense_revenue_amount(@household,"積立投資額"),@property.worst_annual_interest_rate.truncate(2))
        # 3-1.使用資産（車）
        @car_property = @property.create_used_properties_list(@property.car_properties_present_value,@property.car_annual_residual_value_rate)
        # 3-2.使用資産（住宅）
        @housing_property = @property.create_used_properties_list(@property.housing_properties_present_value,@property.housing_annual_residual_value_rate)
        # 3-3.使用資産（その他）
        @other_property = @property.create_used_properties_list(@property.other_properties_present_value,@property.other_annual_residual_value_rate)
        # 4-1.ローン（車）
        @car_loan = @property.create_loan_list(@property.car_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（車）"), @property.car_loan_interest_rate)
        # 4-2.ローン（住宅）
        @housing_loan = @property.create_loan_list(@property.housing_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（住宅）"), @property.housing_loan_interest_rate)
        # 4-3.ローン（その他）
        @other_loan = @property.create_loan_list(@property.other_present_loan_balance, @household.get_specific_expense_revenue_amount(@household,"ローン返済額（その他）"), @property.other_loan_interest_rate)
        # 純資産（ベストケース）
        @best_net_property = @property.create_net_property_list(@property,@household,@children,@property.best_annual_interest_rate.truncate(2))
        # 純資産（ワーストケース）
        @worst_net_property = @property.create_net_property_list(@property,@household,@children,@property.worst_annual_interest_rate.truncate(2))

        flash.now[:notice] = t('notice.successful_update')
        
        format.html { render :show }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @property.destroy

    respond_to do |format|
      format.html { redirect_to properties_url, notice: t('notice.successful_delete') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.require(:property).permit(
        :household_id, 
        :best_annual_interest_rate, 
        :worst_annual_interest_rate,
        :car_properties_present_value,
        :housing_properties_present_value,
        :other_properties_present_value,
        :car_present_loan_balance,
        :housing_present_loan_balance,
        :other_present_loan_balance,
        :car_annual_residual_value_rate,
        :housing_annual_residual_value_rate,
        :other_annual_residual_value_rate,
        :car_loan_interest_rate,
        :housing_loan_interest_rate,
        :other_loan_interest_rate
        )
    end

    def correct_user
      if !(Household.find(params[:selected_household]).user == current_user)
        if Household.where(user_id: current_user.id).empty? 
          redirect_to new_property_path, notice: "資産状況を登録したユーザーと異なるため参照できません" 
        else
          @households = current_user.households.all
          @household = current_user.households.first  
          flash.now[:notice] = "資産状況を登録したユーザーと異なるため参照できません"
          render :show
        end
      end
    end

    def correct_user_for_edit
      if !(Property.find(params[:id]).household.user == current_user) 
        if Household.where(user_id: current_user.id).empty? 
          redirect_to new_property_path, notice: "資産状況を登録したユーザーと異なるため参照できません" 
        else
          @households = current_user.households.all
          @household = current_user.households.first  
          flash.now[:notice] = "資産状況を登録したユーザーと異なるため参照できません"
          render :show
        end
      end
    end


end
