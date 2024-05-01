import Chart from 'chart.js/auto'
import Rails from "@rails/ujs"
$(function(){
  var summary_chart
    // var data_set_for_chart = $('.data_set_for_chart').val();
    // console.log(data_set_for_chart);

    // new Chart (
    //     $('#property_chart'), {
    //         type: 'bar',
    //         data: {
    //             labels: data_set_for_chart.map(row => row.year),
    //             datasets: [{
    //                 label: "総資産",
    //                 data: data_set_for_chart.map(row => row.total_property),
    //             }]
    //         }
    //     }
    // );


    (async function() {
      var chart_label_dataset = ($('.chart_label_data').map(function(){
        return $(this).val()
      })).get();
      var chart_total_property = ($('input[data-model = "total_property"]').map(function(){
        return $(this).val()
      })).get();
      var chart_total_liability = ($('input[data-model = "total_liability"]').map(function(){
        return $(this).val()
      })).get();
      var chart_net_property = ($('input[data-model = "net_property"]').map(function(){
        return $(this).val()
      })).get();


        // const data_set_for_chart = $('.data_set_for_chart').val();
        // console.log(typeof(data_set_for_chart));
        // console.log(data_set_for_chart.split(','));
        // const labels = data_set_for_chart.get("year");
        // const total_property = data_set_for_chart.get("total_property");
        console.log(chart_label_dataset);
        console.log(chart_total_property);
      
        summary_chart = new Chart(
            $('#property_chart'),
          {
            type: 'line',
            data: {
              labels: chart_label_dataset,
              datasets: [
                {
                  label: '総資産',
                  type: 'bar',
                  data: chart_total_property,
                },
                {
                  label: '総負債',
                  type: 'bar',
                  data: chart_total_liability                  
                },
                {
                  label: '純資産',
                  data: chart_net_property
                }
              ]
            }
          }
        );
      })();

  $('input[data-model = "adjust"]').on("change", function(){
    Rails.fire($('#adjust_input_form')[0],'submit');
  });
    

})
