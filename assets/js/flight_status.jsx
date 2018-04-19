import React from 'react';
import {withStyles} from 'material-ui/styles';
import Card, {CardActions, CardContent, CardMedia} from 'material-ui/Card';
import Button from 'material-ui/Button';
import {connect} from "react-redux";
import List, {ListItem, ListItemIcon, ListItemText} from 'material-ui/List';
import FlightTakeoff from '@material-ui/icons/FlightTakeoff';
import FlightLand from '@material-ui/icons/FlightLand';
import AddIcon from '@material-ui/icons/Add';
import Delete from '@material-ui/icons/Delete'
import Grid from 'material-ui/Grid';
import MenuBar from './menu_bar';
import moment from 'moment';
import Chip from 'material-ui/Chip';
import blue from "material-ui/colors/blue";
import red from "material-ui/colors/red";
import green from "material-ui/colors/green";
import {MuiThemeProvider, createMuiTheme} from 'material-ui/styles';
import Tooltip from 'material-ui/Tooltip';
import Stepper, {Step, StepButton, StepLabel} from 'material-ui/Stepper';
import Typography from 'material-ui/Typography'
import Hidden from 'material-ui/Hidden'
import withWidth from 'material-ui/utils/withWidth'
import {LinearProgress, CircularProgress} from 'material-ui/Progress';
import {toast} from 'react-toastify';
import Paper from 'material-ui/Paper';
import store from './store';
import {deleted_subscription, new_subscription} from './actions';
import {Redirect} from 'react-router-dom';


const theme = createMuiTheme({
    palette: {
        primary: blue,
        secondary: red,
        action: red[500]
    }
});

const styles = {
    card: {
        maxWidth: 400,

    },
    media: {
        height: 200,
    },
    chip: {
        margin: theme.spacing.unit,
    },
    wrapper: {
        margin: theme.spacing.unit,
        position: 'relative',
    },
    buttonNew: {
        backgroundColor: blue[500],
        '&:hover': {
            backgroundColor: blue[500],
        },
    },
    buttonSuccess: {
        backgroundColor: green[500],
        '&:hover': {
            backgroundColor: green[500],
        },
    },
    fabProgress: {
        color: green[500],
        position: 'absolute',
        top: -6,
        left: -6,
        zIndex: 1,
    },
    root: theme.mixins.gutters({
        paddingTop: 16,
        paddingBottom: 16,
        marginTop: theme.spacing.unit * 3,
    }),

};

