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
import {connect} from 'react-redux';
import store from "./store";
import {signout_user} from "./actions";
import { ToastContainer, toast } from 'react-toastify';

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
    close: {
        width: theme.spacing.unit * 4,
        height: theme.spacing.unit * 4,
    },
};

export class MenuBarView extends React.Component {
    constructor(props) {
        super(props);
        this.state = {loginopen : false, registeropen: false};
        this.openLogin = this.openLogin.bind(this);
        this.openRegister = this.openRegister.bind(this);
        this.signout = this.signout.bind(this);

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

    renderButtons() {
        if(this.props.user && this.props.user.token ) {
            return (<Button color="inherit" onClick={this.signout} >Signout</Button>);
        } else {
            return (
                <div>
                <Button color="inherit" onClick={this.openLogin}>Login</Button>
                <Button color="inherit" onClick={this.openRegister}>Register</Button>
                </div>);
        }
    }

    signout() {
        toast.warn('You have Signed Out!');
        store.dispatch(signout_user());

    }

    render() {
        let classes = this.props.classes;

        return (
            <MuiThemeProvider theme={theme}>
                <AppBar position="sticky" style={{backgroundColor: (this.props.transparent? "transparent" : "blue[500]")}}>
                    <Toolbar>
                        <IconButton className={classes.menuButton} color="inherit" aria-label="Menu">
                            <Flight/>
                        </IconButton>
                        <Typography variant="title" color="inherit" className={classes.flex}>
                            OnTime
                        </Typography>
                        {this.renderButtons()}
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


const mapStateToProps = state => {
    return {user: state.current_user};
};

const MenuBar = connect(mapStateToProps)(MenuBarView);
export default withStyles(styles)(MenuBar);