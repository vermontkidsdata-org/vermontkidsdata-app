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

function CustomToolbar() {
    return (
        <GridToolbarContainer>
            <GridToolbarExport />
        </GridToolbarContainer>
    );
}

export default function Census() {

    const classes = useStyles();
    const [geo, setGeo] = useState('state');
    const [searchText, setSearchText] = useState('');
    const [tables, setTables] = useState([]);
    const [table, setTable] = useState('');
    const [rows, setRows] = useState([]);
    const [columns, setColumns] = useState([]);

    const handleGeoChange = (event) => {
        setGeo(event.target.value);
    };

    const handleSearchText = (event) => {
        setSearchText(event.target.value);
    };

    const handleTableChange = (event) => {
        setTable(event.target.value);
    };

    const searchTables = async () => {
        let search = {searchText};
        console.log('searching', search);
        let response = await axios.get(`https://data.vermontkidsdata.org/v1/search_concepts/`+search.searchText);
        console.log(response.data);
        let tables = response.data;
        setTables(response.data);
        setTable(tables[0].group);
    };

    const getCensusData = async () => {
        //console.log('getting data', {table});
        let table = 'B09001';
        let geo = 'state';
        let response = await axios.get(`https://jwzzquhd03.execute-api.us-east-1.amazonaws.com/prod/table/census/`+table+`/`+geo);
        console.log(response.data);

    };

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
                        <MenuItem key={option.group} value={option.group}>
                            {option.group} {option.concept}
                        </MenuItem>
                    ))}
                </TextField>
            </div>
            <div>
            <FormControl className={clsx(classes.formControl, classes.textField)} >
                <InputLabel id="geo-label">Geography</InputLabel>
                <Select
                    labelId="geo-label"
                    id="geo"
                    value={geo}
                    onChange={handleGeoChange}
                >
                    <MenuItem value={'state'}>State</MenuItem>
                    <MenuItem value={'county'}>County</MenuItem>
                </Select>
            </FormControl>
            </div>
            <div><Button variant="contained" color="primary" className={classes.searchBtn} onClick={getCensusData}>Get Data</Button></div>
            <div style={{ height: 300, width: '100%', marginTop: '2em' }}>
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