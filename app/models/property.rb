class Property < ApplicationRecord
    # バリデーションの設定
    validates :best_annual_interest_rate,        presence: true
    validates :worst_annual_interest_rate,       presence: true
    validates :car_properties_present_value,     presence: true
    validates :housing_properties_present_value, presence: true
    validates :other_properties_present_value,   presence: true
    validates :car_present_loan_balance,         presence: true
    validates :housing_present_loan_balance,     presence: true

    # アソシエーションの設定
    belongs_to :household

# -------インスタンスメソッドで共通利用する処理をクラスメソッド（scope）として定義-------

    # ヘッダに設定の「資産状況」から資産状況詳細画面へ遷移するためにPropertyのidを設定
    # 補足：ヘッダから資産状況詳細画面後にどの家計状況を基にした資産状況を確認するかを選択する仕様になっているため、遷移時に指定するPropertyのidに条件はない
    scope :get_property_id, ->(current_user){current_user.households.first.properties.first}

    # 資産状況を観察する年数を設定
    scope :set_years_of_observation, -> {60}

    # 資産状況テーブル表示用の年度リスト作成（データ自体は60年分作成するが、詳細画面には5年おきでデータを表示させるため、5年おきのデータを作成）
    scope :create_years_list_every_5years, ->{
        # 初期値として現在の年を取得
        this_year = Date.today.year
        years_list = []
        # 現在から○年後のデータを表示するため○年数分の各年の値を作成
        set_years_of_observation.times do |year|
            if year == 0
                years_list.push(this_year)
            else
                this_year += 1
                years_list.push(this_year)
            end
        end

        # 60年分の年度から5年おきに年度を抽出（nil含む）
        years_list_every_5years = years_list.map.with_index do |year, index|
            if index == 0 || index == 59 || index%5 == 0
                year
            end
        end

        # 5年おきに年度を抽出したリストのうち、nilを含まない形で戻り値とする
        return years_list_every_5years.compact
    }

    # 資産状況を示す各種データ（60年分）から5年おきにデータを抽出してリストを作成（データ自体は60年分作成するが、詳細画面には5年おきでデータを表示させるため、5年おきのデータを作成）
    scope :data_extraction_every_5years, ->(target_data){
        data_set_every_5years =target_data.map.with_index do |data, index|
            if index == 0 || index == 59 || index%5 == 0
                data
            end
        end
        
        return data_set_every_5years.compact

    }

