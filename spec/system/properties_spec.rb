require 'rails_helper'

RSpec.describe "Properties", type: :system do
  let!(:user) { FactoryBot.create(:user, children_number: 1) }
  let!(:users_child) { create(:child, user: user) }
  let!(:users_child_education1) { create(:child_education, child: users_child, education_expense: EducationExpense.find(1)) }
  let!(:users_child_education2) { create(:child_education, child: users_child, education_expense: EducationExpense.find(2)) }
  let!(:users_child_education3) { create(:child_education, child: users_child, education_expense: EducationExpense.find(20)) }
  let!(:users_child_education4) { create(:child_education, child: users_child, education_expense: EducationExpense.find(21)) }
  let!(:users_child_education5) { create(:child_education, child: users_child, education_expense: EducationExpense.find(5)) }
  let!(:users_child_education6) { create(:child_education, child: users_child, education_expense: EducationExpense.find(9)) }
  let!(:users_household) { FactoryBot.create(:household, user: user) }
  ExpenseRevenueItem.all.each do |item|
    let!(:"expense_revenue_item#{item.id}") { create(:"expense_revenue_item#{item.id}", household: users_household) }
  end

  describe "資産状況登録画面" do
    before do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
      click_link"資産状況"
    end

    it "（アクセス）ログインしていない状態で資産状況登録画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      # 資産状況詳細画面を表示
      visit new_property_path
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end
    
    it "（CRUD機能、画面遷移テスト）入力必須項目の入力後『登録する』ボタン押下すると、詳細画面に遷移し、登録成功のメッセージが表示されること" do
      # この時点で1件の家計状況情報が登録されているので、それを資産状況確認対象として選択し、『表示する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '表示する'
      # 画面のタイトルから資産状況登録画面に遷移したことを確認
      expect(page).to have_content("資産状況登録")

      # 登録画面の各項目を入力し、『登録する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      fill_in "property_best_annual_interest_rate", with: 0.07 
      fill_in "property_worst_annual_interest_rate", with: 0.03 
      fill_in "property_car_properties_present_value", with: 5000000
      fill_in "property_housing_properties_present_value", with: 0 
      fill_in "property_other_properties_present_value", with: 1000000
      fill_in "property_car_present_loan_balance", with: 4000000
      fill_in "property_housing_present_loan_balance", with: 0 
      fill_in "property_other_present_loan_balance", with: 1000000
      fill_in "property_car_annual_residual_value_rate", with: 0.8 
      fill_in "property_housing_annual_residual_value_rate", with: 0.7
      fill_in "property_other_annual_residual_value_rate", with: 0.9
      fill_in "property_car_loan_interest_rate", with: 0.015
      fill_in "property_housing_loan_interest_rate", with: 0
      fill_in "property_other_loan_interest_rate", with: 0.05

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする
      click_button '登録する'

      # 登録成功した場合に、詳細画面に遷移しているかを画面タイトルから確認
      expect(page).to have_content("資産状況詳細")
      # 登録成功のメッセージが表示されているかを確認
      expect(page).to have_content("登録しました")         
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力が1つでも不足する場合、『登録する』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
      # この時点で1件の家計状況情報が登録されているので、それを資産状況確認対象として選択し、『表示する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '表示する'
      # 画面のタイトルから資産状況登録画面に遷移したことを確認
      expect(page).to have_content("資産状況登録")

      # 登録画面の各項目を入力し、『登録する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      fill_in "property_best_annual_interest_rate", with: 0.07 
      fill_in "property_worst_annual_interest_rate", with: ''
      fill_in "property_car_properties_present_value", with: 5000000
      fill_in "property_housing_properties_present_value", with: 0 
      fill_in "property_other_properties_present_value", with: 1000000
      fill_in "property_car_present_loan_balance", with: 4000000
      fill_in "property_housing_present_loan_balance", with: 0 
      fill_in "property_other_present_loan_balance", with: 1000000
      fill_in "property_car_annual_residual_value_rate", with: 0.8 
      fill_in "property_housing_annual_residual_value_rate", with: 0.7
      fill_in "property_other_annual_residual_value_rate", with: 0.9
      fill_in "property_car_loan_interest_rate", with: 0.015
      fill_in "property_housing_loan_interest_rate", with: 0
      fill_in "property_other_loan_interest_rate", with: 0.05

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする
      click_button '登録する'

      # 画面遷移してないことを画面タイトルから確認
      expect(page).to have_content("資産状況登録")
      # エラーメッセージが表示されているかを確認
      expect(page).to have_content("不調の場合の投資年率が未入力です")         
    end

    it "（CRUD機能、画面遷移テスト）a.家計状況に紐づく資産状況情報が未登録の場合：『編集対象として選択する』ボタンを押下すると、画面遷移せずに各入力項目に初期値が入った状態の資産状況登録画面が表示されること" do
      # この時点で1件の家計状況情報が登録されているので、それを資産状況確認対象として選択し、『表示する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '表示する'
      # 画面のタイトルから資産状況登録画面に遷移したことを確認
      expect(page).to have_content("資産状況登録")

      # 事前に登録された家計状況情報（資産情報なし）を資産状況確認対象として選択し、『編集対象として選択する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '編集対象として選択する'

      # 画面のタイトルから資産状況登録画面に遷移したことを確認
      expect(page).to have_content("資産状況登録")
      # 初期値の状態で資産状況編集画面が表示される場合に表示されるメッセージを確認
      expect(page).to have_content("選択した家計情報に紐づく資産情報を登録ください")
    end

    it "（CRUD機能、画面遷移テスト）b.家計状況に紐づく資産状況情報が登録済みの場合：『編集対象として選択する』ボタンを押下すると、資産状況編集画面に遷移すること" do
      # この時点で1件の家計状況情報が登録されているので、それを資産状況確認対象として選択し、『表示する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '表示する'
      # 画面のタイトルから資産状況登録画面に遷移したことを確認
      expect(page).to have_content("資産状況登録")
      
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)
      # 事前に登録された家計状況情報（資産情報あり）をを資産状況確認対象として選択し、『編集対象として選択する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '編集対象として選択する'

      # 画面のタイトルとリンクから資産状況編集画面に遷移したことを確認
      expect(page).to have_content("資産状況編集")
      expect(page).to have_content("資産情報の編集を行います") 
    end
  end

  describe "資産状況編集画面" do
    before do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
    end

    it "（アクセス）ログインしていない状態で資産状況編集画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      # 資産状況編集画面を表示
      visit edit_property_path(users_property)
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（アクセス）本人以外の資産状況編集画面を表示しようとした場合、自身の資産状況編集画面に遷移し、エラーメッセージが表示されること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)
      click_link('ログアウト')
      sleep 5
      # 事前に作成したuserとは別のユーザーを作成し、そのユーザーでログインする
      user2 = FactoryBot.create(:user,name: "test_user2", email: "test_user2@abc.com", password: "test_user2", password_confirmation: "test_user2")
      user2_household = FactoryBot.create(:household, title: "user2_test_household", user: user2)
      visit user_session_path
      fill_in 'メールアドレス', with: user2.email
      fill_in 'パスワード', with: 'test_user2'
      click_button"ログイン"

      # user2でログインした状態でuserが作成した資産状況編集画面を表示する
      visit edit_property_path(users_property)

      sleep 5

      # エラーメッセージが表示され、user2の資産状況詳細画面に遷移することを確認する
      expect(page).to have_content("資産状況を登録したユーザーと異なるため参照できません")
      expect(page).to have_content("資産状況詳細")
      # プルダウンに表示される確認対象の家計状況情報がuser2が登録したものであることを確認
      expect(find_field('selected_household').first('option').text).to eq user2_household.title
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力後『更新する』ボタン押下すると、詳細画面に遷移し、登録成功のメッセージが表示されること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)

      # userが作成した資産状況の編集画面を表示する
      visit edit_property_path(users_property)

      sleep 5

      # 編集対象として指定したusers_propertyの情報が編集画面に反映されているかを確認
      expect(users_property.best_annual_interest_rate).to eq find("#property_best_annual_interest_rate").value.to_f
      expect(users_property.worst_annual_interest_rate).to eq find("#property_worst_annual_interest_rate").value.to_f
      expect(users_property.car_properties_present_value).to eq find("#property_car_properties_present_value").value.to_f
      expect(users_property.housing_properties_present_value).to eq find("#property_housing_properties_present_value").value.to_f
      expect(users_property.other_properties_present_value).to eq find("#property_other_properties_present_value").value.to_f
      expect(users_property.car_present_loan_balance).to eq find("#property_car_present_loan_balance").value.to_f
      expect(users_property.housing_present_loan_balance).to eq find("#property_housing_present_loan_balance").value.to_f
      expect(users_property.other_present_loan_balance).to eq find("#property_other_present_loan_balance").value.to_f
      expect(users_property.car_annual_residual_value_rate).to eq find("#property_car_annual_residual_value_rate").value.to_f
      expect(users_property.housing_annual_residual_value_rate).to eq find("#property_housing_annual_residual_value_rate").value.to_f
      expect(users_property.other_annual_residual_value_rate).to eq find("#property_other_annual_residual_value_rate").value.to_f
      expect(users_property.car_loan_interest_rate).to eq find("#property_car_loan_interest_rate").value.to_f
      expect(users_property.housing_loan_interest_rate).to eq find("#property_housing_loan_interest_rate").value.to_f
      expect(users_property.other_loan_interest_rate).to eq find("#property_other_loan_interest_rate").value.to_f

      # 例として「好調の場合の投資年率」の値のみを上書きして『更新する』ボタンを押下
      fill_in "property_best_annual_interest_rate", with: 0.05
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『更新する」ボタンを検索し、クリックする
      click_button '更新する'

      # 登録成功した場合に、詳細画面に遷移しているかを画面タイトルから確認
      expect(page).to have_content("資産状況詳細")
      # 登録成功のメッセージが表示されているかを確認
      expect(page).to have_content("更新しました")         
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力が1つでも不足する場合、『更新する』ボタン押下すると、画面遷移せずに、エラーメッセージが表示されること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)

      # userが作成した資産状況の編集画面を表示する
      visit edit_property_path(users_property)

      sleep 5

      # 編集対象として指定したusers_propertyの情報が編集画面に反映されているかを確認
      expect(users_property.best_annual_interest_rate).to eq find("#property_best_annual_interest_rate").value.to_f
      expect(users_property.worst_annual_interest_rate).to eq find("#property_worst_annual_interest_rate").value.to_f
      expect(users_property.car_properties_present_value).to eq find("#property_car_properties_present_value").value.to_f
      expect(users_property.housing_properties_present_value).to eq find("#property_housing_properties_present_value").value.to_f
      expect(users_property.other_properties_present_value).to eq find("#property_other_properties_present_value").value.to_f
      expect(users_property.car_present_loan_balance).to eq find("#property_car_present_loan_balance").value.to_f
      expect(users_property.housing_present_loan_balance).to eq find("#property_housing_present_loan_balance").value.to_f
      expect(users_property.other_present_loan_balance).to eq find("#property_other_present_loan_balance").value.to_f
      expect(users_property.car_annual_residual_value_rate).to eq find("#property_car_annual_residual_value_rate").value.to_f
      expect(users_property.housing_annual_residual_value_rate).to eq find("#property_housing_annual_residual_value_rate").value.to_f
      expect(users_property.other_annual_residual_value_rate).to eq find("#property_other_annual_residual_value_rate").value.to_f
      expect(users_property.car_loan_interest_rate).to eq find("#property_car_loan_interest_rate").value.to_f
      expect(users_property.housing_loan_interest_rate).to eq find("#property_housing_loan_interest_rate").value.to_f
      expect(users_property.other_loan_interest_rate).to eq find("#property_other_loan_interest_rate").value.to_f

      # 例として「好調の場合の投資年率」の値を空白に上書きして『更新する』ボタンを押下
      fill_in "property_best_annual_interest_rate", with: ''
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『更新する」ボタンを検索し、クリックする
      click_button '更新する'

      # 画面遷移していないかを画面タイトルから確認
      expect(page).to have_content("資産状況編集")
      # エラーメッセージが表示されているかを確認
      expect(page).to have_content("好調の場合の投資年率が未入力です")         
    end

    it "「戻る」リンクを押下すると初期状態の資産状況詳細画面に遷移すること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)
      # userが作成した資産状況の編集画面を表示する
      visit edit_property_path(users_property)
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5    
      click_link '戻る'
      expect(page).to have_content("資産状況詳細")
      # 資産状況確認対象選択のプルダウンに表示される家計状況情報がuserが登録したものであることを確認
      expect(find_field('selected_household').first('option').text).to eq users_household.title
    end
  end

  describe "資産状況詳細画面" do
    before do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
      click_link"資産状況"
    end

    it "（アクセス）ログインしていない状態で資産状況詳細画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      # 資産状況詳細画面を表示
      visit properties_path(users_property)
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（アクセス）本人以外の資産状況詳細画面を表示しようとした場合、自身の資産状況詳細画面に遷移し、エラーメッセージが表示されること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)

      click_link('ログアウト')
      sleep 5
      # 事前に作成したuserとは別のユーザーを作成し、そのユーザーでログインする
      user2 = FactoryBot.create(:user,name: "test_user2", email: "test_user2@abc.com", password: "test_user2", password_confirmation: "test_user2")
      user2_household = FactoryBot.create(:household, title: "user2_test_household", user: user2)
      visit user_session_path
      fill_in 'メールアドレス', with: user2.email
      fill_in 'パスワード', with: 'test_user2'
      click_button"ログイン"

      # user2でログインした状態でuserが作成した資産状況詳細画面を表示する
      visit properties_get_selected_household_path({selected_household: "#{users_household.id}",for_show_or_new_action: "show" })

      sleep 5

      # エラーメッセージが表示され、user2の資産状況詳細画面に遷移することを確認する
      expect(page).to have_content("資産状況を登録したユーザーと異なるため参照できません")
      expect(page).to have_content("資産状況詳細")
      # プルダウンに表示される確認対象の家計状況情報がuser2が登録したものであることを確認
      expect(find_field('selected_household').first('option').text).to eq user2_household.title
    end

    it "a.資産状況確認対象として選択した家計状況に紐づく資産状況情報が未登録の場合：『表示する』ボタンを押下すると、資産状況登録画面に遷移すること" do
      # この時点で1件の家計状況情報が登録されているので、それを資産状況確認対象として選択し、『表示する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '表示する'

      # 画面のタイトルから資産状況登録画面に遷移したことを確認
      expect(page).to have_content("資産状況登録")
      # 資産状況登録画面に表示されるメッセージを確認
      expect(page).to have_content("選択した家計情報に紐づく資産情報を登録ください")
    end

    it "b-1.資産状況確認対象として選択した家計状況に紐づく資産状況情報が登録済みの場合：『表示する』ボタンを押下すると、資産状況詳細画面に遷移すること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)
      # この時点で1件の家計状況情報が登録されているので、それを資産状況確認対象として選択し、『表示する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '表示する'

      # 画面のタイトルとリンクから資産状況詳細画面に遷移したことを確認
      expect(page).to have_content("資産状況詳細")
      expect(page).to have_link("資産情報を編集する") 
    end

    it "b-2.資産状況確認対象として選択した家計状況に紐づく資産状況情報が登録済みの場合：『表示する』ボタン押下後に遷移する資産状況詳細画面に表示される、「資産情報を編集する」リンクを押下すると家計状況編集画面に遷移すること" do
      # 登録済みの家計状況情報に紐づく資産状況情報を登録
      users_property = FactoryBot.create(:property, household: users_household)
      # この時点で1件の家計状況情報が登録されているので、それを資産状況確認対象として選択し、『表示する』ボタンを押下
      select "#{users_household.title}", from: "selected_household"
      click_button '表示する'

      # 画面のタイトルとリンクから資産状況詳細画面に遷移したことを確認
      expect(page).to have_content("資産状況詳細")
      expect(page).to have_link("資産情報を編集する") 

      # 「資産情報を編集する」リンクを押下し
      click_link "資産情報を編集する"

      # 画面のタイトルから資産状況編集画面に遷移したことを確認
      expect(page).to have_content("資産状況編集")
      # 既存のデータを編集する場合の資産状況編集画面に表示されるメッセージを確認
      expect(page).to have_content("資産情報の編集を行います")
    end
  end

end
