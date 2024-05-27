class ChildrenController < ApplicationController
    before_action :authenticate_user!
    before_action :get_created_children, only: %i[ edit ]
    before_action :correct_user_for_edit, only: %i[ edit ] 
    before_action :get_created_children, only: %i[ destroy_for_fail_save ]

    def new
        # 子どもの人数分のChildインスタンス作成し、配列としてインスタンス変数に格納
        @children = Child.create_child_and_children_education_instances(current_user)
        @destroy_target = true
    end

    def edit
        # 子どもの情報登録時の子どもの人数と更新したユーザー情報の子どもの人数が一致する場合
        if current_user.children.all.length == current_user.children_number
            @children = current_user.children.all.order("birth_order ASC")
            @destroy_target = false
            flash.now[:notice] = 'アカウントを更新しました。続けて、お子様の情報に更新があれば修正ください'
        # 子どもの情報登録時の子どもの人数と更新したユーザー情報の子どもの人数が一致しない場合
        else
            # 登録済みの子どもの情報はテーブルから削除する
            current_user.children.all.each do |child|
                child.destroy
            end
            # 再登録用に改めて子どもの人数分のインスタンスを作成
            @children = Child.create_child_and_children_education_instances(current_user)
            @destroy_target = true 
            flash.now[:notice]  = "お子様の人数に変更があったため、改めてすべてのお子様の情報をご登録ください"
        end
    end

    # 資産状況の登録画面にて入力した子供の教育方針と合致する教育費用を教育費マスタ（EducationExpense）から抽出する処理
    # getメソッド、かつremote:trueでリクエストを受け取るため、「search_education_expense.js.erb」がレスポンスとしてレンダリングされる
    def search_education_expenses

        # 以下(1)~(3)にてデータを抽出

        # (1)何人目の子供の情報かをインスタンス変数に格納
        @birth_order = params[:birth_order]

        # (2)教育方針と合致する教育費マスタのidを格納するフィールドの場所をインスタンス変数に格納
        @education_expense_id_field_index = params[:education_expense_id_field_index]


        # (3)教育機関別に教育方針と合致する教育費マスタのidを抽出し、教育機関別のインスタンス変数に格納
        search_result = EducationExpense.refer_education_expenses_master(params[:education_institution_type],params[:management_organization],params[:university_major],params[:boarding_house])
        
        # a.保育園（education_institution_type=1）の教育費
        if params[:education_institution_type] == "1"
            @nursery_expense_id = search_result

        # b.幼稚園（education_institution_type=2）の教育費抽出
        elsif params[:education_institution_type] == "2"
            @kindergarten_expense_id = search_result
        
        # c.小学校（education_institution_type=3）の教育費抽出        
        elsif params[:education_institution_type] == "3"
            @primary_school_expense_id = search_result

        # e.中学校（education_institution_type=4）の教育費抽出
        elsif params[:education_institution_type] == "4"
            @junior_high_school_expense_id = search_result

        # f.高校（education_institution_type=5）の教育費抽出
        elsif params[:education_institution_type] == "5"
            @high_school_expense_id = search_result
        
        # g.大学以降（education_institution_type=6）の教育費抽出
        elsif params[:education_institution_type] >= "6"
            @university_expense_id = search_result
        end
    end

    # 子どもの（Childモデル）と子どもの教育方針（ChildEducationモデル）の情報を登録する処理
    # remote:trueでリクエストを受け取るため「create.js.erb」がレスポンスとしてレンダリングされる
    def create
        @child = current_user.children.new(children_params);

        # 以下はcreate.js.erbで必要となるインスタンスの定義
        # create.js.erbでは複数名子どものがいる場合を考慮し、「すべて」のchild情報が登録されたことを認識するために各childのフォームに保存確認用のフィールドを設け、
        # 保存結果を@save_successに格納→(create.js.erbで)childフォームに反映し、すべてのchildフォームの保存確認用フィールドを確認→すべてが「true」になったら家計状況一覧画面に遷移、という処理を行う

        # 何番目の子供の保存結果かを特定するためにbirth_orderをインスタンス変数に格納
        @birth_order = (params[:child][:birth_order]).to_i;

    
        # 保存が成功したか否かをインスタンス変数に格納
        if @child.save
            @save_success = true
        else 
            @save_success = false
        end
    end

    # 子どもの（Childモデル）と子どもの教育方針（ChildEducationモデル）の情報を更新する処理
    # 処理内容はcreateアクションと同じ
    def update
        @child = current_user.children.find(params[:id]).update(children_params);
        @birth_order = (params[:child][:birth_order]).to_i;
        if @child
            @save_success = true
        else 
            @save_success = false
        end
    end


    # 1ユーザーにつき複数名の子どもの情報をcreateもしくはupdateする際に1人でも処理に失敗した場合に、それまでの処理を削除するための処理
    # 本処理でユーザーの持つすべての子どもの情報を削除するか否かを判別するため、newアクション、editアクションで@destroy_targetフラグを持たせている
    # @destroy_target=trueの場合、ユーザーが持つすべての子どもの情報を削除する
    def destroy_for_fail_save
        if params[:destroy_target] == "true"
            if @children.present?
                @children.each do |child|
                    child.destroy
                end
            end
            redirect_to new_child_path, notice: "お子様の情報の入力値に誤りがあったため処理を中断しました。改めて正しくご入力ください"
        else
            flash[:notice] = "編集されたお子様の情報に誤りがあったため処理を中断しました。改めて正しくご入力ください"
            render :edit
        end
    end

    
    private

    def get_created_children
        if current_user.children.present?
            @children = current_user.children.all
        end
    end

    def set_child
        @child = current_user.children.first
    end

    def correct_user_for_edit
        if !(Child.find(params[:id]).user == current_user)
            redirect_to edit_user_registration_path, notice: "子どもの情報を登録したユーザーと異なるため参照できません" 
        end
    end 

    def children_params
        params.require(:child).permit(
            :birth_order,
            :birth_year_month_day,
            :nursery_school_start_age,
            :kindergarten_start_age,
            child_educations_attributes: [:child_id, :education_expense_id, :id]
            )
    end

end
