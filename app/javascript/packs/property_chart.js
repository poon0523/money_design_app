import Chart from 'chart.js/auto'
import Rails from "@rails/ujs"

$(function(){
  // 資産状況の詳細画面-（ベストケース用）テーブルのレイアウトとしてカテゴリごとにセルを自動結合する処理
  const using_property_count_for_best = $('th[data-model = "major_classification_for_best_case"]').filter(function() { return $(this).text() === '使用資産'; }).length;
  const loan_count_for_best = $('th[data-model = "major_classification_for_best_case"]').filter(function() { return $(this).text() === 'ローン'; }).length;
  // const other_count_for_best = $('th[data-model = "major_classification_for_best_case"]').filter(function() { return $(this).text() === '教育費'; }).length;
      
  $('th[data-model = "major_classification_for_best_case"]').get(0).rowSpan = using_property_count_for_best;
  $('th[data-model = "major_classification_for_best_case"]').get(using_property_count_for_best).rowSpan = loan_count_for_best;
  // $('th[data-model = "major_classification_for_best_case"]').get(using_property_count_for_best+loan_count_for_best).rowSpan = other_count_for_best;
  $('th[data-model = "major_classification_for_best_case"]:not([rowspan])').remove();

    // 資産状況の詳細画面-（ワーストケース用）テーブルのレイアウトとしてカテゴリごとにセルを自動結合する処理
    const using_property_count_for_worst = $('th[data-model = "major_classification_for_worst_case"]').filter(function() { return $(this).text() === '使用資産'; }).length;
    const loan_count_for_worst = $('th[data-model = "major_classification_for_worst_case"]').filter(function() { return $(this).text() === 'ローン'; }).length;
    // const other_count_for_worst = $('th[data-model = "major_classification_for_worst_case"]').filter(function() { return $(this).text() === '教育費'; }).length;
        
    $('th[data-model = "major_classification_for_worst_case"]').get(0).rowSpan = using_property_count_for_worst;
    $('th[data-model = "major_classification_for_worst_case"]').get(using_property_count_for_worst).rowSpan = loan_count_for_worst;
    // $('th[data-model = "major_classification_for_worst_case"]').get(using_property_count_for_worst+loan_count_for_worst).rowSpan = other_count_for_worst;
    $('th[data-model = "major_classification_for_worst_case"]:not([rowspan])').remove();
  

  // 資産状況の詳細画面-折れ線グラフを作成する処理
  var initial_chart

  (async function() {
    var chart_label_dataset = ($('.chart_label_data').map(function(){
      return $(this).val()
    })).get();
    var chart_best_net_property = ($('input[data-model = "best_net_property"]').map(function(){
      return $(this).val()
    })).get();
    var chart_worst_net_property = ($('input[data-model = "worst_net_property"]').map(function(){
      return $(this).val()
    })).get();
    
    initial_chart = new Chart(
      $('#property_chart'),
        {
          type: 'line',
          data: {
            labels: chart_label_dataset,
            datasets: [
              {
                label: 'ベスト-純資産',
                data: chart_best_net_property,
              },
              {
                label: 'ワースト-純資産',
                data: chart_worst_net_property                  
              }
            ]
          }
        }
      );
    })();

  // 資産状況の詳細画面-調整項目の入力時にグラフを更新する処理
  $('input[data-model = "adjust"]').on("change", function(){
    initial_chart.destroy();
    Rails.fire($('#adjust_input_form')[0],'submit');
  });    

})
