import { DataGrid, GridToolbarContainer, GridToolbarExport } from '@mui/x-data-grid';
import { useDemoData } from '@mui/x-data-grid-generator';
import { useParams } from 'react-router-dom';
import axios from "axios";
import {useEffect, useState} from "react";

function CustomToolbar() {
    return (
        <GridToolbarContainer>
            <GridToolbarExport />
        </GridToolbarContainer>
    );
}

//utility functions to translate Material UI Table columns and rows to the structure required for DataGrid
function prepareColumns(columns){
    let cols = [];
    for(let i = 0; i < columns.length; i++ ){
        let column = columns[i];
        column.field = column.id;
        column.flex = 1;
        cols.push(column);
    }
    return cols;
}

function prepareRows(rows){

}

export default function MaterialDataGrid() {

    const [rows, setRows] = useState([]);
    const [columns, setColumns] = useState([]);
    const { id } = useParams();

    useEffect( () => {
        data();
    },[]);

    let data = async () => {

        let tableId = {id};
        let response = await axios.get(`https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/table/table/`+tableId.id);
        console.log(response.data);
        let data = {};
        let columns = response.data.columns;
        columns = prepareColumns(columns);
        console.log(columns);
        let rows = response.data.rows;
        setRows(rows);
        setColumns(columns);

    }

    return (
        <div style={{ height: 300, width: '100%' }}>
            <DataGrid
                columns={columns}
                rows={rows}
                components = {{
                    Toolbar: CustomToolbar,
                }}
            />
        </div>
    );
}