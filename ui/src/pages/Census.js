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
import Layout from "./Layout";

const useStyles = makeStyles((theme) => ({
    rowContainer: {
        display: "flex",
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "flex-start"
    },
    colContainer: {
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",

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
        width: 170,
        backgroundColor: "#007155"
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
    const [variable, setVariable] = useState([]);
    const [variables, setVariables] = useState([]);
    const [dataset, setDataset] = useState("acs/acs5");
    const [year, setYear] = useState('2020');

    const handleDatasetChange = (event) => {
        setDataset(event.target.value);
    };

    const handleGeoChange = (event) => {
        setGeography(event.target.value);
    };

    const handleSearchText = (event) => {
        setSearchText(event.target.value);
    };

    const handleTableChange = async (event) => {
        setTable(event.target.value);
        //console.log(event.target.value);
        let vars = await axios.get(`https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/codes/census/variables/`+event.target.value);
        //console.log('VARIABLES', vars.data);
        setVariables(vars.data.variables);
    };

    const handleYearChange = (event) => {
        setYear(event.target.value);
    };

    const handleVariableChange = (event) => {
        const { options } = event.target;
        const value = [];
        for (let i = 0, l = options.length; i < l; i += 1) {
            if (options[i].selected) {
                value.push(options[i].value);
            }
        }
        setVariable(value);
    };

    const searchTables = async () => {
        setLoading(true);
        let search = {searchText};
        //console.log('searching', search);
        //let response = await axios.get(`https://data.vermontkidsdata.org/v1/search_concepts/`+search.searchText);
        let response = await axios.get('https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/codes/census/tables/search?concept='+search.searchText);
       //console.log(response.data);
        let tables = response.data.tables;
        //once we get the tables, search the variables
        //let response = await axios.get('https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/codes/census/tables/search?concept='+search.searchText);
        // let concept = 'POPULATION%20UNDER%2018%20YEARS%20BY%20AGE';
        let censusTable = response.data.tables[0].table;
        console.log('table', censusTable);
        let vars = await axios.get(`https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/codes/census/variables/`+censusTable);
        //console.log('VARIABLES', vars.data);
        setTables(response.data.tables);
        setTable(tables[0].table);
        setVariables(vars.data.variables);
        setLoading(false);
    };

    const getCensusData = async () => {
        //console.log('getting data', {table});
        setLoading(true);
        let table = 'B09001';
        let geo = {geography};
        console.log('SEARCH TABLE', {table});
        console.log('YEAR', {year});
        console.log('VARIABLES', String({variable}.variable));
        //B09001/bbf_region?year=2018&variables=B09001_003E
        let endpoint = {table}.table+'/'+{geography}.geography+'?dataset='+{dataset}.dataset+'&year='+{year}.year+'&variables='+{variable}.variable;
        console.log(endpoint);
        let response = await axios.get(`https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/table/census/`+endpoint);
        console.log(response.data);
        let columns = response.data.columns;
        columns = prepareColumns(columns);
        let rows = response.data.rows;
        rows = prepareRows(rows);
        setRows(rows);
        setColumns(columns);
        setLoading(false);

    };

    //console.log({geography});

    return (
        <div className={clsx(classes.colContainer)} >
            <Layout/>
            <div><h3>US Census Bureau</h3></div>
            <div>
                <div className={clsx(classes.rowContainer)}>
                    {/*input column 1*/}
                    <div className={clsx(classes.colContainer)} >
                        <div>
                            <FormControl className={clsx(classes.formControl, classes.textField)} >
                                <InputLabel id="dataset-label">Dataset</InputLabel>
                                <Select
                                    labelId="dataset-label"
                                    id="dataset"
                                    value={dataset}
                                    onChange={handleDatasetChange}
                                >
                                    <MenuItem value={'acs/acs1'}>American Community Survey (ACS) 1 Year</MenuItem>
                                    <MenuItem value={'acs/acs3'}>American Community Survey (ACS) 3 Year</MenuItem>
                                    <MenuItem value={'acs/acs5'}>American Community Survey (ACS) 5 Year</MenuItem>
                                </Select>
                            </FormControl>
                        </div>
                        <div>
                            <FormControl className={clsx(classes.formControl, classes.textField)} >
                                <InputLabel id="year-label">Year</InputLabel>
                                <Select
                                    labelId="year-label"
                                    id="year"
                                    value={year}
                                    onChange={handleYearChange}
                                >
                                    <MenuItem value={'2020'}>2020</MenuItem>
                                    <MenuItem value={'2019'}>2019</MenuItem>
                                    <MenuItem value={'2018'}>2018</MenuItem>
                                    <MenuItem value={'2017'}>2017</MenuItem>
                                    <MenuItem value={'2016'}>2016</MenuItem>
                                    <MenuItem value={'2015'}>2015</MenuItem>
                                    <MenuItem value={'2014'}>2014</MenuItem>
                                    <MenuItem value={'2013'}>2013</MenuItem>
                                    <MenuItem value={'2012'}>2012</MenuItem>
                                    <MenuItem value={'2011'}>2011</MenuItem>
                                    <MenuItem value={'2010'}>2010</MenuItem>
                                    <MenuItem value={'2009'}>2009</MenuItem>
                                </Select>
                            </FormControl>
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
                                    <MenuItem value={'bbf_region'}>BBF Region</MenuItem>
                                    <MenuItem value={'ahs_district'}>AHS District</MenuItem>
                                    <MenuItem value={'head_start'}>Head Start Region</MenuItem>
                                </Select>
                            </FormControl>
                        </div>

                    </div>
                    {/*input column 2*/}
                    <div>
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
                                <InputLabel shrink htmlFor="var">Variables</InputLabel>
                                <Select
                                    native
                                    multiple
                                    id="variable"
                                    value={variable}
                                    onChange={handleVariableChange}
                                    inputProps={{
                                        id: 'var',
                                    }}
                                >
                                    {variables.map((v) => (
                                        <option key={v.variable} value={v.variable}>
                                            {v.label}
                                        </option>
                                    ))}
                                </Select>
                            </FormControl>
                        </div>

                        <div><Button variant="contained" color="primary" className={classes.searchBtn} onClick={getCensusData}>Get Data</Button></div>
                    </div>
                </div>
            </div>
            {/*data grid*/}
            <div>
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
        </div>
    )

}