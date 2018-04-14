import React from 'react';
import Button from 'material-ui/Button';
import classNames from 'classnames';
import TextField from 'material-ui/TextField';
import {withStyles} from 'material-ui/styles';
import IconButton from 'material-ui/IconButton';
import Input, {InputLabel, InputAdornment} from 'material-ui/Input';
import {FormControl, FormHelperText} from 'material-ui/Form';
import Visibility from '@material-ui/icons/Visibility';
import VisibilityOff from '@material-ui/icons/VisibilityOff';
import {connect} from 'react-redux';
import store, {empty_register_form} from './store';
import {update_register_form} from './actions';
import {TextValidator, ValidatorForm} from 'react-material-ui-form-validator';


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


class RegisterView extends React.Component {
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
    };

    handleChange(event) {
        let tgt = $(event.target);
        let data = {};
        data[tgt.attr('name')] = tgt.val();
        store.dispatch(update_register_form(data));

    };

    handleMouseDownPassword(event) {
        event.preventDefault();
    };

    handleClickShowPassword() {
        this.setState({showPassword: !this.state.showPassword});
    };

    createUser(user) {
        let jsonData = JSON.stringify({
            user: user,
        });
        let email = user.email;
        // reset form fields
        store.dispatch(update_register_form(empty_register_form));
        console.log("post")
        $.ajax('/api/v1/users', {
            method: "POST",
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: jsonData,
            error: function (jqXHR, textStatus, errorThrown) {
                alert(textStatus + '- Creating user failed. Reason:' + jqXHR.responseText)
            }, success: (resp) => {
                alert("User account for  '" + email + "' created successfully");
                this.handleClick();
            }
        });
    };

    handleSubmit(ev) {
        ev.preventDefault();
        let clear_passwords = {password: "", confirmpassword: ""}
        let register = this.props.register_form;
        if (!register.name || register.name.trim().length == 0) {
            alert('Name is required');
        } else if (!register.email || register.email.trim().length == 0) {
            alert('Email is required');
        } else if (!register.phonenumber || register.phonenumber.trim().length < 10 || register.phonenumber.trim().length > 10) {
            alert('Enter valid phone number');
        } else if (!register.password || register.password.trim().length == 0) {
            alert('Password is missing');
        } else if (!register.confirmpassword || register.confirmpassword.trim().length == 0) {
            alert('Please confirm password');
        } else if (register.password.trim().length < 8 || register.confirmpassword.trim().length < 8) {
            alert("Please doesn't meet minimum length required (8)");
        } else if (register.password != register.confirmpassword) {
            alert('Password and confirm password doesnot match. Try again');
            store.dispatch(update_register_form(clear_passwords));
        } else if (!register.email.includes("@") || register.email.split("@").length != 2) {
            alert('Not a valid email address. Try again');
        } else {
            this.createUser(register);
            // redirect user to login page
        }

    }


    /*handleMouseDownPassword(event){
        event.preventDefault();
    };

    handleClickShowPassword(){
        this.setState({ showPassword: !this.state.showPassword });
    };
    */

    render() {
        let classes = this.props.classes;
        let register = this.props.register_form;
        return (
            <div>
                <Dialog
                    open={true}
                    onClose={this.handleClick}
                    aria-labelledby="form-dialog-title">
                    <ValidatorForm
                        ref="form"
                        onSubmit={this.handleSubmit}>
                        <DialogTitle id="form-dialog-title">Register</DialogTitle>
                        <DialogContent>
                            <TextValidator
                                autoFocus
                                margin="dense"
                                name="name"
                                id="name"
                                label="Name"
                                type="text"
                                value={register.name} onChange={this.handleChange}
                                validators={['required']}
                                errorMessages={['Name is required']}
                                fullWidth
                            />
                            <TextValidator
                                autoFocus
                                margin="dense"
                                name="email"
                                id="email"
                                label="Email Address"
                                type="email"
                                value={register.email} onChange={this.handleChange}
                                validators={['required', 'isEmail']}
                                errorMessages={['Email is required', 'email is not valid']}
                                fullWidth
                            />
                            <TextValidator
                                autoFocus
                                margin="dense"
                                name="phonenumber"
                                id="phonenumber"
                                label="Phone Number"
                                type="text"
                                value={register.phonenumber} onChange={this.handleChange}
                                fullWidth
                            />

                            <TextField
                                id="password"
                                name="password"
                                label="Password"
                                type={this.state.showPassword ? 'text' : 'password'}
                                value={register.password} onChange={this.handleChange}
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
                            <TextField
                                id="confirmpassword"
                                name="confirmpassword"
                                label="Confirm Password"
                                type={this.state.showPassword ? 'text' : 'password'}
                                value={register.confirmpassword} onChange={this.handleChange}
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


                        </DialogContent>
                        <DialogActions>
                            <Button type="submit" color="primary">
                                Register
                            </Button>
                            <Button onClick={this.handleClick} color="primary">
                                Cancel
                            </Button>

                        </DialogActions>
                    </ValidatorForm>
                </Dialog>
            </div>
        );
    }
}


const mapStateToProps = state => {
    return {register_form: state.register_form};
};

const Register = connect(mapStateToProps)(RegisterView);
export default withStyles(styles)(Register);



