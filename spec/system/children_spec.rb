require 'rails_helper'

RSpec.describe "Children", type: :system do

  let!(:user) { FactoryBot.create(:user, children_number: 1) }
  let!(:users_child) { create(:child, user: user) }
  let!(:users_child_education1) { create(:child_education, child: users_child, education_expense: EducationExpense.find(1)) }
  let!(:users_child_education2) { create(:child_education, child: users_child, education_expense: EducationExpense.find(2)) }
  let!(:users_child_education3) { create(:child_education, child: users_child, education_expense: EducationExpense.find(20)) }
  let!(:users_child_education4) { create(:child_education, child: users_child, education_expense: EducationExpense.find(21)) }
  let!(:users_child_education5) { create(:child_education, child: users_child, education_expense: EducationExpense.find(5)) }
  let!(:users_child_education6) { create(:child_education, child: users_child, education_expense: EducationExpense.find(9)) } 
  
  describe "子どもの情報登録画面" do

    it "（アクセス）ログインしていない状態で子どもの情報登録画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # ログアウト状態にする
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")
      # 子どもの情報登録画面を表示
      visit new_child_path
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力後『登録する』ボタン押下すると、家計状況一覧画面に遷移し、登録成功のメッセージが表示されること" do
      # アカウント登録画面で登録を行い、子どもの情報登録画面に遷移
      visit new_user_registration_path
      fill_in 'user_name', with: "test_user2"
      fill_in 'user_email', with: "test_user2@abc.com"
      fill_in 'user_password', with: "test_user2"
      fill_in 'user_password_confirmation', with: "test_user2"
      check 'user_admin'
      fill_in 'user_age', with: 25
      select 'あり', from: 'user_marital_status'
      fill_in 'user_spouse_age', with: 26
      fill_in 'user_children_number', with: 1
      click_button"登録"

      # 子どもの情報登録画面への遷移を確認
      expect(page).to have_content("子どもの情報登録")
      expect(page).to have_content("アカウントを作成しました。続けて、お子様の情報をご登録ください")

      # 登録画面の各項目を入力し、『更新』ボタンを押下
      User.find_by(name: "test_user2").children_number.times do |child|
        index = child + 1
        fill_in "birth_year_month_day_#{index}", with: 20250205
        fill_in "nursery_school_start_age_#{index}", with: 1
        fill_in "kindergarten_start_age_#{index}", with: 4
        select "公立", from: "select_nursary_#{index}"
        select "私立", from: "select_kindergarten_#{index}"
        select "私立", from: "select_primary_#{index}"
        select "私立", from: "select_junior_#{index}"
        select "公立", from: "select_high_#{index}"
        select "専門学校", from: "select_university_type_#{index}"
        select "私立", from: "select_university_manage_#{index}"
        select "理系", from: "select_university_major_#{index}"
        select "下宿なし", from: "select_university_boarding_#{index}"
      end

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする
      click_button '更新'

      sleep 10

      # 登録成功後、家計状況一覧画面への遷移と成功のメッセージを確認
      expect(page).to have_content("#{User.find_by(name: "test_user2").name}さんの家計状況一覧")
      expect(page).to have_content("アカウントと子どもの情報を登録しました")
            
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力が1つでも不足する場合、『登録する』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
            # アカウント登録画面で登録を行い、子どもの情報登録画面に遷移
            visit new_user_registration_path
            fill_in 'user_name', with: "test_user2"
            fill_in 'user_email', with: "test_user2@abc.com"
            fill_in 'user_password', with: "test_user2"
            fill_in 'user_password_confirmation', with: "test_user2"
            check 'user_admin'
            fill_in 'user_age', with: 25
            select 'あり', from: 'user_marital_status'
            fill_in 'user_spouse_age', with: 26
            fill_in 'user_children_number', with: 1
            click_button"登録"
      
            # 子どもの情報登録画面への遷移を確認
            expect(page).to have_content("子どもの情報登録")
            expect(page).to have_content("アカウントを作成しました。続けて、お子様の情報をご登録ください")
      
            # 生年月日（必須項目）以外の必須項目を入力し、『登録する』ボタンを押下
            User.find_by(name: "test_user2").children_number.times do |child|
              index = child + 1
              fill_in "birth_year_month_day_#{index}", with: ''
              fill_in "nursery_school_start_age_#{index}", with: 1
              fill_in "kindergarten_start_age_#{index}", with: 4
              select "公立", from: "select_nursary_#{index}"
              select "私立", from: "select_kindergarten_#{index}"
              select "私立", from: "select_primary_#{index}"
              select "私立", from: "select_junior_#{index}"
              select "公立", from: "select_high_#{index}"
              select "専門学校", from: "select_university_type_#{index}"
              select "私立", from: "select_university_manage_#{index}"
              select "理系", from: "select_university_major_#{index}"
              select "下宿なし", from: "select_university_boarding_#{index}"
            end
      
            # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
            page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
            # スクロール完了するまでの時間をsleepで確保
            sleep 5
            # スクロース後の画面から『登録する」ボタンを検索し、クリックする
            click_button '更新'
      
            sleep 10
      
            # 登録失敗後、画面遷移はせずに、エラのメッセージが表示されていることを確認
            expect(page).to have_content("子どもの情報登録")
            expect(page).to have_content("お子様の情報の入力値に誤りがあったため処理を中断しました。改めて正しくご入力ください")
      
    end
  end

  describe "子どもの情報編集画面" do

    it "（アクセス）ログインしていない状態で子どもの情報編集画面を表示しようとした場合、ログイン画面に遷移し、エラーメッセージが表示されること" do
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # ログアウト状態にする
      click_link('ログアウト')
      expect(page).to have_content("ログアウトしました。")

      # 子どもの情報編集画面を表示
      visit edit_child_path(user.children.first)
      expect(page).to have_content("ログイン")
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
    end

    it "（アクセス）本人以外の子どもの情報編集画面を表示しようとした場合、自身のユーザー編集画面に遷移し、エラーメッセージが表示されること" do
      # 事前に作成したuserとは別のユーザーを作成し、そのユーザーでログインする
      user2 = FactoryBot.create(:user,name: "test_user2", email: "test_user2@abc.com", password: "test_user2", password_confirmation: "test_user2")
      visit user_session_path
      fill_in 'メールアドレス', with: user2.email
      fill_in 'パスワード', with: 'test_user2'
      click_button"ログイン"

      # user2でログインした状態でuser（事前に作成したユーザー）が作成した資産状況編集画面を表示する
      visit edit_child_path(user.children.first)

      sleep 5

      # エラーメッセージが表示され、user2の資産状況詳細画面に遷移することを確認する
      expect(page).to have_content("子どもの情報を登録したユーザーと異なるため参照できません")
      expect(page).to have_content("ユーザー編集")
      # ユーザー編集画面に表示されている名前がログインユーザー（user2）であることを確認
      expect(find_field('名前').value).to eq user2.name
    end

    it "（CRUD機能、画面遷移テスト）成功-a.アカウント編集時に子どもの人数に変更がなかった場合：編集画面が表示され、入力必須項目の入力後『更新』ボタン押下すると、家計状況一覧画面に遷移し、登録成功のメッセージが表示されること" do
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

      # 編集画面のうち、生年月日のみを修正して、『更新』ボタンを押下
      User.find_by(name: "test_user").children_number.times do |child|
        index = child + 1
        fill_in "birth_year_month_day_#{index}", with: 20251225
      end

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする
      click_button '更新'

      sleep 10

      # 登録成功後、家計状況一覧画面への遷移と成功のメッセージを確認
      expect(page).to have_content("#{User.find_by(name: "test_user").name}さんの家計状況一覧")
      expect(page).to have_content("アカウントと子どもの情報を更新しました")
    end

    it "（CRUD機能、画面遷移テスト）成功-b.アカウント編集時に子どもの人数に変更があった場合：登録済みの子どもの情報はすべてDBから削除された状態で編集画面が表示され、入力必須項目の入力後『更新』ボタン押下すると、家計状況一覧画面に遷移し、登録成功のメッセージが表示されること" do
      # 事前登録をしているuserでログインをした上でアカウント編集画面を表示
      visit user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'test_user'
      click_button"ログイン"

      # アカウント編集画面を表示
      click_link('アカウント')
      expect(page).to have_content("ユーザー編集")

      # ユーザーに紐づく子どもの情報が人数分（1人）登録されていることを確認
      expect(user.children.all.length).to eq 1

      # ユーザー編集画面にて、子ども人数を1人→2人変更した上で『更新』ボタンを押下
      fill_in 'user_children_number', with: 2
      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする     
      click_button"更新"

      sleep 10
      

      # 入力項目がすべて空になった状態の編集画面が表示され、既存の子どもの情報が削除されたことを知らせるメッセージが表示されていることを確認
      expect(page).to have_content("子どもの情報編集")
      user.children_number.times do |child|
        index = child + 1
        expect(find("#birth_year_month_day_#{index}").value).to eq ""
        expect(find("#nursery_school_start_age_#{index}").value).to eq ""
        expect(find("#kindergarten_start_age_#{index}").value).to eq ""
      end
      expect(page).to have_content("お子様の人数に変更があったため、改めてすべてのお子様の情報をご登録ください")

      # ユーザーに紐づく子どもの情報がすべて削除されていることを確認
      expect(user.children.all.length).to eq 0


      # 編集画面の各項目を入力し、『更新』ボタンを押下
      User.find_by(name: "test_user").children_number.times do |child|
        index = child + 1
        fill_in "birth_year_month_day_#{index}", with: 20250205
        fill_in "nursery_school_start_age_#{index}", with: 1
        fill_in "kindergarten_start_age_#{index}", with: 4
        select "公立", from: "select_nursary_#{index}"
        select "私立", from: "select_kindergarten_#{index}"
        select "私立", from: "select_primary_#{index}"
        select "私立", from: "select_junior_#{index}"
        select "公立", from: "select_high_#{index}"
        select "専門学校", from: "select_university_type_#{index}"
        select "私立", from: "select_university_manage_#{index}"
        select "理系", from: "select_university_major_#{index}"
        select "下宿なし", from: "select_university_boarding_#{index}"
      end

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする
      click_button '更新'

      sleep 10

      # 登録成功後、家計状況一覧画面への遷移と成功のメッセージを確認
      expect(page).to have_content("#{User.find_by(name: "test_user").name}さんの家計状況一覧")
      expect(page).to have_content("アカウントと子どもの情報を登録しました")

      # 変更した通り、2人分の子どもの情報が保存されていることを確認
      expect(user.children.all.length).to eq 2
    end

    it "（CRUD機能、画面遷移テスト）入力必須項目の入力が1つでも不足する場合、『更新』ボタン押下すると、画面遷移はせずに、エラーメッセージが表示されること" do
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

      # 編集画面のうち、生年月日のみを空白として修正して、『更新』ボタンを押下
      User.find_by(name: "test_user").children_number.times do |child|
        index = child + 1
        fill_in "birth_year_month_day_#{index}", with: ""
      end

      # 既定の画面サイズにすべての要素が収まらず、『登録』ボタンが表示範囲外になってしまったためスクロース処理をする  
      page.execute_script('window.scrollTo(0, document.body.scrollHeight)')
      # スクロール完了するまでの時間をsleepで確保
      sleep 5
      # スクロース後の画面から『登録する」ボタンを検索し、クリックする
      click_button '更新'

      sleep 10

      # 登録失敗後、画面遷移はせずに、エラのメッセージが表示されていることを確認
      expect(page).to have_content("子どもの情報編集")
      expect(page).to have_content("編集されたお子様の情報に誤りがあったため処理を中断しました。改めて正しくご入力ください")
    end

  end

end
