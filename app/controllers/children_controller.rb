class ChildrenController < ApplicationController
    before_action :authenticate_user!

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
        # create.js.erbではログインユーザーの’すべての’child情報保存後にproperty情報をsubmitする処理をする
        # 複数名子どものがいる場合を考慮し、「すべて」のchild情報が登録されたことを認識するために各childのフォームに保存確認用のフィールドを設け、
        # 　保存結果を@save_successに格納→(create.js.erbで)childフォームに反映し、すべてのchildフォームの保存確認用フィールドを確認→すべてが「true」になったらpropertyフォーム送信、という処理を行う

        # 何番目の子供の保存結果かを特定するためにbirth_orderをインスタンス変数に格納
        @birth_order = (params[:child][:birth_order]).to_i;
    
        # 保存が成功したか否かをインスタンス変数に格納
        if @child.save
            @save_success = true
        else 
            @save_success = false
        end
        binding.pry
    end

    # 子どもの（Childモデル）と子どもの教育方針（ChildEducationモデル）の情報を更新する処理
    # 処理内容はcreateアクションと同じ
    def update
        binding.pry
        @child = current_user.children.find(params[:id]).update(children_params);
        binding.pry
        @birth_order = (params[:child][:birth_order]).to_i;
        if @child
            @save_success = true
        else 
            @save_success = false
        end
    end
    
    private

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