export class FlightStatusCard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            loading: false,
        };


    }

    renderStepper(status) {
        if (status == 'S') {
            return (<Hidden smDown><Stepper><Step key="S"><StepButton completed={true}>Scheduled
            </StepButton></Step><Step key="E"><StepButton completed={false}>En-route
            </StepButton></Step>
                <Step key="L"><StepButton completed={false}>Landed
                </StepButton></Step></Stepper></Hidden>);
        } else if (status == 'A') {
            return (<Hidden smDown><Stepper><Step key="S"><StepButton completed={true}>Scheduled
            </StepButton></Step>
                <Step key="E"><StepButton completed={true}>En-route
                </StepButton></Step><Step key="L"><StepButton completed={false}>Landed
                </StepButton></Step></Stepper></Hidden>);

        } else if (status == 'L') {
            return (<Hidden smDown><Stepper><Step key="S"><StepButton completed={true}>Scheduled
            </StepButton></Step>
                <Step key="E"><StepButton completed={true}>En-route
                </StepButton></Step>
                <Step key="L"><StepButton completed={true}>Landed
                </StepButton></Step></Stepper></Hidden>);
        } else {
            const labelProps = {};
            let statusCaps = status.charAt(0).toUpperCase() + status.slice(1);
            labelProps.optional = (
                <Typography variant="caption" color="error">
                    {statusCaps}
                </Typography>
            );
            labelProps.error = true;
            return (<Hidden smDown><Stepper><Step key="S"><StepButton completed={true}>Scheduled
            </StepButton></Step>
                <Step key="E"><StepLabel {...labelProps}>Alert</StepLabel></Step></Stepper></Hidden>);
        }

    }

    removeSubscription(subscription) {
        $.ajax('/api/v1/subscriptions/' + subscription.id+"?token="+this.props.current_user.token, {
            method: "DELETE",
            contentType: "application/json; charset=UTF-8",
            error: function (jqXHR, textStatus, errorThrown) {
                let response = JSON.parse(jqXHR.responseText);
                let messages = ['Failed to remove alert']
                if (jqXHR.status == 422) {
                    Object.keys(response.errors).forEach(key => messages.push(key + ' ' + response.errors['' + key].join(",")));
                    toast.error(messages.join('\n'));
                } else {
                    toast.error("We have encountered an unknown error. Please try again after sometime.");
                }
                this.setState({loading: false});

            }, success: (resp) => {
                toast.success("Alert removed.");
                store.dispatch(deleted_subscription(subscription));
                this.setState({loading: false});
            }
        });
    }

    addSubscription(flight_info) {

        let data = {
            token: this.props.current_user.token,
            subscription: {
                flightid: flight_info.flightId, userid: this.props.current_user.id,
                airline_name: this.props.airline_name_map[flight_info.carrierFsCode],
                srcia_iata: flight_info.departureAirportFsCode, dest_iata: flight_info.arrivalAirportFsCode,
                flight_data: flight_info, flight_time: flight_info.departureDate.dateUtc, expired: false
            }
        };
        $.ajax('/api/v1/subscriptions', {
            method: "POST",
            dataType: "json",
            contentType: "application/json; charset=UTF-8",
            data: JSON.stringify(data),
            error: function (jqXHR, textStatus, errorThrown) {
                let response = JSON.parse(jqXHR.responseText);
                let messages = ['Failed to add new alert']
                if (jqXHR.status == 422) {
                    Object.keys(response.errors).forEach(key => messages.push(key + ' ' + response.errors['' + key].join(",")));
                    toast.error(messages.join('\n'));
                } else {
                    toast.error("We have encountered an unknown error. Please try again after sometime.");
                }
                this.setState({loading: false});

            }, success: (resp) => {
                toast.success("Subscribed to alerts for flight " + flight_info.carrierFsCode + flight_info.flightNumber + ".");
                store.dispatch(new_subscription(resp.data));
                this.setState({loading: false});
            }
        });
    }

    handleButtonClick(flight_info) {
        if (!this.props.current_user || !this.props.current_user.token) {
            toast.warn('You need to login before setting up alerts');
            return;
        }

        if (!this.state.loading) {
            this.setState({loading: true});
            let existing_sub = (flight_info.flightId in this.props.flightid_subscription_map);
            if (existing_sub) {
                this.removeSubscription(this.props.flightid_subscription_map[flight_info.flightId]);
            } else if (flight_info.status == "L") {
                toast.warn("Landed flights not eligible for alerts.");
                this.setState({loading: false});
            } else {
                // subscribe
                this.addSubscription(flight_info);
            }
        }

    };

    render() {
        const {classes} = this.props;
        const flight_info = this.props.flight_info;
        let existing_sub = (flight_info.flightId in this.props.flightid_subscription_map);

        return (
            <MuiThemeProvider theme={theme}>
                <div>
                    <Card className={classes.card}>
                        <CardMedia
                            className={classes.media}
                            image={"/images/airport" + (this.props.index % 8) + ".jpg"}
                            title="Flight Status"
                        />
                        <CardContent>
                            <ListItem>
                                <Chip
                                    label={flight_info.carrierFsCode + flight_info.flightNumber}
                                    className={classes.chip}
                                />
                                <ListItemText primary={this.props.airline_name_map[flight_info.carrierFsCode]}/>
                            </ListItem>

                            <ListItem>
                                <ListItemIcon>
                                    <FlightTakeoff nativeColor="blue"/>
                                </ListItemIcon>
                                <ListItemText primary={flight_info.departureAirportFsCode}/>
                                <ListItemText
                                    primary={moment(flight_info.departureDate.dateLocal).format('MM/DD/YYYY h:mm a')}/>
                                <Tooltip id="tooltip-origin-terminal" title="Boarding Terminal">
                                    <ListItemText
                                        primary={flight_info.airportResources.departureTerminal ? flight_info.airportResources.departureTerminal : ""}/>
                                </Tooltip>
                                <Tooltip id="tooltip-origin-gate" title="Boarding Gate">
                                    <ListItemText
                                        primary={flight_info.airportResources.departureGate ? flight_info.airportResources.departureGate : ""}
                                        color="primary"/>
                                </Tooltip>
                            </ListItem>

                            <ListItem>
                                <ListItemIcon>
                                    <FlightLand nativeColor="red"/>
                                </ListItemIcon>
                                <ListItemText primary={flight_info.arrivalAirportFsCode}/>
                                <ListItemText
                                    primary={moment(flight_info.arrivalDate.dateLocal).format('MM/DD/YYYY h:mm a')}/>
                                <Tooltip id="tooltip-arrival-terminal" title="Arrival Terminal">
                                    <ListItemText
                                        primary={flight_info.airportResources.arrivalTerminal ? flight_info.airportResources.arrivalTerminal : ""}/>
                                </Tooltip>
                                <Tooltip id="tooltip-arrival-gate" title="Arrival Gate">
                                    <ListItemText
                                        primary={flight_info.airportResources.arrivalGate ? flight_info.airportResources.arrivalGate : ""}/>
                                </Tooltip>
                            </ListItem>
                            {this.renderStepper(flight_info.status)}
                        </CardContent>
                        <CardActions>
                            <div className={classes.wrapper}>
                                <Button
                                    variant="fab"
                                    color="primary"
                                    className={existing_sub ? classes.buttonSuccess : classes.buttonNew}
                                    onClick={() => this.handleButtonClick(flight_info)}
                                >
                                    {existing_sub ? <Delete/> : <AddIcon/>}
                                </Button>
                                {this.state.loading ?
                                    <CircularProgress size={68} className={classes.fabProgress}/> : null}
                            </div>
                        </CardActions>
                    </Card>
                </div>
            </MuiThemeProvider>
        );
    }

}


