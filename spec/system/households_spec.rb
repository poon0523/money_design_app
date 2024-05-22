require 'rails_helper'


RSpec.describe "Households", type: :system do
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

  describe "家計状況一覧画面" do

    before do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
    end

    it "（アクセス）ログイン後にログインユーザーの家計状況一覧画面に遷移すること" do
      expect(page).to have_content("ログインしました。")
      expect(page).to have_content("#{user.name}さんの家計状況一覧")
    end

    it "（アクセス）ログインしていない状態で家計状況一覧を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      visit households_path
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end


    it "（CRUD機能、画面遷移テスト）家計状況一覧画面の「新規登録」ボタン押下→家計状況登録画面に遷移すること" do
      # 新規登録画面で表示する「教育費」の自動計算のため、ユーザーに紐づく子どものインスタンスのリストを作成（本テストケースでは子どもは1人）
      # ユーザーに紐づく子ども（1人）のリスト
      children = []
      children.push(users_child)     
      click_button '新規登録'
      expect(page).to have_content("家計状況登録")
    end

    it "（CRUD機能、画面遷移テスト）家計状況一覧画面の「編集」リンク押下→家計状況編集画面に遷移すること" do
      # 編集画面で表示する「教育費」の自動計算のため、ユーザーに紐づく子どものインスタンスのリストを作成（本テストケースでは子どもは1人）
      # ユーザーに紐づく子ども（1人）のリスト
      children = []
      children.push(users_child)     
      click_link '編集'
      expect(page).to have_content("家計状況編集")
    end


    it "（CRUD機能、画面遷移テスト）家計状況一覧画面で、(a)タイトル名に「（調整版）」を含まない、かつ調整版が未登録の家計状況の詳細画面に遷移→「調整版を登録」のボタンが表示されること" do
      click_link('詳細')
      expect(page).to have_content("「#{users_household.title}」詳細")
      expect(page).to have_button("調整版を登録")
    end

    it "（CRUD機能、画面遷移テスト）家計状況一覧画面で、(b)タイトル名に「（調整版）」を含まない、かつ調整版が登録済みの家計状況の詳細画面に遷移→「（調整版）タイトル名」のリンクが表示されること" do
      # テストデータとして登録済みの家計状況情報（users_household）の調整版を追加で登録
      FactoryBot.create(:household, user: user, title: "（調整版）#{users_household.title}")
      # 改めて家計状況一覧を表示
      click_link '家計状況'
      # 調整版が登録された状態の家計状況のリンクを押下し、詳細画面を表示
      click_link '詳細', href: household_path(users_household.id)

      # 既定の画面サイズにすべての要素が収まらず、「戻る」リンクが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 7     
      
      # 詳細画面には調整版がすでに登録されているので、『調整版の登録』ボタンは表示されず、「(調整版）#{users_household.title}」のリンクが表示される
      expect(page).to have_no_button("調整版を登録")
      expect(page).to have_link("（調整版）#{users_household.title}")
    end

    it "（CRUD機能、画面遷移テスト）家計状況一覧画面で、(c)タイトル名に「（調整版）」を含む家計状況の詳細画面に遷移→「調整版を登録」のボタン、「（調整版）タイトル名」のリンクが表示されないこと" do
      # テストデータとして登録済みの家計状況情報（users_household）の調整版を追加で登録
      adjusted_users_household = FactoryBot.create(:household, user: user, title: "（調整版）#{users_household.title}")
      ExpenseRevenueItem.all.each do |item|
        FactoryBot.create(:"expense_revenue_item#{item.id}", household: adjusted_users_household)
      end  
       # 改めて家計状況一覧を表示
      click_link '家計状況'
      # 追加した「(調整版）#{users_household.title}」の家計状況のリンクを押下し、詳細画面を表示
      click_link '詳細', href: household_path(adjusted_users_household.id)
      # 『調整版の登録』ボタン、「(調整版）#{users_household.title}」の両方が表示されない
      expect(page).to have_no_button("調整版を登録")
      expect(page).to have_no_link("（調整版）#{users_household.title}")
    end

    it "（CRUD機能、画面遷移テスト）家計状況一覧画面の「削除」リンク押下→削除確認メッセージ表示→指定した家計状況が家計状況一覧削除されること" do
      # 削除後、指定した家計状況が一覧に含められていないかを確認するためにタイトルをローカル変数に格納
      destroy_target_households_title = users_household.title
      # 家計状況一覧から削除対象のデータのidを取得
      destroy = Household.find(users_household.id)
      # idを取得したデータの削除リンクを押下し、データを削除
      click_link '削除', href: household_path(destroy)
      # モダール画面に確認メッセージが表示されることを確認
      expect(page.accept_confirm).to eq '本当に削除してもよろしいですか？'
      # 削除完了のメッセージが表示されることを確認
      expect(page).to have_content '削除しました'
      # 家計状況一覧に削除したデータが含まれていないことを確認
      expect(page).to have_no_content '#{destroy_target_households_title}'
    end
  end

  describe "家計状況登録画面" do
    before do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
      # 新規登録画面で表示する「教育費」の自動計算のため、ユーザーに紐づく子どものインスタンスのリストを作成（本テストケースでは子どもは1人）
      # ユーザーに紐づく子ども（1人）のリスト
      children = []
      children.push(users_child)     
      click_button '新規登録'
    end

    it "（アクセス）ログインしていない状態で家計情報登録画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      visit new_household_path
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力後『登録』ボタン押下すると、詳細画面に遷移し、登録成功のメッセージが表示されること" do
      # すべての項目入力必須であるため以下の通り入力する
      # 家計状況のタイトル入力
      fill_in 'タイトル', with: "YYYYMMDD家計状況(Ver.0)"
      # 各種収支項目の金額を入力（viewの記載の仕方の違いにより、ラベル名で入力項目を指定することができないためid指定）
      # 教育費は自動入力、変更不可であるため入力対象から外し、その他、世帯収入以外の費用項目は一律の値を入力する
      expense_revenue_amounts_id_list = ExpenseRevenueItem.all.map {|item| item.id-1 }
      expense_revenue_amounts_id_list.each do |item_id|
        if !(ExpenseRevenueItem.find(item_id+1).name == "教育費") && !(ExpenseRevenueItem.find(item_id+1).name == "世帯収入")
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: 10000
        elsif ExpenseRevenueItem.find(item_id+1).name == "世帯収入"
          fill_in "household_expense_revenue_amounts_attributes_#{item_id+1}_amount", with: 50000000
        # 「教育費」のみ自動入力（子どもの情報に応じてマスタ参照）→正しくマスタの情報が表示されているか確認
        elsif ExpenseRevenueItem.find(item_id+1).name == "教育費"
          # テストユーザーの子ども（1人）の現在の教育費（月）をローカル変数に格納
          refer_present_education_expense = (Child.create_total_education_expense_list(user.children).first)/12
          # 自動入力された教育費の値をローカル変数に格納
          display_education_expense = find("#household_expense_revenue_amounts_attributes_6_amount").value.to_i
          # マスタ参照した教育費と表示されている教育費が一致することを確認
          expect(display_education_expense).to eq refer_present_education_expense
        else
        end
      end

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録」ボタンを検索し、クリックする
      find('.form_btn').click

      # 登録成功した場合に、詳細画面に遷移しているかを画面タイトルから確認
      expect(page).to have_content("「YYYYMMDD家計状況(Ver.0)」詳細")
      # 登録成功のメッセージが表示されているかを確認
      expect(page).to have_content("登録しました")
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力が1つでも不足する場合、『登録』ボタン押下すると、画面遷移せずにエラーメッセージが表示されること" do
      fill_in 'タイトル', with: "YYYYMMDD家計状況(Ver.0)"
      # 各種収支項目の金額を入力（viewの記載の仕方の違いにより、ラベル名で入力項目を指定することができないためid指定）
      # 教育費は自動入力、変更不可であるため入力対象から外し、その他、世帯収入以外の費用項目は一律の値を入力する
      expense_revenue_amounts_id_list = ExpenseRevenueItem.all.map {|item| item.id-1 }
      expense_revenue_amounts_id_list.each do |item_id|
        if !(ExpenseRevenueItem.find(item_id+1).name == "医療費") && !(ExpenseRevenueItem.find(item_id+1).name == "教育費") && !(ExpenseRevenueItem.find(item_id+1).name == "世帯収入")
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: 10000
        elsif ExpenseRevenueItem.find(item_id+1).name == "世帯収入"
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: 50000000
        # 「教育費」のみ自動入力（子どもの情報に応じてマスタ参照）→正しくマスタの情報が表示されているか確認
        elsif ExpenseRevenueItem.find(item_id+1).name == "教育費"
          # 自動入力された教育費の値をローカル変数に格納
          display_education_expense = find("#household_expense_revenue_amounts_attributes_#{item_id}_amount").value.to_i
          # テストユーザーの子ども（1人）の現在の教育費（月）をローカル変数に格納
          refer_present_education_expense = (Child.create_total_education_expense_list(user.children).first)/12
          # マスタ参照した教育費と表示されている教育費が一致することを確認
          expect(display_education_expense).to eq refer_present_education_expense
          # "医療費"のみ金額の入力しない状態で入力をする
        elsif ExpenseRevenueItem.find(item_id+1).name == "医療費"
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: ''
        end
      end

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録」ボタンを検索し、クリックする
      find('.form_btn').click

      # 登録失敗した場合に、詳細画面には遷移せず、登録画面が表示されているかを画面タイトルから確認
      expect(page).to have_content("家計状況登録")
      # 登録失敗のメッセージが表示されているかを確認
      expect(page).to have_content("いずれかの金額が未入力です")
    end

    it "（画面遷移テスト）「戻る」リンクを押下すると、家計状況一覧画面に遷移すること" do
      # 既定の画面サイズにすべての要素が収まらず、「戻る」リンクが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5     
      click_link '戻る'
      expect(page).to have_content("#{user.name}さんの家計状況一覧")
    end
  end

  describe "家計状況編集画面" do
    before do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
      # 編集画面で表示する「教育費」の自動計算のため、ユーザーに紐づく子どものインスタンスのリストを作成（本テストケースでは子どもは1人）
      # ユーザーに紐づく子ども（1人）のリスト
      children = []
      children.push(users_child)     
      # ログイン後、家計状況一覧画面が表示され、そこには事前に登録した1件の家計状況データが表示されるので、そのデータの編集画面を表示する
      click_link '編集'
    end

    it "（アクセス）ログインしていない状態で家計情報編集画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      visit edit_household_path(users_household)
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（アクセス）本人以外の家計情報編集画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      click_link('ログアウト')
      sleep 5
      # 事前に作成したuserとは別のユーザーを作成し、そのユーザーでログインする
      user2 = FactoryBot.create(:user,name: "test_user2", email: "test_user2@abc.com", password: "test_user2", password_confirmation: "test_user2")
      visit user_session_path
      fill_in 'メールアドレス', with: user2.email
      fill_in 'パスワード', with: 'test_user2'
      click_button"ログイン"
      # user2でログインした状態でuserが作成した家計状況の編集画面を表示する
      visit edit_household_path(users_household)
      # エラーメッセージが表示され、user2の家計状況一覧画面に遷移することを確認する
      expect(page).to have_content("家計状況を登録したユーザーと異なるため参照できません")
      expect(page).to have_content("#{user2.name}さんの家計状況一覧")
    end

    it "（CRUD機能、画面遷移テスト）編集対象の家計状況の情報が編集画面に表示されている状態で値を編集し、『登録』ボタン押下すると詳細画面に遷移し、登録成功のメッセージが表示されること" do
      # 入力必須項目に家計状況一覧画面で選択した家計状況の情報が正しく表示されているかを確認
      expect(page).to have_field 'タイトル', with: users_household.title
      expense_revenue_amounts_id_list = ExpenseRevenueItem.all.map {|item| item.id-1 }
      expense_revenue_amounts_id_list.each do |item_id|
        expect(page).to have_field "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: users_household.expense_revenue_amounts.find_by(expense_revenue_item_id: ExpenseRevenueItem.find(item_id+1).id).amount
      end
      # すべての入力必須項目の値を変更する（※教育費は自動入力なので変更なし）
      fill_in 'タイトル', with: "YYYYMMDD家計状況(Ver.0)_update"
      expense_revenue_amounts_id_list.each do |item_id|
        if !(ExpenseRevenueItem.find(item_id+1).name == "教育費") && !(ExpenseRevenueItem.find(item_id+1).name == "世帯収入")
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: 30000
        elsif ExpenseRevenueItem.find(item_id+1).name == "世帯収入"
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: 70000000
        else
        end
      end

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録」ボタンを検索し、クリックする
      find('.form_btn').click

      # 登録成功した場合に、編集内容が反映された状態で詳細画面に遷移しているかを画面タイトルから確認
      expect(page).to have_content("「YYYYMMDD家計状況(Ver.0)_update」詳細")
      # 登録成功のメッセージが表示されているかを確認
      expect(page).to have_content("更新しました")
    end

    it "（CRUD機能、画面遷移テスト）編集対象の家計状況の情報が編集画面に表示されている状態で入力必須項目の値を1つでも消してしまった場合、『登録』ボタン押下すると画面遷移せずに、登録失敗のメッセージが表示されること" do
      # 入力必須項目に家計状況一覧画面で選択した家計状況の情報が正しく表示されているかを確認
      expect(page).to have_field 'タイトル', with: users_household.title
      expense_revenue_amounts_id_list = ExpenseRevenueItem.all.map {|item| item.id-1 }
      expense_revenue_amounts_id_list.each do |item_id|
        expect(page).to have_field "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: users_household.expense_revenue_amounts.find_by(expense_revenue_item_id: ExpenseRevenueItem.find(item_id+1).id).amount
      end
      # すべての入力必須項目の値を変更する（※教育費は自動入力なので変更なし）
      fill_in 'タイトル', with: "YYYYMMDD家計状況(Ver.0)_update"
      expense_revenue_amounts_id_list.each do |item_id|
        if !(ExpenseRevenueItem.find(item_id+1).name == "医療費") && !(ExpenseRevenueItem.find(item_id+1).name == "教育費") && !(ExpenseRevenueItem.find(item_id+1).name == "世帯収入")
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: 30000
        elsif ExpenseRevenueItem.find(item_id+1).name == "世帯収入"
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: 70000000
        elsif ExpenseRevenueItem.find(item_id+1).name == "医療費"
          fill_in "household_expense_revenue_amounts_attributes_#{item_id}_amount", with: ''
        else
        end
      end
  
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 3
      # スクロース後の画面から『登録」ボタンを検索し、クリックする
      find('.form_btn').click
  
      # 登録失敗した場合に、詳細画面には遷移せず、登録画面が表示されているかを画面タイトルから確認
      expect(page).to have_content("家計状況編集")
      # 登録失敗のメッセージが表示されているかを確認
      expect(page).to have_content("いずれかの金額が未入力です")
    end

    it "（画面遷移テスト）「戻る」リンクを押下すると、家計状況一覧画面に遷移すること" do
      # 既定の画面サイズにすべての要素が収まらず、「戻る」リンクが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 7   
      click_link '戻る'
      expect(page).to have_content("#{user.name}さんの家計状況一覧")
    end
  end

  describe "家計状況詳細画面" do
    before do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
      # ログイン後、家計状況一覧画面が表示され、そこには事前に登録した1件の家計状況データが表示されるので、そのデータの詳細画面を表示する
      click_link '詳細'
    end

    it "（アクセス）ログインしていない状態で家計情報詳細画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      visit household_path(users_household)
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（アクセス）本人以外の家計情報詳細画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      click_link('ログアウト')
      sleep 5
      # 事前に作成したuserとは別のユーザーを作成し、そのユーザーでログインする
      user2 = FactoryBot.create(:user,name: "test_user2", email: "test_user2@abc.com", password: "test_user2", password_confirmation: "test_user2")
      visit user_session_path
      fill_in 'メールアドレス', with: user2.email
      fill_in 'パスワード', with: 'test_user2'
      click_button"ログイン"
      # user2でログインした状態でuserが作成した家計状況の編集画面を表示する
      visit household_path(users_household)
      # エラーメッセージが表示され、user2の家計状況一覧画面に遷移することを確認する
      expect(page).to have_content("家計状況を登録したユーザーと異なるため参照できません")
      expect(page).to have_content("#{user2.name}さんの家計状況一覧")
    end

    it "（CRUD機能、画面遷移テスト）(a)タイトル名に「（調整版）」を含まない、かつ調整版が未登録の家計状況の詳細画面の場合：目標金額の入力後「調整版を登録」ボタンを押下し、調整版の登録が成功したら詳細画面に遷移し、登録成功のメッセージが表示されること" do
      # 各収支項目の目標金額を入力（世帯収入のみ自動入力）
      expense_revenue_amounts_id_list = Household.order_expense_revenue_amounts(users_household).map {|ordered_item| ordered_item.expense_revenue_item_id }
      expense_revenue_amounts_id_list.each do |item_id|
        if  !(ExpenseRevenueItem.find(item_id).name == "世帯収入")
          fill_in "household_ideal_#{item_id}", with: 3000
        end
      end

      # 既定の画面サイズにすべての要素が収まらず、『調整版を登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録」ボタンを検索し、クリックする
      find('.form_btn').click
  
      # 登録成功した場合に、詳細画面に遷移しているかを画面タイトルから確認
      expect(page).to have_content("「（調整版）#{users_household.title}」詳細")
      # 登録成功のメッセージが表示されているかを確認
      expect(page).to have_content("登録しました")
    end

    it "（CRUD機能、画面遷移テスト）(b)タイトル名に「（調整版）」を含まない、かつ調整版が登録済みの家計状況の詳細画面の場合：「（調整版）タイトル名」のリンクを押下すると調整版の家計状況の詳細画面が表示されること" do
      # テストデータとして登録済みの家計状況情報（users_household）の調整版を追加で登録
      adjusted_users_household = FactoryBot.create(:household, user: user, title: "（調整版）#{users_household.title}")
      ExpenseRevenueItem.all.each do |item|
        FactoryBot.create(:"expense_revenue_item#{item.id}", household: adjusted_users_household)
      end  

      # 改めて家計状況一覧を表示
      click_link '家計状況'
      # 調整版が登録された状態の家計状況のリンクを押下し、詳細画面を表示
      click_link '詳細', href: household_path(users_household.id)
      # 詳細画面には調整版がすでに登録されているので、『調整版の登録』ボタンは表示されず、「(調整版）#{users_household.title}」のリンクが表示される
      expect(page).to have_no_button("調整版を登録")
      expect(page).to have_link("（調整版）#{users_household.title}")

      # 既定の画面サイズにすべての要素が収まらず、『調整版を登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から「（調整版）#{users_household.title}」リンクを検索し、クリックする
      click_link "（調整版）#{users_household.title}"

      # リンク押下後に調整版の詳細画面に遷移するかを画面タイトルから確認 
      expect(page).to have_content("「（調整版）#{users_household.title}」詳細")
    end

    it "（CRUD機能、画面遷移テスト）「編集」リンクを押下すると詳細画面に表示されているデータの編集画面に遷移すること" do
      click_link '編集'
      # 「編集」リンク押下後の画面タイトルより画面遷移の確認
      expect(page).to have_content('家計状況編集')
      # 遷移先の編集画面の「タイトル」の入力値が遷移元の詳細画面のタイトルと一致するかにより、編集画面に正しくデータが表示されていることを確認
      edit_title = find('#household_title').value
      expect(users_household.title).to eq edit_title
    end

    it "（CRUD機能、画面遷移テスト）「戻る」リンクを押下すると家計状況一覧画面に遷移すること" do
      click_link '戻る'
      expect(page).to have_content("#{user.name}さんの家計状況一覧")
    end    

  end

end
