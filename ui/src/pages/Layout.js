import { Link } from "react-router-dom";
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

const Layout = () => {

    const classes = useStyles();

    return (
        <AppBar position="static" className={classes.appBar}>
            <CssBaseline />
            <Toolbar>
                <div className={classes.navlinks}>
                    <Typography variant="h4" className={classes.logo}>
                        VermontKidsData
                    </Typography>
                    <Link to="/" className={classes.link}>Home</Link>
                    <Link to="/login" className={classes.link}>Login</Link>
                    <Link to="/upload" className={classes.link}>Upload</Link>
                    <Link to="/chart/57" className={classes.link}>HighChart</Link>
                    <Link to="/table/58" className={classes.link}>MaterialTable</Link>
                    <Link to="/census" className={classes.link}>Census</Link>
                    <Link to="/datagrid/58" className={classes.link}>MaterialDataGrid</Link>
                    <Link to="/about" className={classes.link}>About</Link>
                </div>
            </Toolbar>
        </AppBar>


    )
};

export default Layout;

/*
<nav>
                <ul>
                    <li>

                    </li>
                    <li>

                    </li>
                    <li>

                    </li>
                    <li>

                    </li>
                    <li>

                    </li>
                    <li>

                    </li>
                    <li>

                    </li>
                    <li>

                    </li>
                </ul>
            </nav>
 */