class FlightStatusView extends React.Component {
    constructor(props) {
        super(props);
        this.state = {flightinfo: null, loading: true}
    }

    componentDidMount() {
        if (this.props.match.params.id) {
            $.get('/api/v1/flightstatus', {id: this.props.match.params.id}, (response) => {
                let flightinfo = response.data;
                this.setState({flightinfo: null});

            });
        } else if (this.props.match.params.src && this.props.match.params.dest && this.props.match.params.traveldate) {
            $.get('/api/v1/flightstatus', {
                src: this.props.match.params.src,
                dest: this.props.match.params.dest,
                traveldate: this.props.match.params.traveldate
            }, (response, status, jqXHR) => {
                if (jqXHR.status == 200) {
                    let flightinfo = response.data;
                    console.log(response.data);
                    this.setState({flightinfo: flightinfo, loading: false});
                } else {
                    //TODO toast
                    alert('Search Failed to Yield Any Result');
                    this.setState({flightinfo: null, loading: false});
                }

            });
        }
    }

    render() {
        const {classes} = this.props;
        if (!this.props.match.params.id &&
            (!this.props.match.params.src && !this.props.match.params.dest && !this.props.match.params.traveldate)) {
            return (<Redirect to='/'/>);
        }
        let flightdata = this.state.flightinfo;
        let flightnoFilterFailed = false;
        let filterFlightno = this.props.match.params.flightno;
        let flightnoFilterIncluded = (filterFlightno && filterFlightno.trim().length > 0 ? true : false);
        let airline_name_map = {};
        if (flightdata) {
            flightdata.appendix.airlines.forEach(airline => airline_name_map[airline.fs] = airline.name);
            flightdata.flightStatuses = flightdata.flightStatuses.filter((status) => status.airportResources);
            if(flightnoFilterIncluded) {
                filterFlightno = filterFlightno.split(' ').join('').toUpperCase();
                let matchingFlights = flightdata.flightStatuses.filter(s => (s.carrierFsCode + s.flightNumber) == filterFlightno);
                flightnoFilterFailed = matchingFlights.length <= 0;
                flightdata.flightStatuses = (matchingFlights.length > 0) ? matchingFlights : flightdata.flightStatuses;
            }
        }
        let flightid_subscription_map = {}
        if (this.props.subscriptions) {
            this.props.subscriptions.forEach(s => flightid_subscription_map['' + s.flightid] = s);
        }


        return (
            <MuiThemeProvider theme={theme}>
                <MenuBar history={this.props.history}/>
                {this.state.loading ?
                    <Grid><Grid item xs={12}><LinearProgress color="secondary"/></Grid></Grid> :
                    <Grid
                        container
                        spacing={24}
                        alignItems='center'
                        direction='row'
                        justify='center'>
                        <Grid key={-1} item xs={12}>
                            <Paper className={classes.root} elevation={4}>
                                <Typography variant="headline" color="primary" component="h3">
                                    {flightdata.appendix.airports[0].name + ', '
                                    + flightdata.appendix.airports[0].city + ' -- '
                                    + flightdata.appendix.airports[1].name + ', '
                                    + flightdata.appendix.airports[1].city
                                    }
                                </Typography>
                                <Typography variant="subheading">
                                    {flightdata.flightStatuses.length + ' Matching Search Results.'}
                                </Typography>
                                <Typography variant="subheading" color="secondary">
                                    {flightnoFilterFailed && flightnoFilterIncluded ? "We couldn't find a flight with the matching flight number. Here are some alternative flights available on the same date." : ""}
                                </Typography>
                            </Paper>

                        </Grid>
                        {flightdata.flightStatuses.map((flight_status, index) =>
                            <Grid key={index} item xl={4} md={6} lg={4} xs={12} s={12}>
                                <FlightStatusCard key={flight_status.flightId} index={index}
                                                  flight_info={flight_status}
                                                  airports={this.props.airports}
                                                  airline_name_map={airline_name_map}
                                                  flightid_subscription_map={flightid_subscription_map}
                                                  classes={classes} current_user={this.props.current_user}/></Grid>)

                        }
                    </Grid>
                }
            </MuiThemeProvider>
        );
    }
}

const mapStateToProps = state => {
    return {airports: state.airports, current_user: state.current_user, subscriptions: state.subscriptions}
};

const FlightStatus = connect(mapStateToProps)(FlightStatusView)
export default withStyles(styles)(withWidth()(FlightStatus));
