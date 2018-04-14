export const AUTHENTICATED = 'AUTHENTICATED';
export const SIGNOUT = 'SIGNOUT';
export const UPDATE_REGISTER_FORM = 'UPDATE_REGISTER_FORM';
export const UPDATE_LOGIN_FORM = 'UPDATE_LOGIN_FORM';


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