import React from 'react';
import Button from 'material-ui/Button';
import classNames from 'classnames';
import {withStyles} from 'material-ui/styles';
import IconButton from 'material-ui/IconButton';
import Input, {InputLabel, InputAdornment} from 'material-ui/Input';
import {FormControl, FormHelperText} from 'material-ui/Form';
import Visibility from '@material-ui/icons/Visibility';
import VisibilityOff from '@material-ui/icons/VisibilityOff';
import {connect} from 'react-redux';
import store, {empty_login_form} from './store';
import {current_user, update_login_form} from "./actions";
import { ToastContainer, toast } from 'react-toastify';

import Dialog, {
    DialogActions,
    DialogContent,
    DialogContentText,
    DialogTitle,
} from 'material-ui/Dialog';

const styles = theme => ({
    root: {
        display: 'flex',
        flexWrap: 'wrap',
    },
    margin: {
        margin: theme.spacing.unit,
    },
    withoutLabel: {
        marginTop: theme.spacing.unit * 3,
    },
    textField: {
        flexBasis: 200,
    },
});


class LoginView extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            showPassword: false,
            error: {}
        };
        this.handleClick = this.handleClick.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleMouseDownPassword = this.handleMouseDownPassword.bind(this);
        this.handleClickShowPassword = this.handleClickShowPassword.bind(this);
    }

    handleClick() {
        this.props.handleClose();
    }

    handleSubmit(event) {
        event.preventDefault();
        let error = {};
        let data = this.props.login_form;
        if (!data.email || data.email.trim().length == 0) {
            error['email'] = 'Email is required';
        } else if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,5})+$/.test(data.email))) {
            error['email'] = 'Not a valid email id';
        }

        if (!data.password) {
            error['password'] = 'Password is missing';
        }

        // if no errors
        if(Object.keys(error).length == 0) {
            this.login(data.email, data.password);
            this.setState({error: error});
        } else {
            this.setState({error: error});
        }
    }

    handleChange(event) {
        let tgt = $(event.target);
        let data = {};
        data[tgt.attr('name')] = tgt.val();
        store.dispatch(update_login_form(data));
    };

    handleMouseDownPassword(event) {
        event.preventDefault();
    };

    handleClickShowPassword() {
        this.setState({showPassword: !this.state.showPassword, loggedin: false});
    };

    login(email, password) {
        let login = {email: email, password: password};
        let closeDialog = this.handleClick;
        $.ajax("/api/v1/users", {
            method: "POST",
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: JSON.stringify({email: email, password: password}),
            error: function(jqXHR, textStatus, errorThrown) {
                let response = JSON.parse(jqXHR.responseText);
                toast.error(response.data);
            },
            success: function (resp) {
                store.dispatch(current_user(resp.data));
                store.dispatch(update_login_form(empty_login_form));
                toast.success('✈️ Welcome Back!');
                closeDialog();
            }
        });
    }


    render() {
        let classes = this.props.classes;
        let login = this.props.login_form;
        return (
            <div>
                <Dialog
                    open={true}
                    onClose={this.handleClick}
                    aria-labelledby="form-dialog-title">
                    <DialogTitle id="form-dialog-title">Login</DialogTitle>
                    <DialogContent>
                        <DialogContentText>
                            Login using your email and password
                        </DialogContentText>
                        <FormControl className={classes.margin} error={this.state.error.email ? true : false}
                                     aria-describedby="name-error-text" fullWidth required>
                            <InputLabel htmlFor="email">Email</InputLabel>
                            <Input id="email" name="email" value={login.email} onChange={this.handleChange}/>
                            <FormHelperText
                                id="name-error-text">{this.state.error.email ? this.state.error.email : null}</FormHelperText>
                        </FormControl>

                        <FormControl className={classNames(classes.margin, classes.textField)}
                                     error={this.state.error.password ? true : false} fullWidth required>
                            <InputLabel htmlFor="adornment-password">Password</InputLabel>
                            <Input
                                id="password"
                                name="password"
                                required="true"
                                type={this.state.showPassword ? 'text' : 'password'}
                                value={login.password} onChange={this.handleChange}
                                endAdornment={
                                    <InputAdornment position="end">
                                        <IconButton
                                            aria-label="Toggle password visibility"
                                            onClick={this.handleClickShowPassword}
                                            onMouseDown={this.handleMouseDownPassword}
                                        >
                                            {this.state.showPassword ? <VisibilityOff/> : <Visibility/>}
                                        </IconButton>
                                    </InputAdornment>
                                }
                            />
                            <FormHelperText
                                id="name-error-text">{this.state.error.password ? this.state.error.password : null}</FormHelperText>

                        </FormControl>
                    </DialogContent>
                    <DialogActions>
                        <Button onClick={this.handleSubmit} color="primary">
                            Login
                        </Button>
                        <Button onClick={this.handleClick} color="primary">
                            Cancel
                        </Button>
                    </DialogActions>
                </Dialog>
            </div>
        );
    }
}

const mapStateToProps = state => {
    return {login_form: state.login_form, current_user: state.current_user};
};

const Login = connect(mapStateToProps)(LoginView);
export default withStyles(styles)(Login);
