import React from 'react'
import { render } from 'react-dom'
import Highcharts from 'highcharts'
import HighchartsReact from 'highcharts-react-official'
import axios from 'axios'

class HighChart extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            error: null,
            isLoaded: false,
            options: {}
        };
    }

    componentDidMount() {
        console.log('chart mounted');
        var self = this;
        axios.get('https://ys86tlq820.execute-api.us-east-1.amazonaws.com/prod/chart/bar/57').then( function(res) {
            console.log(res.data);
            self.setState({
                isLoaded: true,
                options: {
                    colors: ["#007155","#3b886e","#60a088","#84b8a3","#a7d0bf","#cae9dc","#007155","#3b886e",
                        "#60a088","#84b8a3","#a7d0bf","#cae9dc","#e5f5e0","#c7e9c0","#a1d99b","#74c476","#41ab5d",
                        "#238b45","#006d2c","#00441b","#ed7330", "#ed8751","#eb9a71","#e6ad90","#ddbfb0","#d1d1d1"],
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: 'Reading Proficiency at the End of Third Grade'
                    },
                    subtitle: {
                        text: 'Source: Vermont Department of Education'
                    },
                    series: res.data.series,
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
                        categories: [ '2021'],
                        crosshair: true
                    },
                    yAxis: {
                        min: 0,
                        max: 100,
                        title: {
                            text: 'Percent'
                        },
                        labels: {
                            format: '{text}%'
                        },
                    }
                }
            })
        });

        //this.setState();
    }

    render() {

        console.log('rendered');

        return (
            <div>
                <HighchartsReact
                    highcharts={Highcharts}
                    options={this.state.options}
                />
            </div>
        )
    }
}

export default HighChart;