import React from 'react';
import {withStyles} from 'material-ui/styles';
import blue from "material-ui/colors/blue";
import {MuiThemeProvider, createMuiTheme} from 'material-ui/styles';

const styles = {
    root: {
        width: 500,
    },
};
const theme = createMuiTheme({
    palette: {
        primary: blue,
    }
});


class FooterBar extends React.Component {
    constructor(props) {
        super(props);

    }
    render() {

    return (
        <MuiThemeProvider theme={theme}>
        <footer id="footer" style={{backgroundColor: "transparent"}}>
            <div className="footer-copyright">
                <div className="container">
                    © 2018 Copyright Made by Anju James Arcy Flores
                </div>
            </div>
        </footer>
        </MuiThemeProvider>
    );
    }
}


export default withStyles(styles)(FooterBar);