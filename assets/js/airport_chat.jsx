import React from 'react';
import { MuiThemeProvider, createMuiTheme } from 'material-ui/styles';
import red from "material-ui/colors/red";
import blue from "material-ui/colors/blue";
import withWidth from "material-ui/utils/withWidth";
import { connect } from "react-redux";
import { Socket, Presence } from "phoenix";
import { Redirect } from 'react-router-dom';
import Grid from 'material-ui/Grid';
import Drawer from 'material-ui/Drawer';
import Paper from 'material-ui/Paper';
import List, { ListItem, ListItemIcon, ListItemText } from 'material-ui/List';
import ListSubheader from 'material-ui/List/ListSubheader';
import TextField from 'material-ui/TextField';
import Button from 'material-ui/Button';
import Typography from 'material-ui/Typography';
import MenuBar from './menu_bar';
import { withStyles } from 'material-ui/styles';
import AddIcon from '@material-ui/icons/Add';
import Message from '@material-ui/icons/Message';
import Send from '@material-ui/icons/Send';
import ExpansionPanel, {
    ExpansionPanelSummary,
    ExpansionPanelDetails,
} from 'material-ui/ExpansionPanel';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import Input, { InputLabel, InputAdornment } from 'material-ui/Input';
import IconButton from 'material-ui/IconButton';
import MenuItem from 'material-ui/Menu/MenuItem';
import { toast } from 'react-toastify';
import moment from 'moment';
import Hidden from 'material-ui/Hidden';
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
    textField: {
        marginLeft: theme.spacing.unit * 2,
        marginRight: theme.spacing.unit * 2,

    },
    list: {
        marginTop: theme.spacing.unit * 2,
        height: '87vh',
        overflow: 'auto'
    },
    bagdge: {
        marginRight: theme.spacing.unit * 2
    },
    button: {
        margin: theme.spacing.unit,
    },
    paper: {
        margin: theme.spacing.unit * 2
    },

    papermenumd: {
        margin: theme.spacing.unit * 2
    },
    selectedtext: {
        color: blue[500]
    },
    chatpaper: {
        margin: theme.spacing.unit * 2,
        padding: theme.spacing.unit * 2,
        overflow: 'auto',
        height: '71vh',
        border: theme.spacing.unit
    },
    chatmessage: {
        margin: theme.spacing.unit * 5,
    },
    chatinput: {
        marginLeft: theme.spacing.unit * 2,
        marginRight: theme.spacing.unit * 2,

    },
    paperinput: {
        margin: theme.spacing.unit * 2,
        padding: theme.spacing.unit * 5,
        background: 'gainsboro'
    },
    heading: {
        fontSize: theme.typography.pxToRem(15),
    },
    secondaryHeading: {
        fontSize: theme.typography.pxToRem(15),
        color: theme.palette.text.secondary,
    },
    column: {
        flexBasis: '33.33%',
    },
};


class MessageInputComponent extends React.Component {
    constructor(props) {
        super(props);
        this.state = { input_chat_text: '' };
        this.handleChatInputChange = this.handleChatInputChange.bind(this);
        this.handleClickSend = this.handleClickSend.bind(this);
    }

    handleClickSend() {
        this.props.handleClickSend(this.state.input_chat_text);
        this.setState({ input_chat_text: '' });
    }

    handleChatInputChange(event) {
        this.setState({ input_chat_text: event.target.value });
    }

    render() {
        const { classes } = this.props;
        return (<Input className={classes.chatinput}
            id="chat_input_text"
            type='text'
            value={this.state.input_chat_text}
            fullWidth
            placeholder='Enter message to post'
            onChange={this.handleChatInputChange}
            endAdornment={
                <InputAdornment position="end" className={classes.selectedtext}>
                    <IconButton
                        onClick={this.handleClickSend}
                        aria-label="Send message"><Send /></IconButton>
                </InputAdornment>
            }
        />)
    }
}
class AirportChatView extends React.Component {
    constructor(props) {
        super(props);
        let socket = null;
        if (this.props.current_user && this.props.current_user.token) {
            socket = new Socket("/socket", { params: { user: this.props.current_user } });
            socket.connect();
        }
        let airports_sorted = this.props.airports.sort((a1, a2) => {
            if (a1.name < a2.name) return -1;
            if (a1.name > a2.name) return 1;
            return 0;
        });
        this.state = {
            socket: socket, airports: airports_sorted, input_text: '',
            input_chat_text: '', room_by_airport: {}, current_selection: '',
            chatmessages: [], selected_airport: '', presences: {}, unreadbyairport: {}
        };
        this.handleClickSend = this.handleClickSend.bind(this);
        this.handleSelectChange = this.handleSelectChange.bind(this);
    }

