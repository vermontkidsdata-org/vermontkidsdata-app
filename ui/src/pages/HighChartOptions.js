

        export var BarChartOptions = {

            colors: ["#007155","#3b886e","#60a088","#84b8a3","#a7d0bf","#cae9dc","#007155","#3b886e",
                "#60a088","#84b8a3","#a7d0bf","#cae9dc","#e5f5e0","#c7e9c0","#a1d99b","#74c476","#41ab5d",
                "#238b45","#006d2c","#00441b","#ed7330", "#ed8751","#eb9a71","#e6ad90","#ddbfb0","#d1d1d1"],
            chart: {
                type: 'column'
            },
            title: {
                text: ''
            },
            subtitle: {
                text: ''
            },
            series: [],
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                },
                series: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
            xAxis: {
                categories: [],
                crosshair: true
            },
            yAxis: {
                min: 0,
                //max: 100,
                title: {
                    text: ''
                },
                labels: {
                    format: '{value:.0f}%'
                },
            }
        };

        