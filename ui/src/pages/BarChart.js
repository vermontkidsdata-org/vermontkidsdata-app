import React, {useEffect, useState} from 'react'
import Highcharts from 'highcharts'
import HighchartsReact from 'highcharts-react-official'
import axios from 'axios'
import { useParams } from 'react-router-dom';
import { BarChartOptions } from './HighChartOptions';
//import {makeStyles} from "@material-ui/core/styles";

/*
const useStyles = makeStyles({
    root: {
        width: '100%',
    },
    container: {
        maxHeight: 440,
    },
});

 */

export default function BarChart() {

    //const classes = useStyles();
    const [options, setOptions] = useState({});
    const { id } = useParams();

    useEffect( () => {
        data();
    },[]);

    let data = async () => {

        let chartId = {id};
        let response = await axios.get(`https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/chart/bar/`+chartId.id);
        console.log(response.data);
        console.log(response.data.metadata.config.yAxis.type);       

        let options = {

            colors: ["#007155","#3b886e","#60a088","#84b8a3","#a7d0bf","#cae9dc","#007155","#3b886e",
                "#60a088","#84b8a3","#a7d0bf","#cae9dc","#e5f5e0","#c7e9c0","#a1d99b","#74c476","#41ab5d",
                "#238b45","#006d2c","#00441b","#ed7330", "#ed8751","#eb9a71","#e6ad90","#ddbfb0","#d1d1d1"],
            chart: {
                type: 'column'
            },
            title: {
                text: response.data.metadata.config.title
            },
            subtitle: {
                text: response.data.metadata.config.subtitle
            },
            series: response.data.series,
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                },
                series: {
                    dataLabels: {
                        enabled: true,
                        format: '{point.y:.1f}%'
                    }
                }
            },
            xAxis: {
                categories: response.data.categories,
                crosshair: true
            },
            yAxis: {
                min: 0,
                //max: 100,
                title: {
                    text: response.data.metadata.config.yAxis.title
                },
                labels: {
                    format: '{value:.0f}%'
                },
            }
        };

        let tooltip = {
            formatter: function () {
                return 'The value for <b>' + this.x +
                    '</b> is <b>' + this.y + '</b>';
            }
        };
        options.tooltip = tooltip;

        
        setOptions(options);

    }

    return (
        <div>
            <HighchartsReact
                highcharts={Highcharts}
                options={options}
            />
        </div>
    );
}




