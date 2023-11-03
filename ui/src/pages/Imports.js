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

const Imports = () => {

    return (
        <div></div>
    )
};

export default Imports;