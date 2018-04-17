export const AUTHENTICATED = 'AUTHENTICATED';
export const SIGNOUT = 'SIGNOUT';
export const UPDATE_REGISTER_FORM = 'UPDATE_REGISTER_FORM';
export const UPDATE_LOGIN_FORM = 'UPDATE_LOGIN_FORM';
export const UPDATE_AIRPORTS = 'UPDATE_AIRPORTS';
export const UPDATE_FLIGHTINFO = 'UPDATE_FLIGHTINFO';
export const UPDATE_ADV_SEARCH_FORM = 'UPDATE_ADV_SEARCH_FORM';


export function current_user(user) {
    return { type: AUTHENTICATED, user: user }
}

export function signout_user() {
    return { type: SIGNOUT }
}

export  function update_register_form(field_change) {
    return { type: UPDATE_REGISTER_FORM, field_change: field_change}
}

export  function update_login_form(field_change) {
    return { type: UPDATE_LOGIN_FORM, field_change: field_change}
}

export function update_airports(airports) {
    return {type: UPDATE_AIRPORTS, airports: airports}
}

export function update_flightinfo(flightinfo) {
    return {type: UPDATE_FLIGHTINFO, flightinfo: flightinfo}
}

export function update_adv_search_form(field_change) {
    return {type: UPDATE_ADV_SEARCH_FORM, field_change: field_change}
}
