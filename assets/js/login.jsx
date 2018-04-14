import React from 'react';
import Button from 'material-ui/Button';
import classNames from 'classnames';
import TextField from 'material-ui/TextField';
import {withStyles} from 'material-ui/styles';
import IconButton from 'material-ui/IconButton';
import Input, {InputLabel, InputAdornment} from 'material-ui/Input';
import {FormControl, FormHelperText} from 'material-ui/Form';
import MenuItem from 'material-ui/Menu/MenuItem';
import Visibility from '@material-ui/icons/Visibility';
import VisibilityOff from '@material-ui/icons/VisibilityOff';
import {connect} from 'react-redux';
import store, {empty_login_form} from './store';
import {current_user, update_login_form} from "./actions";


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
        this.state = {showPassword: false};
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
        let data = this.props.login_form;
        if (!data.email || data.email.trim().length == 0) {
            alert('Email is required');
        } else if (!data.password || data.password.trim().length == 0) {
            alert('Password is missing');
        } else if (!data.email.includes("@") || data.email.split("@").length != 2) {
            alert('Not a valid email address. Try again');
        } else {
            login(data.email, data.password)
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
        this.setState({showPassword: !this.state.showPassword});
    };

    login(email, password) {
        let jsonData = JSON.stringify({
            name: email,
            pass: password
        });
        $.ajax('/api/v1/users', {
            method: "POST",
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: jsonData,
            error: function (jqXHR, textStatus, errorThrown) {
                alert(textStatus + '- Login failed. Reason:' + jqXHR.responseText)
            }, success: (resp) => {
                store.dispatch(current_user(resp.data))
                store.dispatch(update_login_form(empty_login_form));
            }
        })
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
                        <TextField
                            autoFocus
                            margin="dense"
                            name="email"
                            id="email"
                            value={login.email} onChange={this.handleChange}
                            label="Email Address"
                            type="email"
                            fullWidth
                        />
                        <FormControl className={classNames(classes.margin, classes.textField)}>
                            <InputLabel htmlFor="adornment-password">Password</InputLabel>
                            <Input
                                id="password"
                                name="password"
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


/*<FormControl className={classNames(classes.margin, classes.textField)}>
    <InputLabel htmlFor="adornment-password">Password</InputLabel>
    <Input
        id="adornment-password"
        name="password"
        //type={this.state.showPassword ? 'text' : 'password'}
        //value={this.state.password}
        value={login.password}  onChange={this.handleChange}
        endAdornment={
            <InputAdornment position="end">
                <IconButton
                    // aria-label="Toggle password visibility"
                    // onClick={this.handleClickShowPassword}
                    // onMouseDown={this.handleMouseDownPassword}
                >
                    /* {this.state.showPassword ? <VisibilityOff /> : <Visibility />}
                </IconButton>
            </InputAdornment>
        }
    />
</FormControl> */