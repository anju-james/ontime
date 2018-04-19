import React from 'react';
import {createMuiTheme, withStyles} from "material-ui/styles/index";
import red from "material-ui/colors/red";
import blue from "material-ui/colors/blue";
import withWidth from "material-ui/utils/withWidth";
import {connect} from "react-redux";
import {Socket} from "phoenix";
import {Redirect} from 'react-router-dom';
import Input, {InputLabel} from 'material-ui/Input';
import {MenuItem} from 'material-ui/Menu';
import {FormControl, FormHelperText} from 'material-ui/Form';
import Select from 'material-ui/Select';


const theme = createMuiTheme({
    palette: {
        primary: blue,
        secondary: red,
        action: red[500]
    }
});

const styles = {
    root: {
        display: 'flex',
        flexWrap: 'wrap',
    },
    formControl: {
        margin: theme.spacing.unit,
        minWidth: 120,
    },
    selectEmpty: {
        marginTop: theme.spacing.unit * 2,
    },
};


class AirportChatView extends React.Component {
    constructor(props) {
        super(props);
        let socket = null;
        if (this.props.current_user && this.props.current_user.token) {
            socket = new Socket("/socket", {params: {user: this.props.current_user}});
            socket.connect();
            let room = socket.channel("room:lobby")
            room.on("presence_state", state => {
                presences = Presence.syncState(presences, state)
                console.log('presence state received')
                console.log(presences)
            })

            room.on("presence_diff", diff => {
                presences = Presence.syncDiff(presences, diff)
                console.log('presence diff received')
                console.log(presences)
            })
            room.join();
        }
    }

    render() {
        const {classes} = this.props;

        if (!this.props.current_user || !this.props.current_user.token) {
            return (<Redirect to='/'/>);
        }

        return (<div></div>);
    }
}


const mapStateToProps = state => {
    return {airports: state.airports, current_user: state.current_user, airportchatroom: state.airportchatroom}
};

const AirportChat = connect(mapStateToProps)(AirportChatView)
export default withStyles(styles)(withWidth()(AirportChat));