# -------観察する各種データ作成（60年分）のインスタンスメソッドの定義-------

    # 現金・貯蓄金額60年分のデータ作成
    def create_cash_and_saving_list(monthly_revenue_expenditure,children,adjust_revenue_list=[],adjust_expenditure_list=[])
    
        # 標準月の総支出を算出（教育費はChildモデルのcreate_education_expense_listメソッドによりまとめて60年分算出するため、ここには含めない）
        monthly_expenditures_amount_list = 
            monthly_revenue_expenditure.where.not(expense_revenue_item: {name: ["世帯収入", "教育費"]}).map do |expenditure_amount|
                expenditure_amount.amount
            end
        monthly_total_expenditures = monthly_expenditures_amount_list.sum

        # 標準月の総収入を取得
        monthly_total_revenue = monthly_revenue_expenditure.find_by(expense_revenue_item: {name: "世帯収入"}).amount

        # 月の現金・貯蓄額（標準月の総収入-総支出）を元に年間の現金・貯蓄金額を算出
        annual_cash_and_saving = (monthly_total_revenue - monthly_total_expenditures)*12
        # 子どもがいる場合、60年分の養育費を取得（※子どもが複数名いる場合、合算された状態で取得）、いない場合は0の配列を作成
        if children.length > 0
            education_expense_list = Child.create_total_education_expense_list(children)
        else
            education_expense_list = Array.new(Property.set_years_of_observation,0)
        end

        # 経年の現金・貯蓄額のリストを作成（今年の現金・貯蓄額を翌年に積み上げて経年の現金・貯蓄額の推移のデータを作成）
        # 臨時収入、もしくは臨時支出がある場合
        if adjust_revenue_list.present? || adjust_expenditure_list.present?
            adjust_revenue_expenditure_index_count = 0
            annual_cash_and_saving_list = []
            # アプリ上、臨時収入・臨時支出は5年置きに入力可能としているため、5年置きにadjust_revenue_listとadjust_expenditure_listの値を現金・貯蓄額に含める
            Property.set_years_of_observation.times do |year|
                # 観測初年→臨時収入・臨時支出を現金・貯蓄額に含める
                if year == 0 
                    adjust_revenue_and_expenditure_amount = (adjust_revenue_list[adjust_revenue_expenditure_index_count])-(adjust_expenditure_list[adjust_revenue_expenditure_index_count])
                    annual_cash_and_saving_list.push(annual_cash_and_saving-education_expense_list[year]+adjust_revenue_and_expenditure_amount)
                    adjust_revenue_expenditure_index_count += 1  
                # 5年置き＋観測最終年（60年後）→臨時収入・臨時支出を現金・貯蓄額に含める
                elsif year == 59 || year%5 == 0  
                    adjust_revenue_and_expenditure_amount = (adjust_revenue_list[adjust_revenue_expenditure_index_count])-(adjust_expenditure_list[adjust_revenue_expenditure_index_count])
                    annual_cash_and_saving_list.push(annual_cash_and_saving_list[year-1]+(annual_cash_and_saving-education_expense_list[year])+adjust_revenue_and_expenditure_amount)
                    adjust_revenue_expenditure_index_count += 1 
                # 上記以外→臨時収入・臨時支出を現金・貯蓄額に含めない
                else
                    annual_cash_and_saving_list.push(annual_cash_and_saving_list[year-1]+(annual_cash_and_saving-education_expense_list[year]))
                end
            end

        # 臨時収入、もしくは臨時支出がない場合
        else
            annual_cash_and_saving_list = []
            Property.set_years_of_observation.times do |year|
                if year == 0
                    annual_cash_and_saving_list.push(annual_cash_and_saving-education_expense_list[year])
                else
                    annual_cash_and_saving_list.push(annual_cash_and_saving_list[year-1]+(annual_cash_and_saving-education_expense_list[year]))
                end
            end
        end
        
        return annual_cash_and_saving_list
    end


    # 投資資産額60年分のデータ作成
    def create_investment_list(monthly_reserve_investment,annual_interest_rate)
        # 複利計算に用いる経年数の初期値を設定
        count_of_year = 1
        # 経年の投資資産額のリストを作成
        annual_investment_property_list = []
        Property.set_years_of_observation.times do 
            # 投資の複利計算式：((1+(年利%/12))^12カ月-1)/月利*標準月積立金額)
            after_investment_property_list = (((1+(annual_interest_rate/12))**(12*count_of_year)-1)/(annual_interest_rate/12)*monthly_reserve_investment)
            count_of_year += 1
            annual_investment_property_list.push(after_investment_property_list)
        end
        return annual_investment_property_list
    end

    # 各種使用資産60年分のデータ作成
    def create_used_properties_list(present_value,annual_residual_value_rate)
        present_value_list = []
        previous_year_value = 0
        Property.set_years_of_observation.times do |year|
            if year == 0
                present_value_list.push(present_value)
                previous_year_value = present_value
            else
                present_value = previous_year_value*annual_residual_value_rate
                present_value_list.push(present_value)
                previous_year_value = present_value
            end
        end

        return present_value_list
    end

    # 各種ローン60年分のデータ作成
    def create_loan_list(initial_loan_balance,monthly_paid_loan,annual_loan_interest_rate)
        # 年間のローン返済額の算出
        annual_paid_loan = monthly_paid_loan*12
        # 60年間のローン残高を格納するリストの作成
        loan_balance_list = []
        # 当年のローン残高を格納する変数
        this_year_loan_balance = 0
        if initial_loan_balance > 0
            Property.set_years_of_observation.times do |year|
                # 初年度のローン残高は初回登録時のローン残高として残高リストに追加
                if year == 0
                    loan_balance_list.push(initial_loan_balance)
                else
                    # 2年目以降は「当年のローン残高=前年のローン残高+前年のローン残高*年間ローン金利-年間のローン返済額」で計算し、残高リストに追加
                    this_year_loan_balance = loan_balance_list[year-1] + loan_balance_list[year-1]*annual_loan_interest_rate - annual_paid_loan
                    if this_year_loan_balance > 0
                        loan_balance_list.push(this_year_loan_balance)
                    elsif this_year_loan_balance < 0
                        loan_balance_list.push(0)
                    end
                end
            end
        else
            Property.set_years_of_observation.times do |year|
                loan_balance_list.push(0)
            end
        end

        return loan_balance_list
    end
    
    # 総資産60年分のデータ作成
    def create_total_property_list(property,household,children,annual_interest_rate,adjusted_cash_and_saving=[])
        if adjusted_cash_and_saving.present?
            cash_and_saving_list = adjusted_cash_and_saving
        else
            cash_and_saving_list = create_cash_and_saving_list(household.joins_data_expense_revenue_amount_and_item(household),children)
        end
        investment_list = create_investment_list(household.get_specific_expense_revenue_amount(household,"積立投資額"),annual_interest_rate)
        car_property_list = create_used_properties_list(property.car_properties_present_value,property.car_annual_residual_value_rate)
        housing_property_list = create_used_properties_list(property.housing_properties_present_value,property.housing_annual_residual_value_rate)
        other_property_list = create_used_properties_list(property.other_properties_present_value,property.other_annual_residual_value_rate)

        return [cash_and_saving_list,investment_list,car_property_list,housing_property_list,other_property_list].transpose.map{ |annual_total_properties|
                annual_total_properties.inject(:+) }
    end

    # 総負債60年分のデータ作成
    def create_total_liability_list(property,household,children)
        car_loan_list = create_loan_list(property.car_present_loan_balance, household.get_specific_expense_revenue_amount(household,"ローン返済額（車）"),property.car_loan_interest_rate)
        housing_loan_list = create_loan_list(property.housing_present_loan_balance, household.get_specific_expense_revenue_amount(household,"ローン返済額（住宅）"), property.housing_loan_interest_rate)
        other_loan_list = create_loan_list(property.other_present_loan_balance, household.get_specific_expense_revenue_amount(household,"ローン返済額（その他）"), property.other_loan_interest_rate)
        return [car_loan_list,housing_loan_list,other_loan_list].transpose.map{ |annual_total_liabilities|
        annual_total_liabilities.inject(:+) }
    
    end

    # 純資産60年分のデータ作成
    def create_net_property_list(property,household,children,annual_interest_rate)
        total_property_list = create_total_property_list(property,household,children,annual_interest_rate)
        total_liability_list = create_total_liability_list(property,household,children)
        return [total_property_list,total_liability_list].transpose.map{ |annual_net_property|
        annual_net_property.inject(:-) }
    end
  
end
