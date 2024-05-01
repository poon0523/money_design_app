$(function(){

    // 家計状況の詳細画面-収支比率がNaN%→0%にする処理
    $('td[data-model="present_balance_ratio"]').each(function(){
        if($(this).text() == "NaN%"){
            $(this).text("0%")
        }
    })

    // 家計状況の詳細画面-家計状況の金額の値を調整版作成フォームの各種入力項目に入力する処理
    let ideal_revenue_expense_lists = $('input[data-model="input"]').map(function(){
        return $(this).val();
        });

    $('input[data-model="ideal_household_form"]').each(function(index){
        let ideal_revenue_expense_each_amount = ideal_revenue_expense_lists.get(index)
        $(this).val(ideal_revenue_expense_each_amount);})

    // 家計状況の詳細画面-各収支項目の収支比率の計算処理
    $('input[data-model = "input"').on("keyup", function(){
        let ideal_revenue = $('#revenue').val(); 
        let ideal_revenue_expense_lists = $('input[data-model="input"]').map(function(){
            return $(this).val();
            });
        let balance_ratio_lists = $('input[data-model="input"]').map(function(){
            return $(this).val()/ideal_revenue*100;
            });


        $('input[data-model="ideal_household_form"]').each(function(index){
            let ideal_revenue_expense_each_amount = ideal_revenue_expense_lists.get(index)
            $(this).val(ideal_revenue_expense_each_amount);})


        $('p[data-model="balance_ratio"]').each(function(index){
            let balance_ratio = balance_ratio_lists.get(index);
            if(isNaN(balance_ratio)){
                $(this).html(0+"%")
            } else {
                $(this).html(Math.round((balance_ratio*100))/100+"%")
            }
        })
    });

    // 家計状況の詳細画面-テーブルのレイアウトとして収支項目のカテゴリ分類ごとにセルを結合する処理
    const revenueCount = $('th[data-model = "major_classification"]').filter(function() { return $(this).text() === '収入'; }).length;
    const fixedCount = $('th[data-model = "major_classification"]').filter(function() { return $(this).text() === '固定費'; }).length;
    const variableCount = $('th[data-model = "major_classification"]').filter(function() { return $(this).text() === '変動費'; }).length;
    
    $('th[data-model = "major_classification"]').get(0).rowSpan = revenueCount;
    $('th[data-model = "major_classification"]').get(revenueCount).rowSpan = fixedCount;
    $('th[data-model = "major_classification"]').get(revenueCount+fixedCount).rowSpan = variableCount;
    $('th[data-model = "major_classification"]:not([rowspan])').remove();


    // 家計状況の詳細画面-各収支項目の収支比率が基準値よりも大きい場合に収支比率の文字色を赤にする処理
    let present_balance_ratio_list = $('td[data-model="present_balance_ratio"]').map(function(){
        return $(this).text();});
    let standard_balance_ratio_list = $('td[data-model="standard_balance_ratio"]').map(function(){
        return $(this).text();});

    $('td[data-model="present_balance_ratio"]').each(function(index,element){
        let present_balance_ratio = parseFloat(present_balance_ratio_list.get(index));
        let standard_balance_ratio = parseFloat(standard_balance_ratio_list.get(index));
        if (present_balance_ratio>standard_balance_ratio){
            element.style.color = "red";
        };
    });


})
