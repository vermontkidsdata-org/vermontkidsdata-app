# `queries` table row for tsgold chart
INSERT INTO `` (`id`,`name`,`sqlText`,`columnMap`,`metadata`,`uploadType`,`filters`) VALUES (596,'tsgold:chart','SELECT `year` as `cat`, category as `label`, geography, `value`*100 as `value` FROM data_tsgold where `geography`=\"Vermont\" and `age`=4 order by `year`',NULL,'{\"yAxis\": {\"type\": \"percent\"}}','general:tsgold',NULL);

## Example output
{
    "metadata": {
        "config": {
            "yAxis": {
                "type": "percent"
            }
        },
        "uploadType": "general:tsgold"
    },
    "series": [
        {
            "name": "Social Emotional",
            "data": [
                86.00000143051147,
                87.00000047683716,
                87.00000047683716,
                88.99999856948853,
                87.00000047683716,
                87.99999952316284,
                89.99999761581421
            ]
        },
        {
            "name": "Literacy",
            "data": [
                91.00000262260437,
                92.00000166893005,
                89.99999761581421,
                91.00000262260437,
                91.00000262260437,
                91.00000262260437,
                92.00000166893005
            ]
        },
        {
            "name": "Math",
            "data": [
                83.99999737739563,
                85.00000238418579,
                83.99999737739563,
                86.00000143051147,
                86.00000143051147,
                87.00000047683716,
                87.99999952316284
            ]
        }
    ],
    "categories": [
        2018,
        2019,
        2020,
        2021,
        2022,
        2023,
        2024
    ]
}