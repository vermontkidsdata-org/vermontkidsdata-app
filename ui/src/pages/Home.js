import {Link, Outlet} from "react-router-dom";
import React from "react";
import Layout from "./Layout";
import MaterialDataGrid from "./MaterialDataGrid";

const Home = () => {
    return (
        <div>
            <Layout/>
            <h1>HOME</h1>
        </div>

    )
};

export default Home;