    joinRoom(airport_name) {
        if (airport_name == this.state.selected_airport.iata) {
            let newcount = {};
            newcount[airport_name] = 0;
            this.setState({ unreadbyairport: Object.assign({}, this.state.unreadbyairport, newcount) });
        }
        if (airport_name in this.state.room_by_airport) {
            return;
        }
        let room = this.state.socket.channel("room:" + airport_name);
        this.setState({ presences: {} });
        let newcount = {};
        newcount[airport_name] = 0;
        let newroom = {};
        newroom[airport_name] = room;
        this.setState({ unreadbyairport: Object.assign({}, this.state.unreadbyairport, newcount) });
        this.setState({ room_by_airport: Object.assign({}, this.state.room_by_airport, newroom) });
        room.on("presence_state", state => {
            let presences = Presence.syncState(this.state.presences, state)
            this.setState({ presences: presences });
        })

        room.on("presence_diff", diff => {
            let presences = Presence.syncDiff(this.state.presences, diff)
            this.setState({ presences: presences });
        });

        room.on("new_msg", message => {

            let newcount = {};
            newcount[airport_name] = this.state.unreadbyairport[airport_name] + 1;
            this.setState({
                unreadbyairport: Object.assign({}, this.state.unreadbyairport, newcount)
            });
            this.setState({ chatmessages: [message.body, ...this.state.chatmessages] });
        });

        room.on("last_msgs", message => {
            this.setState({ chatmessages: [...message.body, ...this.state.chatmessages] });
        });
        room.join();
    }


    getMenuItemsMdUp() {
        const { classes } = this.props;
        const messages_by_airport = {};
        return (

            <Paper className={classes.list}>
                <Grid container direction="column" alignItems="stretch" justify="flex-start">
                    <Grid item xs={3}>
                        <TextField
                            id="search"
                            label="Filter by airport name"
                            type="search"
                            color="primary"
                            className={classes.textField}
                            onChange={(event) => this.filterAirports(event)}
                        /></Grid>
                    <Grid item xs={9}>
                        <div>
                            <List component="nav">
                                {this.state.airports.map((airport, index) =>
                                    <ListItem key={index} button onClick={() => this.displayAirportChat(airport)}>
                                        <ListItemText key={index} primary={airport.name} classes={
                                            (this.state.selected_airport && this.state.selected_airport.iata == airport.iata) ?
                                                { primary: classes.selectedtext } : null} />
                                        {airport.iata in this.state.unreadbyairport && this.state.unreadbyairport[airport.iata] > 0 ?
                                            <IconButton color="secondary" aria-label="messagecount">
                                                <Message />{this.state.unreadbyairport[airport.iata]}
                                            </IconButton> : null
                                        }
                                    </ListItem>
                                )}
                            </List></div></Grid></Grid></Paper>);

    }


    handleSelectChange(event) {
        let selected = event.target.value;
        if (event.target && event.target != undefined && event.target.value != undefined
             && event.target.value.trim().length > 0) {
            let filtered = this.state.airports.filter(a => a.iata == selected);
            selected = filtered.length > 0 ? filtered[0] : selected;
        }    
        this.displayAirportChat(selected);
    }

    getMenuItemsMdDown() {
        const { classes } = this.props;
        const messages_by_airport = {};
        return (

            <Paper className={classes.papermenumd}>
                <Select fullWidth
                    value={this.state.selected_airport == '' ? '' :this.state.selected_airport.iata}
                    onChange={this.handleSelectChange}
                    inputProps={{
                        name: 'Select an airport from the list to chat',
                        id: 'airport-chat',
                      }}
                >
                    <MenuItem value="">
                        <em>None</em>
                    </MenuItem>
                    {this.state.airports.map((airport, index) => {
                        return (<MenuItem key={index} value={airport.iata}>
                            <em>{airport.name}</em>
                        </MenuItem>)
                    })}
                </Select>                
            </Paper>);


    }

