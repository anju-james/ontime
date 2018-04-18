import {createStore, combineReducers} from 'redux';
import {
    SIGNOUT, UPDATE_REGISTER_FORM, UPDATE_LOGIN_FORM, AUTHENTICATED, UPDATE_AIRPORTS,
    UPDATE_FLIGHTINFO, UPDATE_ADV_SEARCH_FORM
} from './actions';



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
 current_user: {},
 airports: [],
 adv_search_form : {origin: "", destination: "", traveldate: ""}

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

export let empty_adv_search_form = {
    origin: "",
    destination: "",
    traveldate: "",
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

function airports(state = [], action) {
    switch (action.type) {
        case UPDATE_AIRPORTS:
            return action.airports;
        default:
            return state;
    }
}


function flightinfo(state=[], action) {
    switch (action.type) {
        case UPDATE_FLIGHTINFO:
            return action.flightinfo;
        default:
            return state;
    }
}

function adv_search_form(state= empty_adv_search_form, action) {
    switch (action.type) {
        case UPDATE_ADV_SEARCH_FORM:
            return Object.assign({}, state, action.field_change);
        default:
            return state;
    }
}


const onTimeApp = combineReducers({
     current_user, register_form, login_form, airports,
    flightinfo, adv_search_form
});


let store = createStore(onTimeApp);
export default store;
