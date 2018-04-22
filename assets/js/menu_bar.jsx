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
import {signout_user, fetched_subscriptions} from "./actions";
import {ToastContainer, toast, Flip} from 'react-toastify';
import Hidden from 'material-ui/Hidden'
import Menu, {MenuItem} from 'material-ui/Menu';
import MoreVertIcon from '@material-ui/icons/MoreVert';


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
        this.state = {loginopen: false, registeropen: false, anchorEl: null};
        this.openLogin = this.openLogin.bind(this);
        this.openRegister = this.openRegister.bind(this);
        this.signout = this.signout.bind(this);
        this.subscriptions = this.subscriptions.bind(this);
        this.home = this.home.bind(this);
        this.chat = this.chat.bind(this);
        this.handleMenuClick = this.handleMenuClick.bind(this);
        this.handleMenuClose = this.handleMenuClose.bind(this);
    }

    openLogin() {
        this.handleMenuClose();
        this.setState({loginopen: true});
    }

    closeLogin() {
        this.setState({loginopen: false});
    }

    openRegister() {
        this.handleMenuClose();
        this.setState({registeropen: true});
    }

    closeRegister() {
        this.setState({registeropen: false});
    }

    handleMenuClick(event) {
        this.setState({anchorEl: event.currentTarget});
    };

    handleMenuClose() {
        this.setState({anchorEl: null});
    };


    renderButtons() {
        if (this.props.user && this.props.user.token) {
            return (<Button color="inherit" onClick={this.signout}>Signout</Button>);
        } else {
            return (
                <div>
                    <Button color="inherit" onClick={this.openLogin}>Login</Button>
                    <Button color="inherit" onClick={this.openRegister}>Register</Button>
                </div>);
        }
    }

    signout() {
        this.handleMenuClose();
        toast.info('You have Signed Out!');
        store.dispatch(signout_user());
        store.dispatch(fetched_subscriptions([]));

    }

    chat() {
        this.handleMenuClose();
        this.props.history.push("/chat");

    }

    home() {
        this.handleMenuClose();
        this.props.history.push("/");
    }

    subscriptions() {
        this.handleMenuClose();
        this.props.history.push("/subscriptions");

    }

    render() {
        let classes = this.props.classes;
        const {anchorEl} = this.state;
        return (
            <MuiThemeProvider theme={theme}>
                <AppBar position="sticky"
                        style={{backgroundColor: (this.props.transparent ? "transparent" : "blue[500]")}}>
                    <Toolbar>
                        <IconButton onClick={() => this.props.history ? this.props.history.push("/") : null}
                                    className={classes.menuButton} color="inherit" aria-label="Menu">
                            <Flight/>
                        </IconButton>
                        <Typography variant="title" color="inherit" className={classes.flex}>
                            OnTime
                        </Typography>
                        <Hidden only={['sm', 'xs', 'md']}>
                            {this.props.user && this.props.user.token ?
                                <Button color="inherit" onClick={this.home}>Home</Button>
                                : null}
                            {this.props.user && this.props.user.token ?
                                <Button color="inherit" onClick={this.chat}>Chat</Button>
                                : null}
                            {this.props.user && this.props.user.token ?
                                <Button color="inherit" onClick={this.subscriptions}>Subscriptions</Button>
                                : <Button color="inherit" onClick={this.openLogin}>Login</Button>}
                            {this.props.user && this.props.user.token ?
                                <Button color="inherit" onClick={this.signout}>Sign out</Button>
                                : <Button color="inherit" onClick={this.openRegister}>Register</Button>}
                        </Hidden>
                        <Hidden only={['lg', 'xl']}>
                            <IconButton color="inherit"
                                        aria-owns={anchorEl ? 'simple-menu' : null}
                                        aria-haspopup="true"
                                        onClick={this.handleMenuClick}
                            >
                                <MoreVertIcon/>
                            </IconButton>
                            <Menu
                                id="simple-menu"
                                anchorEl={anchorEl}
                                open={Boolean(anchorEl)}
                                onClose={this.handleMenuClose}
                            >
                                {this.props.user && this.props.user.token ?
                                    <MenuItem onClick={this.home}>Home</MenuItem>
                                    : null}
                                {this.props.user && this.props.user.token ?
                                    <MenuItem onClick={this.chat}>Chat</MenuItem>
                                    : null}
                                {this.props.user && this.props.user.token ?
                                    <MenuItem onClick={this.subscriptions}>Subscriptions</MenuItem>
                                    : <MenuItem onClick={this.openLogin}>Login</MenuItem>}
                                {this.props.user && this.props.user.token ?
                                    <MenuItem onClick={this.signout}>Sign out</MenuItem>
                                    : <MenuItem onClick={this.openRegister}>Register</MenuItem>}
                            </Menu>
                        </Hidden>
                        {this.state.loginopen ? <Login open={true} handleClose={() => this.closeLogin()}/> : null}
                        {this.state.registeropen ?
                            <Register open={true} handleClose={() => this.closeRegister()}/> : null}
                        <div>
                        </div>
                    </Toolbar>
                </AppBar>
                <ToastContainer
                    transition={Flip}
                    position="top-center"
                    autoClose={5000}
                    hideProgressBar
                    newestOnTop={false}
                    closeOnClick
                    rtl={false}
                    pauseOnVisibilityChange={false}
                    draggable={false}
                    pauseOnHover={false}
                />
            </MuiThemeProvider>
        )
    }

}


const mapStateToProps = state => {
    return {user: state.current_user};
};

const MenuBar = connect(mapStateToProps)(MenuBarView);
export default withStyles(styles)(MenuBar);