    displayAirportChat(airport) {
        this.setState({ selected_airport: airport });
        this.joinRoom(airport.iata);
    }

    filterAirports(event) {
        let input = event.target.value;
        let airports = this.props.airports.filter(a => a.name.toUpperCase().includes(input.toUpperCase()));
        this.setState({ input_text: input, airports: airports });
    }

    handleChatInputChange(event) {
        this.setState({ input_chat_text: event.target.value });
    }

    handleClickSend(message) {

        if (!message || message.trim().length == 0) {
            toast.warn('Cannot send an empty message');
        } else if (!this.state.selected_airport || this.state.selected_airport == '') {
            toast.warn('Select an airport before sending message');
        } else {
            this.state.room_by_airport[this.state.selected_airport.iata].push("new_msg", { body: { text: message, airport_iata: this.state.selected_airport.iata } });
        }
    }


    render() {
        const { classes } = this.props;

        if (!this.props.current_user || !this.props.current_user.token) {
            return (<Redirect to='/' />);
        }

        return (
            <MuiThemeProvider theme={theme}>
                <Grid
                    container

                    alignItems='stretch'
                    direction='row'
                    justify='flex-start'
                >
                    <Grid item xs={12}><MenuBar history={this.props.history} /></Grid>
                    <Grid item xs={12} />
                    <Grid item xs={12} />
                    <Hidden mdDown>
                    <Grid item xs={3}>
                        {this.getMenuItemsMdUp()}
                    </Grid>
                    </Hidden>
                    <Hidden mdUp>
                    <Grid item xs={12}>
                        {this.getMenuItemsMdDown()}
                    </Grid>
                    </Hidden>
                    <Grid item xs={9}>
                        <Grid container direction="column" justify="flex-start" alignItems="stretch">
                            <Grid item xs={12}>
                                <Paper elevation={0} className={classes.paper}>
                                    <Typography variant="headline" color="primary" component="h3">
                                        {this.state.selected_airport != '' ? this.state.selected_airport.name + 'Chat Room' :
                                            'Select an airport to start'}
                                    </Typography>
                                    <Typography variant="subheading">
                                        {Object.keys(this.state.presences).length + " active users online in this chat"}
                                    </Typography>
                                </Paper>
                            </Grid>
                            <Grid item xs={12}>
                                <Paper elevation={6} className={classes.chatpaper}>
                                    <Paper elevation={6} className={classes.paperinput}>
                                        <MessageInputComponent classes={this.props.classes} handleClickSend={this.handleClickSend} />
                                    </Paper>
                                    {this.state.chatmessages.filter(m => this.state.selected_airport != '' 
                                    && this.state.selected_airport.iata == m.airport_iata).map((message, index) => {
                                        return <ExpansionPanel key={index} className={classes.chatmessage} defaultExpanded={true}>
                                            <ExpansionPanelSummary expandIcon={<ExpandMoreIcon />}>
                                                <div className={classes.column}>
                                                    <Typography className={classes.heading}>{message.user_name}</Typography>
                                                </div>
                                                <div className={classes.column}>
                                                    <Typography className={classes.secondaryHeading}>{moment.utc(message.send_time).local().format('MM/DD/YYYY h:mm a')}</Typography>
                                                </div>
                                            </ExpansionPanelSummary>
                                            <ExpansionPanelDetails>
                                                <Typography>
                                                    {message.text}
                                                </Typography>
                                            </ExpansionPanelDetails>
                                        </ExpansionPanel>
                                    })
                                    }
                                </Paper>
                            </Grid>
                        </Grid>
                    </Grid>
                </Grid>
            </MuiThemeProvider>);
    }
}


const mapStateToProps = state => {
    return { airports: state.airports, current_user: state.current_user, airportchatroom: state.airportchatroom }
};

const AirportChat = connect(mapStateToProps)(AirportChatView)
export default withStyles(styles)(withWidth()(AirportChat));