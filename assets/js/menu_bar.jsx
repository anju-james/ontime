import React from 'react';
import {withStyles} from 'material-ui/styles';
import AppBar from 'material-ui/AppBar';
import Toolbar from 'material-ui/Toolbar';
import Typography from 'material-ui/Typography';
import Button from 'material-ui/Button';
import IconButton from 'material-ui/IconButton';
import Flight from '@material-ui/icons/Flight';
import {MuiThemeProvider, createMuiTheme} from 'material-ui/styles';
import blue from 'material-ui/colors/blue';
import Login from './login';
import Register from './register';


const theme = createMuiTheme({
    palette: {
        primary: blue,
    }
});
const styles = {
    root: {
        flexGrow: 1,
    },
    flex: {
        flex: 1,
    },
    menuButton: {
        marginLeft: -12,
        marginRight: 20,
    },
};

export class MenuBar extends React.Component {
    constructor(props) {
        super(props);
        this.state = {loginopen : false, registeropen: false};
        this.openLogin = this.openLogin.bind(this);
        this.openRegister = this.openRegister.bind(this);

    }

    openLogin() {
        this.setState({loginopen: true});
    }

    closeLogin() {
        this.setState({loginopen: false});
    }

    openRegister() {
        this.setState({registeropen: true});
    }

    closeRegister() {
        this.setState({registeropen: false});
    }


    render() {
        let classes = this.props.classes;
        return (
            <MuiThemeProvider theme={theme}>
                <AppBar position="static" style={{backgroundColor: "transparent"}}>
                    <Toolbar>
                        <IconButton className={classes.menuButton} color="inherit" aria-label="Menu">
                            <Flight/>
                        </IconButton>
                        <Typography variant="title" color="inherit" className={classes.flex}>
                            OnTime
                        </Typography>
                        <Button color="inherit" onClick={this.openLogin}>Login</Button>
                        <Button color="inherit" onClick={this.openRegister}>Register</Button>
                        {this.state.loginopen ? <Login open={true} handleClose={() => this.closeLogin()} /> : null}
                        {this.state.registeropen ? <Register open={true} handleClose={() => this.closeRegister()} /> :null}
                        <div>

                        </div>
                    </Toolbar>
                </AppBar>
            </MuiThemeProvider>
        )
    }

}


export default withStyles(styles)(MenuBar);