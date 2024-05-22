import Rails from "@rails/ujs"
$(function(){
    // 資産状況の登録画面の「登録」もしくは「更新」ボタンが押下されたときの処理で、以下(1)~(2)を順番に実行
    $('#children_submit_btn').on("click",function(){

        // (1)6種類の教育機関別に教育方針（公立／私立など）を入力したフォームを順番に送信
        function submit_education_expense_id_search_form(){
            var forms = $('.education_expense_id_search_form');
            return new Promise((resolve) => {
                for(var i=0; i<forms.length; i++){
                    Rails.fire(forms[i],'submit');
                    if(i == length){
                        resolve();
                    }
                }
    
            })
        };

        // (2)(1)の処理が終わったら子どもの情報を入力したフォームを送信（※submitメソッドではremote:trueが実現できないため、fireメソッドを利用）
        submit_education_expense_id_search_form()
        .then(function(){
            setTimeout(function(){
                var child_forms = $('.child_create_form');
                for(var i=0; i<child_forms.length; i++){
                    Rails.fire(child_forms[i], 'submit');}
            },2000);
        })

        console.log("処理完了");

    });

})
