import {createStore, combineReducers} from 'redux';
import {SIGNOUT, UPDATE_REGISTER_FORM, UPDATE_LOGIN_FORM, AUTHENTICATED} from './actions';



/*
state = {
login_form: {email : ""
        password : ""}

register_form: {name : ""
           email : "",
           phonenumber: "",
           password: "",
           confirmpassword: "",
           }
 current_user: {}

}
 */



export let empty_login_form = {
    email: "",
    password: "",
};


export let empty_register_form = {
    name: "",
    email: "",
    phonenumber: "",
    password: "",
    confirmpassword: ""
};


function login_form(state = empty_login_form, action) {
    switch (action.type) {
        case UPDATE_LOGIN_FORM:
            return Object.assign({}, state, action.field_change);
        default:
            return state;
    }
}


function register_form(state = empty_register_form, action) {
    switch (action.type) {
        case UPDATE_REGISTER_FORM:
            return Object.assign({}, state, action.field_change);
        default:
            return state;
    }
}

function current_user(state = {}, action) {
    switch (action.type) {
        case AUTHENTICATED:
            return Object.assign({}, state, action.user);
        case SIGNOUT:
            return {};
        default:
            return state;
    }
}



const onTimeApp = combineReducers({
     current_user, register_form, login_form
});


let store = createStore(onTimeApp);
export default store;
