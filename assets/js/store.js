import {createStore, combineReducers} from 'redux';
import {
    SIGNOUT, UPDATE_REGISTER_FORM, UPDATE_LOGIN_FORM, AUTHENTICATED, UPDATE_AIRPORTS,
    UPDATE_FLIGHTINFO, UPDATE_ADV_SEARCH_FORM, FETCHED_SUBSCRIPTIONS, DELETED_SUBSCRIPTION,
    NEW_SUBSCRIPTION, JOIN_CHATROOM,LEAVE_CHATROOM
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
 adv_search_form : {origin: "", destination: "", traveldate: "", flightnumber: ""},
 subscriptions: []
 airportchatroom: '',

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
    flightnumber: ""
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

function subscriptions(state=[], action) {
    switch(action.type) {
        case FETCHED_SUBSCRIPTIONS:
            return action.subscriptions;
        case DELETED_SUBSCRIPTION:
            return state.filter((subscription) => subscription.id != action.subscription.id);
        case NEW_SUBSCRIPTION:
            return [...state, action.subscription]
        default:
            return state;
    }
}

function airportchatroom(state='', action) {
    switch(action.type) {
        case LEAVE_CHATROOM:
            return '';
        case JOIN_CHATROOM:
            return action.airportname;
        default:
            return state;
    }
}


const onTimeApp = combineReducers({
     current_user, register_form, login_form, airports,
    flightinfo, adv_search_form, subscriptions,airportchatroom
});


let store = createStore(onTimeApp);
export default store;
