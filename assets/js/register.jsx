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
import store, {empty_register_form} from './store';
import {update_register_form} from './actions';
import {toast} from 'react-toastify';


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
                let response = JSON.parse(jqXHR.responseText);
                toast.error(response.data);
            }, success: (resp) => {
                toast.success("Account created. Please proceed to login using your new credentials. Check your email for details.");
                this.handleClick();
            }
        });
    };

    handleSubmit(ev) {
        ev.preventDefault();
        let clear_passwords = {password: "", confirmpassword: ""}
        let error = {};
        let register = this.props.register_form;
        if (!register.name || register.name.trim().length == 0) {
            error['name'] = 'Name is required';
        }

        if (!register.email || register.email.trim().length == 0) {
            error['email'] = 'Email is required';
        } else if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,5})+$/.test(register.email))) {
            error['email'] = 'Not a valid email id';
        }

        if (!register.phonenumber || register.phonenumber.trim().replace(" ", "").replace("-", "").length != 12) {
            error['phonenumber'] = 'Enter valid phone number of format +1 XXX XXX XXXX';
        } else if (!register.phonenumber.trim().startsWith("+1")) {
            error['phonenumber'] = "Country code missing(+1) or not a US number"
        }

        //All conditions related to passwords
        if (!register.password) {
            error['password'] = 'Password is missing';
        }
        if (!register.confirmpassword || register.confirmpassword.trim().length == 0) {
            error['confirmpassword'] = 'Confirm Password is missing';
        }

        if (register.password.trim().length < 8) {
            error['password'] = "Password doesn't meet minimum length required (8)";
        }

        if (register.password != register.confirmpassword) {
            error['confirmpassword'] = 'Password and confirm password does not match.';
            store.dispatch(update_register_form(clear_passwords));
        }

        if (Object.keys(error).length == 0) {
            this.createUser(register);
        }
        this.setState({error: error})

    }


    handleMouseDownPassword(event) {
        event.preventDefault();
    };

    handleClickShowPassword() {
        this.setState({showPassword: !this.state.showPassword});
    };


    render() {
        let classes = this.props.classes;
        let register = this.props.register_form;
        return (
            <div>
                <Dialog
                    open={true}
                    onClose={this.handleClick}
                    aria-labelledby="form-dialog-title">
                    <DialogTitle id="form-dialog-title">Register</DialogTitle>
                    <DialogContent>

                        <FormControl className={classes.margin} error={this.state.error.name ? true : false}
                                     aria-describedby="name-error-text" fullWidth required>
                            <InputLabel htmlFor="name">Name</InputLabel>
                            <Input id="name" name="name" value={register.name} onChange={this.handleChange}/>
                            <FormHelperText
                                id="name-error-text">{this.state.error.name ? this.state.error.name : null}</FormHelperText>
                        </FormControl>

                        <FormControl className={classes.margin} error={this.state.error.email ? true : false}
                                     aria-describedby="name-error-text" fullWidth required>
                            <InputLabel htmlFor="email">Email</InputLabel>
                            <Input id="email" name="email" value={register.email} onChange={this.handleChange}/>
                            <FormHelperText
                                id="name-error-text">{this.state.error.email ? this.state.error.email : null}</FormHelperText>
                        </FormControl>

                        <FormControl className={classes.margin} error={this.state.error.phonenumber ? true : false}
                                     aria-describedby="name-error-text" fullWidth required>
                            <InputLabel htmlFor="phonenumber">Phone Number</InputLabel>
                            <Input id="phonenumber" name="phonenumber" fullWidth value={register.phonenumber}
                                   onChange={this.handleChange}/>
                            <FormHelperText
                                id="name-error-text">{this.state.error.phonenumber ? this.state.error.phonenumber : "+1 XXX XXX XXXX"}</FormHelperText>
                        </FormControl>


                        <FormControl className={classNames(classes.margin, classes.textField)}
                                     error={this.state.error.password ? true : false} fullWidth required>
                            <InputLabel htmlFor="adornment-password">Password</InputLabel>
                            <Input
                                id="password"
                                name="password"
                                required="true"
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
                            <FormHelperText
                                id="name-error-text">{this.state.error.password ? this.state.error.password : null}</FormHelperText>

                        </FormControl>
                        <FormControl className={classNames(classes.margin, classes.textField)}
                                     error={this.state.error.confirmpassword ? true : false} fullWidth required>
                            <InputLabel htmlFor="adornment-password">Confirm Password</InputLabel>
                            <Input
                                id="confirmpassword"
                                name="confirmpassword"
                                required="true"
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
                            <FormHelperText
                                id="name-error-text">{this.state.error.confirmpassword ? this.state.error.confirmpassword : null}</FormHelperText>

                        </FormControl>

                    </DialogContent>
                    <DialogActions>
                        <Button onClick={this.handleSubmit} color="primary">
                            Register
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
    return {register_form: state.register_form};
};

const Register = connect(mapStateToProps)(RegisterView);
export default withStyles(styles)(Register);



