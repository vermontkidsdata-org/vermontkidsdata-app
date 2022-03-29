import { makeStyles } from '@material-ui/core/styles';
import clsx from 'clsx';
import InputLabel from '@material-ui/core/InputLabel';
import MenuItem from '@material-ui/core/MenuItem';
import FormHelperText from '@material-ui/core/FormHelperText';
import FormControl from '@material-ui/core/FormControl';
import TextField from '@material-ui/core/TextField';
import Select from '@material-ui/core/Select';
import React, {useState, useEffect} from 'react';
import SearchIcon from '@material-ui/icons/Search';
import InputAdornment from '@material-ui/core/InputAdornment';
import Button from '@material-ui/core/Button';
import axios from "axios";
import {DataGrid, GridToolbarContainer, GridToolbarExport} from "@mui/x-data-grid";
import {ThreeDots} from 'react-loader-spinner';

const useStyles = makeStyles((theme) => ({
    container: {
        display: "flex",
        flexDirection: "column",
        justifyContent: "center"
    },
    formControl: {
        margin: theme.spacing(1),
        minWidth: 120,
    },
    selectEmpty: {
        marginTop: theme.spacing(2),
    },
    textField: {
        width: 400,
        margin: theme.spacing(1),
    },
    searchBtn: {
        width: 400
    }
}));

//utility functions to translate Material UI Table columns and rows to the structure required for DataGrid
function prepareColumns(columns){
    let cols = [];
    for(let i = 0; i < columns.length; i++ ){
        let column = columns[i];
        column.field = column.id;
        column.headerName = column.label;
        column.flex = 1;
        cols.push(column);
    }
    return cols;
}
function prepareRows(rows){
    let r = [];
    console.log('preparing rows', rows);
    //rows need a unique ID to maintain React state
    for(let i = 0; i < rows.length; i++ ){
        let row = rows[i];
        row.id = i;
        r.push(row);
    }
    return r;
}

function CustomToolbar() {
    return (
        <GridToolbarContainer>
            <GridToolbarExport />
        </GridToolbarContainer>
    );
}

export default function Census() {

    const classes = useStyles();
    const [geography, setGeography] = useState('state');
    const [searchText, setSearchText] = useState('');
    const [tables, setTables] = useState([]);
    const [table, setTable] = useState('');
    const [rows, setRows] = useState([]);
    const [columns, setColumns] = useState([]);
    const [loading, setLoading] = useState(false);

    const handleGeoChange = (event) => {
        setGeography(event.target.value);
    };

    const handleSearchText = (event) => {
        setSearchText(event.target.value);
    };

    const handleTableChange = (event) => {
        setTable(event.target.value);
    };

    const searchTables = async () => {
        setLoading(true);
        let search = {searchText};
        console.log('searching', search);
        //let response = await axios.get(`https://data.vermontkidsdata.org/v1/search_concepts/`+search.searchText);
        let response = await axios.get('https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/codes/census/tables/search?concept='+search.searchText);
        console.log(response.data);
        let tables = response.data.tables;
        setTables(response.data.tables);
        setTable(tables[0].table);
        setLoading(false);
    };

    const getCensusData = async () => {
        //console.log('getting data', {table});
        setLoading(true);
        let table = 'B09001';
        let geo = {geography};
        console.log(geo);
        let response = await axios.get(`https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/table/census/`+table+`/`+geo.geography);
        console.log(response.data);
        let columns = response.data.columns;
        columns = prepareColumns(columns);
        let rows = response.data.rows;
        rows = prepareRows(rows);
        setRows(rows);
        setColumns(columns);
        setLoading(false);

    };

    console.log({geography});

    return (

        <div className={clsx(classes.container)} >
            <div><h3>US Census Bureau</h3></div>
            <div>
            <TextField
                className={classes.textField}
                onChange={handleSearchText}
                id="search-text"
                label="Tables"
                InputProps={{
                    endAdornment: (
                        <InputAdornment position="end">
                            <SearchIcon />
                        </InputAdornment>
                    ),
                }}
            /></div>
    <div><Button variant="contained" color="primary" className={classes.searchBtn} onClick={searchTables}>Search Tables</Button></div>
            <div>
                <TextField
                    id="table"
                    label="Table"
                    select
                    value={table}
                    onChange={handleTableChange}
                    className={classes.textField} >
                    {tables.map((option) => (
                        <MenuItem key={option.table} value={option.table}>
                            {option.table} {option.concept}
                        </MenuItem>
                    ))}
                </TextField>
            </div>
            <div>
            <FormControl className={clsx(classes.formControl, classes.textField)} >
                <InputLabel id="geo-label">Geography</InputLabel>
                <Select
                    labelId="geo-label"
                    id="geography"
                    value={geography}
                    onChange={handleGeoChange}
                >
                    <MenuItem value={'state'}>State</MenuItem>
                    <MenuItem value={'county'}>County</MenuItem>
                </Select>
            </FormControl>
            </div>
            <div><Button variant="contained" color="primary" className={classes.searchBtn} onClick={getCensusData}>Get Data</Button></div>
            <div style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
            }}>
                {loading ? <ThreeDots color="#2BAD60" height="100" width="100" /> : <div></div> }

            </div>
            <div style={{ height: 600, width: '100%', marginTop: '2em' }}>
                <DataGrid
                    columns={columns}
                    rows={rows}
                    components = {{
                        Toolbar: CustomToolbar,
                    }}
                />
            </div>
        </div>
    )

}