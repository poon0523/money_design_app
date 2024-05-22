require 'rails_helper'

# <<補足>> userモデルSystemSpecテストではユーザー編集、登録に加えて以下のテストも併せて実施する
# (1)ログイン機能のテスト
# (2)ユーザー権限に応じたトップ画面の確認テスト
# (3)トップ画面に表示されるナビゲーションバーの遷移先の確認テスト
# (4)管理者画面のアクセス制限の確認テスト

RSpec.describe "Users", type: :system do
  let!(:user) { FactoryBot.create(:user, children_number: 1) }
  let!(:users_child) { create(:child, user: user) }
  let!(:users_child_education1) { create(:child_education, child: users_child, education_expense: EducationExpense.find(1)) }
  let!(:users_child_education2) { create(:child_education, child: users_child, education_expense: EducationExpense.find(2)) }
  let!(:users_child_education3) { create(:child_education, child: users_child, education_expense: EducationExpense.find(20)) }
  let!(:users_child_education4) { create(:child_education, child: users_child, education_expense: EducationExpense.find(21)) }
  let!(:users_child_education5) { create(:child_education, child: users_child, education_expense: EducationExpense.find(5)) }
  let!(:users_child_education6) { create(:child_education, child: users_child, education_expense: EducationExpense.find(9)) } 

  describe "ユーザー登録画面" do
    it "（CRUD機能、画面遷移テスト）成功-入力必須項目の入力後『登録』ボタン押下すると、子どもの登録画面に遷移し、登録成功のメッセージが表示されること" do
      visit new_user_registration_path
      fill_in 'user_name', with: "test_user2"
      fill_in 'user_email', with: "test_user2@abc.com"
      fill_in 'user_password', with: "test_user2"
      fill_in 'user_password_confirmation', with: "test_user2"
      # ※管理者権限はデフォルトがfalseで、変更はサイト管理画面でのみ可能としているため入力なし
      # check 'user_admin'
      fill_in 'user_age', with: 25
      select 'あり', from: 'user_marital_status'
      fill_in 'user_spouse_age', with: 26
      fill_in 'user_children_number', with: 1
      click_button"登録"

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("子どもの情報登録")
      expect(page).to have_content("アカウントを作成しました。続けて、お子様の情報をご登録ください") 
    end

    it "（CRUD機能、画面遷移テスト）失敗a.入力必須項目（メールアドレスを例に検証）の入力が1つでも不足する場合、『登録』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
      visit new_user_registration_path
      fill_in 'user_name', with: "test_user2"
      fill_in 'user_email', with: ""
      fill_in 'user_password', with: "test_user2"
      fill_in 'user_password_confirmation', with: "test_user2"
      # ※管理者権限はデフォルトがfalseで、変更はサイト管理画面でのみ可能としているため入力なし
      # check 'user_admin'
      fill_in 'user_age', with: 25
      select 'あり', from: 'user_marital_status'
      fill_in 'user_spouse_age', with: 26
      fill_in 'user_children_number', with: 1
      click_button"登録"

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("ユーザー登録")
      expect(page).to have_content("メールアドレスが未入力です") 
    end
    
    it "（CRUD機能、画面遷移テスト）失敗b.登録済みのメールアドレスを入力した場合、『登録』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
      visit new_user_registration_path
      fill_in 'user_name', with: "test_user2"
      fill_in 'user_email', with: "test_user@abc.com"
      fill_in 'user_password', with: "test_user2"
      fill_in 'user_password_confirmation', with: "test_user2"
      # ※管理者権限はデフォルトがfalseで、変更はサイト管理画面でのみ可能としているため入力なし
      # check 'user_admin'
      fill_in 'user_age', with: 25
      select 'あり', from: 'user_marital_status'
      fill_in 'user_spouse_age', with: 26
      fill_in 'user_children_number', with: 1
      click_button"登録"

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("ユーザー登録")
      expect(page).to have_content("メールアドレスはすでに使用されています") 
    end   

    
    it "（CRUD機能、画面遷移テスト）失敗c.6文字未満のパスワードを入力した場合、『登録』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
      visit new_user_registration_path
      fill_in 'user_name', with: "test_user2"
      fill_in 'user_email', with: "test_user@abc.com"
      fill_in 'user_password', with: "test"
      fill_in 'user_password_confirmation', with: "test_user2"
      # ※管理者権限はデフォルトがfalseで、変更はサイト管理画面でのみ可能としているため入力なし
      # check 'user_admin'
      fill_in 'user_age', with: 25
      select 'あり', from: 'user_marital_status'
      fill_in 'user_spouse_age', with: 26
      fill_in 'user_children_number', with: 1
      click_button"登録"

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("ユーザー登録")
      expect(page).to have_content("パスワードは6文字以上で入力してください") 
    end   
    
  end

  describe "ユーザー編集画面" do
    it "（アクセス）ログインしていない状態でユーザー編集画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # ログアウト状態にする
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")

      # ユーザー編集画面を表示
      visit edit_user_registration_path(user)
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（アクセス）本人以外のユーザー編集画面を表示しようとした場合、自身のユーザー編集画面に遷移すること" do
      # 事前に作成したuserとは別のユーザーを作成し、そのユーザーでログインする
      user2 = FactoryBot.create(:user,name: "test_user2", email: "test_user2@abc.com", password: "test_user2", password_confirmation: "test_user2")
      visit user_session_path
      fill_in 'メールアドレス', with: user2.email
      fill_in 'パスワード', with: 'test_user2'
      click_button"ログイン"

      # user2でログインした状態でuser（事前に作成したユーザー）が作成したユーザー編集画面を表示する
      visit edit_user_registration_path(user)

      sleep 5

      # user2のユーザー編集画面に遷移することを確認する
      expect(page).to have_content("ユーザー編集")
      expect(find_field('名前').value).to eq user2.name
    end

    it "（CRUD機能、画面遷移テスト）ゲストユーザーの編集画面は「子どもの人数」の項目以外は項目が無効化されていること" do
      # ゲストユーザー（一般）を例にテスト
      # CapybaraにPOSTメソッドがないので、まずトップ画面を表示した上、ログインリンクをクリック
      visit top_main_path
      click_link 'ゲストログイン(一般)'
      expect(page).to have_content("ゲストユーザー（一般）としてログインしました。")

      # 「アカウント」リンクをクリックしてユーザー編集画面に遷移し、入力項目の状態を確認（「子どもの人数」以外はdisabled: true）
      click_link 'アカウント'
      expect(page).to have_content("ユーザー編集")
      expect(find('#user_name').disabled?).to eq true
      expect(find('#user_email').disabled?).to eq true
      expect(find('#user_password').disabled?).to eq true
      expect(find('#user_password_confirmation').disabled?).to eq true
      expect(find('#user_admin').disabled?).to eq true
      expect(find('#user_age').disabled?).to eq true
      expect(find('#user_marital_status').disabled?).to eq true
      expect(find('#user_spouse_age').disabled?).to eq true
      expect(find('#user_children_number').disabled?).to eq false   
    end

    it "（CRUD機能、画面遷移テスト）ゲストユーザー以外の編集画面は「管理者権限」以外は項目が有効化されていること" do
      # 事前登録をしているuserでログインをした上でアカウント編集画面を表示
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # 「アカウント」リンクをクリックしてユーザー編集画面に遷移し、入力項目の状態を確認（「管理者権限」以外はdisabled: false）
      click_link 'アカウント'
      expect(page).to have_content("ユーザー編集")
      expect(find('#user_name').disabled?).to eq false
      expect(find('#user_email').disabled?).to eq false
      expect(find('#user_password').disabled?).to eq false
      expect(find('#user_password_confirmation').disabled?).to eq false
      expect(find('#user_admin').disabled?).to eq true
      expect(find('#user_age').disabled?).to eq false
      expect(find('#user_marital_status').disabled?).to eq false
      expect(find('#user_spouse_age').disabled?).to eq false
      expect(find('#user_children_number').disabled?).to eq false      
    end

    it "（CRUD機能、画面遷移テスト）成功-入力必須項目の更新後『更新』ボタン押下すると、子どもの編集画面に遷移し、更新成功のメッセージが表示されること" do
      # 事前登録をしているuserでログインをした上でアカウント編集画面を表示
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # アカウント編集画面を表示
      click_link('アカウント')
      expect(page).to have_content("ユーザー編集")

      # ユーザー編集画面にて、配偶者の年齢（子どもの人数以外ならどの項目でもＯＫ）を変更した上で『更新』ボタンを押下
      fill_in 'user_spouse_age', with: 30
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする     
      click_button"更新"

      sleep 10

      # 子どもの編集画面が表示され、既存の子どもの情報を修正に関するメッセージが表示されていることを確認
      expect(page).to have_content("子どもの情報編集")
      expect(page).to have_content("アカウントを更新しました。続けて、お子様の情報に更新があれば修正ください")
    end

    it "（CRUD機能、画面遷移テスト）失敗a.入力必須項目（メールアドレスを例に検証）の入力が1つでも不足する場合、『更新』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
      # 事前登録をしているuserでログインをした上でアカウント編集画面を表示
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # アカウント編集画面を表示
      click_link('アカウント')
      expect(page).to have_content("ユーザー編集")

      # ユーザー編集画面にて、メールアドレスを空白に変更した上で『更新』ボタンを押下
      fill_in 'user_email', with: ""
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする     
      click_button"更新"

      sleep 10

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("ユーザー編集")
      expect(page).to have_content("メールアドレスが未入力です") 
    end 
  
    it "（CRUD機能、画面遷移テスト）失敗b.登録済みのメールアドレスを入力した場合、『更新』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
      # 事前登録をしているuserでログインをした上でアカウント編集画面を表示
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # アカウント編集画面を表示
      click_link('アカウント')
      expect(page).to have_content("ユーザー編集")

      # ユーザーを追加
      user2 = FactoryBot.create(:user,name: "test_user2", email: "test_user2@abc.com", password: "test_user2", password_confirmation: "test_user2")

      # ユーザー編集画面にて、追加したユーザーと同じメールアドレスに変更した上で『更新』ボタンを押下
      fill_in 'user_email', with: "test_user2@abc.com"
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする     
      click_button"更新"

      sleep 10

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("ユーザー編集")
      expect(page).to have_content("メールアドレスはすでに使用されています") 
    end      

  
    it "（CRUD機能、画面遷移テスト）失敗c.6文字未満のパスワードを入力した場合、『更新』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
      # 事前登録をしているuserでログインをした上でアカウント編集画面を表示
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # アカウント編集画面を表示
      click_link('アカウント')
      expect(page).to have_content("ユーザー編集")

      # ユーザー編集画面にて、パスワードを6文字以下に変更した上で『更新』ボタンを押下
      fill_in 'user_password', with: "test"
      fill_in 'user_password_confirmation', with: "test"
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする     
      click_button"更新"

      sleep 10

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("ユーザー編集")
      expect(page).to have_content("パスワードは6文字以上で入力してください") 
    end       
  end

  describe "ログイン画面" do
    it "a.一般ユーザーとして登録済みのユーザーがログインした場合、家計状況一覧画面に遷移し、ナビゲーションバーに「各種データ管理（管理者用メニュー）」以外のメニューが表示されていること" do
      general_user = FactoryBot.create(:user, admin: false, email: "general_user@abc.com")
      general_users_household = FactoryBot.create(:household, user: general_user)

      visit user_session_path
      fill_in 'メールアドレス', with: general_user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      expect(page).to have_content("ログインしました。")
      expect(page).to have_content("#{general_user.name}さんの家計状況一覧")
      expect(page).to have_link("アカウント")
      expect(page).to have_link("家計状況")
      expect(page).to have_link("資産状況")
      expect(page).to have_link("ログアウト")
      expect(page).to have_no_link("各種データ管理")
    end

    it "b.管理者として登録済みのユーザーがログインした場合、家計状況一覧画面に遷移し、ナビゲーションバーに「各種データ管理（管理者用メニュー）」含めたのすべてのメニューが表示されていること" do
      admin_user = FactoryBot.create(:user, admin: true, email: "admin_user@abc.com")
      admin_users_household = FactoryBot.create(:household, user: admin_user)

      visit user_session_path
      fill_in 'メールアドレス', with: admin_user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      expect(page).to have_content("ログインしました。")
      expect(page).to have_content("#{admin_user.name}さんの家計状況一覧")
      expect(page).to have_link("アカウント")
      expect(page).to have_link("家計状況")
      expect(page).to have_link("資産状況")
      expect(page).to have_link("ログアウト")
      expect(page).to have_link("各種データ管理")
    end

    it "c.一般のゲストユーザーとしてログインした場合、家計状況一覧画面に遷移し、ナビゲーションバーに「各種データ管理（管理者用メニュー）」以外のメニューが表示されていること" do
      # CapybaraにPOSTメソッドがないので、まずトップ画面を表示した上、ログインリンクをクリック
      visit top_main_path
      click_link 'ゲストログイン(一般)'

      expect(page).to have_content("ゲストユーザー（一般）としてログインしました。")
      expect(page).to have_content("#{User.general_guest.name}さんの家計状況一覧")
      expect(page).to have_content("#{Household.find_by(user_id: User.general_guest.id).title}")
      expect(page).to have_link("アカウント")
      expect(page).to have_link("家計状況")
      expect(page).to have_link("資産状況")
      expect(page).to have_link("ログアウト")
      expect(page).to have_no_link("各種データ管理")
    end

    it "d.管理者のゲストユーザーとしてログインした場合、家計状況一覧画面に遷移し、ナビゲーションバーに「各種データ管理（管理者用メニュー）」含めたのすべてのメニューが表示されていること" do
      # CapybaraにPOSTメソッドがないので、まずトップ画面を表示した上、ログインリンクをクリック
      visit top_main_path
      click_link 'ゲストログイン(管理者)'

      expect(page).to have_content("ゲストユーザー（管理者）としてログインしました。")
      expect(page).to have_content("#{User.admin_guest.name}さんの家計状況一覧")
      expect(page).to have_content("#{Household.find_by(user_id: User.admin_guest.id).title}")
      expect(page).to have_link("アカウント")
      expect(page).to have_link("家計状況")
      expect(page).to have_link("資産状況")
      expect(page).to have_link("ログアウト")
      expect(page).to have_link("各種データ管理")
    end
 

    it "e.（a~d共通）登録済みのユーザー、かつ家計状況が1件も登録されていないユーザーがログインした場合、家計状況一覧画面に遷移し、ナビゲーションバーに「各種データ管理（管理者用メニュー）」「資産状況」以外のメニューが表示されていること" do
      no_household_general_user = FactoryBot.create(:user, admin: false, email: "no_household_general_user@abc.com")
      visit user_session_path
      fill_in 'メールアドレス', with: no_household_general_user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      expect(page).to have_content("ログインしました。")
      expect(page).to have_content("#{no_household_general_user.name}さんの家計状況一覧")
      expect(page).to have_link("アカウント")
      expect(page).to have_link("家計状況")
      expect(page).to have_no_link("資産状況")
      expect(page).to have_link("ログアウト")
      expect(page).to have_no_link("各種データ管理")
    end

    it "d.未登録のユーザーがログインしようとした場合、アカウント登録画面に遷移すること" do
      visit user_session_path
      fill_in 'メールアドレス', with: "not_created_test_user@abc.com"
      fill_in 'パスワード', with: 'not_created_test_user'
      click_button"ログイン"

      expect(page).to have_content("ログイン")
      expect(page).to have_content("メールアドレスまたはパスワードが違います。")

    end

    it "e.ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される" do
      visit user_session_path
      fill_in 'メールアドレス', with: "test_user@abc.com"
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
    end

  end

  describe "トップ画面" do
    it "a.一般ユーザーとしてログインした場合、ナビゲーションバーに表示されているメニューを押下すると、意図したの画面に遷移すること" do
      general_user = FactoryBot.create(:user, admin: false, email: "general_user@abc.com")
      general_users_household = FactoryBot.create(:household, user: general_user)
      
      visit user_session_path
      fill_in 'メールアドレス', with: "general_user@abc.com"
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"
      click_link "アカウント"

      expect(page).to have_content("ユーザー編集")
      expect(find_field('名前').value).to eq general_user.name

      click_link "家計状況"
      expect(page).to have_content("#{general_user.name}さんの家計状況一覧")
      
      click_link "資産状況"
      expect(page).to have_content("資産状況詳細")

      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
    end

    it "b.管理者ユーザーとしてログインした場合、ナビゲーションバーに表示されているメニューを押下すると、意図したの画面に遷移すること" do
      admin_user = FactoryBot.create(:user, admin: true, email: "admin_user@abc.com")
      admin_users_household = FactoryBot.create(:household, user: admin_user)
      visit user_session_path
      fill_in 'メールアドレス', with: admin_user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      click_link "各種データ管理"
      expect(page).to have_content("サイト管理")
      click_link "ホーム"

      click_link "アカウント"
      expect(page).to have_content("ユーザー編集")
      expect(find_field('名前').value).to eq admin_user.name

      click_link "家計状況"
      expect(page).to have_content("#{admin_user.name}さんの家計状況一覧")
      
      click_link "資産状況"
      expect(page).to have_content("資産状況詳細")

      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
    end

  end

  
  describe "管理者画面（※gem:rails_adminを利用しているため画面遷移などの細かいテストは行わない）" do
    it "一般ユーザーとしてログインし、管理者画面にアクセスした場合、家計状況一覧画面に遷移し、エラーメッセージが表示されること" do
      general_user = FactoryBot.create(:user, admin: false, email: "general_user@abc.com")
      general_users_household = FactoryBot.create(:household, user: general_user)
      
      visit user_session_path
      fill_in 'メールアドレス', with: "general_user@abc.com"
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # 管理者画面に遷移
      visit rails_admin_path

      # 家計状況一覧画面に遷移し、エラーメッセージが表示される
      expect(page).to have_content("#{general_user.name}さんの家計状況一覧")
      expect(page).to have_content("管理者権限がないのでアクセスできません")
    end

    it "管理者としてログインした場合、管理者画面にはアクセスできること" do
      admin_user = FactoryBot.create(:user, admin: true, email: "admin_user@abc.com")
      admin_users_household = FactoryBot.create(:household, user: admin_user)
      visit user_session_path
      fill_in 'メールアドレス', with: admin_user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # 管理者画面に遷移
      visit rails_admin_path

      sleep 7

      # 管理者画面のタイトルが表示される
      expect(page).to have_content("サイト管理")
    end
  end

end
