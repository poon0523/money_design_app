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
        set_years_of_observation.times do
            this_year += 1
            years_list.push(this_year)
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
    def create_cash_and_saving_list(monthly_revenue_expenditure)
        # 標準月の総支出を算出
        monthly_expenditures_amount_list = 
            monthly_revenue_expenditure.where.not(expense_revenue_item: {name: "世帯収入"}).map do |expenditure_amount|
                expenditure_amount.amount
            end
        monthly_total_expenditures = monthly_expenditures_amount_list.sum
        # 標準月の総収入を取得
        monthly_total_revenue = monthly_revenue_expenditure.find_by(expense_revenue_item: {name: "世帯収入"}).amount
        # 月の現金・貯蓄額（標準月の総収入-総支出）を元に年間の現金・貯蓄金額を算出
        annual_cash_and_saving = (monthly_total_revenue - monthly_total_expenditures)*12
        # 経年の現金・貯蓄額のリストを作成（今年の現金・貯蓄額を翌年に積み上げて経年の現金・貯蓄額の推移のデータを作成）
        annual_cash_and_saving_list = []
        Property.set_years_of_observation.times do |year|
            if year == 0
                annual_cash_and_saving_list.push(annual_cash_and_saving)
            else
                annual_cash_and_saving_list.push(annual_cash_and_saving+annual_cash_and_saving_list[year-1])
            end
        end
        
        return annual_cash_and_saving_list
    end

    # 臨時収入・支出入力時の現金・貯蓄金額60年分のデータ再作成
    # 資産状況詳細画面の「臨時収入」「臨時支出」に入力されたデータを引数（adjust_revenue、adjust_expenditure）に用いる
    # 資産状況詳細画面では5年置きのデータが表示されるため、「臨時収入」「臨時支出」のデータも5年置きにしか入力できない仕様
    # そのため、既存の現金・貯蓄金額60年分のデータのうち、5年置きにデータを参照し、臨時収入がある場合はプラス、支出がある場合はマイナスとするようにする
    def create_adjusted_cash_and_saving_list(before_adjusted_cash_and_saving_list,adjust_revenue,adjust_expenditure)
        adjust_revenue_expenditure_index_count = 0
        adjust_cash_and_saving_list = []
        before_adjusted_cash_and_saving_list.map.with_index do |cash_and_saving,index|
            if index == 0 
                adjust_revenue_and_expenditure_amount = (adjust_revenue[adjust_revenue_expenditure_index_count])-(adjust_expenditure[adjust_revenue_expenditure_index_count])
                cash_and_saving = before_adjusted_cash_and_saving_list[0] + adjust_revenue_and_expenditure_amount
                adjust_cash_and_saving_list.push(cash_and_saving)
                adjust_revenue_expenditure_index_count += 1
            elsif index == 59 || index%5 == 0
                adjust_revenue_and_expenditure_amount = (adjust_revenue[adjust_revenue_expenditure_index_count])-(adjust_expenditure[adjust_revenue_expenditure_index_count])
                cash_and_saving = before_adjusted_cash_and_saving_list[0] + adjust_cash_and_saving_list[(index-1)]+adjust_revenue_and_expenditure_amount
                adjust_cash_and_saving_list.push(cash_and_saving)
                adjust_revenue_expenditure_index_count += 1
            else
                cash_and_saving = before_adjusted_cash_and_saving_list[0] + adjust_cash_and_saving_list[(index-1)]
                adjust_cash_and_saving_list.push(cash_and_saving)
            end
        end
        return adjust_cash_and_saving_list
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

    # 子どもの教育方針に応じて教育費マスタから教育費を参照し、保育園~大学までの教育費のデータ作成
    # 注：子どもが複数人いる場合、1人ずつに対して本処理が行われる。すべての子どもの教育費の合算はprivateメソッドである、create_total_education_expense_listにて行われる
    def create_education_expense_list(child)
        # 子どもの年齢算出のベース年月日の初期値を設定
        base_year_month_day = (Date.new(Date.today.year,04,01)).strftime("%Y%m%d").to_i
        # 毎年の年間教育費を格納するための変数の初期値設定
        annual_education_expense = 0
        # 資産状況観察対象期間の各年の年間教育費を配列として格納するための変数の初期値設定
        education_expenses_list = []
        # 各子どもの教育段階に応じ再た教育費を教育費マスタ（education_expenses）から抽出し配列として変数に定義
        education_expenses_of_every_education_institution_type = 
            EducationExpense.joins(:child_educations).select("education_expenses.*, child_educations.child_id").where( child_educations:{child_id: child.id} )
        # 資産状況観測対象期間分の教育費用をeducation_expenses_of_every_education_institution_typeから参照し、education_expenses_listに順番に追加
        # education_expenses_of_every_education_institution_typeのうち、どの値を参照するかは子どもの年齢により判断する
        Property.set_years_of_observation.times do
            # privateメソッドであるcalc_age_of_childメソッドより各年時点での子どもの年齢を算出
            age = calc_age_of_child(base_year_month_day,child.birth_year_month_day)

            # 出生前の場合
            if age < 0 then
                annual_education_expense = 0
            # 3才未満の場合
            elsif age < 3 && age >= child.nursery_school_start_age then
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 1).annual_expense
            # 3才以上、6才未満の場合
            elsif 3 <= age  &&  age < 6
                # 幼稚園には行かずに、保育園に行く場合
                if child.kindergarten_start_age > age && child.nursery_school_start_age < child.kindergarten_start_age
                    annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 1).annual_expense
                # 幼稚園には行かずに、保育園を継続する場合
                elsif child.kindergarten_start_age == child.nursery_school_start_age
                    annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 1).annual_expense
                # 幼稚園に行く場合
                elsif age >= child.kindergarten_start_age
                    annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 2).annual_expense
                end
            # 6才以上、13歳未満の場合
            elsif 6 <= age && age < 13 then
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 3).annual_expense
            # 13歳以上、16歳未満の場合
            elsif 13 <= age && age < 16 then
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 4).annual_expense
            # 16歳以上、19歳未満の場合
            elsif  16 <= age && age < 19 then
                annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 5).annual_expense
            # 19歳以上の場合
            elsif  19 <= age then
                # 専門学校で21歳未満の場合
                if education_expenses_of_every_education_institution_type.find_by(education_institution_type: 6).present? && age < 21 then
                    annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 6).annual_expense
                # 4年生大学で23歳未満の場合
                elsif education_expenses_of_every_education_institution_type.find_by(education_institution_type: 7).present? && age < 23 then
                    annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 7).annual_expense
                # 6年生大学で25歳未満の場合
                elsif education_expenses_of_every_education_institution_type.find_by(education_institution_type: 8).present? && age < 25 then
                    annual_education_expense = education_expenses_of_every_education_institution_type.find_by(education_institution_type: 8).annual_expense
                else
                    annual_education_expense = 0
                end
            end

            # if文で設定したannual_education_expenseをeducation_expenses_listに追加
            education_expenses_list.push(annual_education_expense)
            # base_year_month_dayを翌年に進める
            base_year_month_day += 10000
        end

        return education_expenses_list
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
    def create_total_property_list(property,household,annual_interest_rate,adjusted_cash_and_saving=[])
        if adjusted_cash_and_saving.present?
            cash_and_saving_list = adjusted_cash_and_saving
        else
            cash_and_saving_list = create_cash_and_saving_list(household.joins_data_expense_revenue_amount_and_item(household))
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
        # 子どもがいる場合は教育費のリストを作成し、総負債計算に含めて計算する
        if children.length > 0
            education_expenses_list = create_total_education_expense_list(property,children)
            return [car_loan_list,housing_loan_list,other_loan_list,education_expenses_list].transpose.map{ |annual_total_liabilities|
            annual_total_liabilities.inject(:+) }
        # 子どもがいない場合は教育費のリストを作成せずに、総負債計算をする
        else
            return [car_loan_list,housing_loan_list,other_loan_list].transpose.map{ |annual_total_liabilities|
            annual_total_liabilities.inject(:+) }
        end
    
    end

    # 純資産60年分のデータ作成
    def create_net_property_list(property,household,children,annual_interest_rate)
        total_property_list = create_total_property_list(property,household,annual_interest_rate)
        total_liability_list = create_total_liability_list(property,household,children)
        return [total_property_list,total_liability_list].transpose.map{ |annual_net_property|
        annual_net_property.inject(:-) }
    end

    private

    # 子どもの満年齢算出
    def calc_age_of_child(base_year_month_day,birth_year_month_day)
        return (base_year_month_day - birth_year_month_day)/10000
    end

    # （子どもが複数人いる場合を考慮して）子どもの総教育費算出
    def create_total_education_expense_list(property,children)
        total_education_expenses_list = []
        children.each do |child|
            education_expense_list = property.create_education_expense_list(child)
            total_education_expenses_list.push(education_expense_list)
        end

        return total_education_expenses_list.transpose.map{ |annual_total_education_expenses| annual_total_education_expenses.inject(:+) }
    end

    
end
