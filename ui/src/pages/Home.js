import {Link, Outlet} from "react-router-dom";
import React from "react";
import Layout from "./Layout";
import Imports from "./Imports";
import MaterialDataGrid from "./MaterialDataGrid";

import {
    AppBar,
    Toolbar,
    CssBaseline,
    Typography,
    makeStyles,
} from "@material-ui/core";

const useStyles = makeStyles((theme) => ({
    appBar: {
        backgroundColor: "#007155"
    },
    navlinks: {
        marginLeft: theme.spacing(10),
        display: "flex",
        backgroundColor: "#007155"
    },
    logo: {
        flexGrow: "1",
        cursor: "pointer",
    },
    link: {
        textDecoration: "none",
        color: "white",
        fontSize: "16px",
        marginLeft: theme.spacing(10),

    },
}));

const Home = () => {

    const classes = useStyles();

    return (
        <div>
            <Layout/>
            <h1>HOME</h1>
            <Link to="/chart/57">HighChart</Link>
        </div>

    )
};

export default Home;