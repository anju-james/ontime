import React from 'react';
import {withStyles} from 'material-ui/styles';
import Card, {CardActions, CardContent, CardMedia} from 'material-ui/Card';
import Button from 'material-ui/Button';
import {connect} from "react-redux";
import List, {ListItem, ListItemIcon, ListItemText} from 'material-ui/List';
import FlightTakeoff from '@material-ui/icons/FlightTakeoff';
import FlightLand from '@material-ui/icons/FlightLand';
import AddAlert from '@material-ui/icons/AddAlert';
import Email from '@material-ui/icons/Email';
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
import { LinearProgress,CircularProgress} from 'material-ui/Progress';
import { toast } from 'react-toastify';

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
            backgroundColor: green[500],
        },
    },
    buttonSuccess: {
        backgroundColor: green[500],
        '&:hover': {
            backgroundColor: blue[500],
        },
    },
    fabProgress: {
        color: green[500],
        position: 'absolute',
        top: -6,
        left: -6,
        zIndex: 1,
    },

};

class FlightStatusCard extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            loading: false,
            success: false,
        };

    }

    renderStepper(status) {
        if (status == 'scheduled') {
            return (<Hidden smDown><Stepper><Step key="S"><StepButton completed={true}>Scheduled
            </StepButton></Step><Step key="E"><StepButton completed={false}>En-route
            </StepButton></Step>
                <Step key="L"><StepButton completed={false}>Landed
                </StepButton></Step></Stepper></Hidden>);
        } else if (status == 'active') {
            return (<Hidden smDown><Stepper><Step key="S"><StepButton completed={true}>Scheduled
            </StepButton></Step>
                <Step key="E"><StepButton completed={true}>En-route
                </StepButton></Step><Step key="L"><StepButton completed={false}>Landed
                </StepButton></Step></Stepper></Hidden>);

        } else if (status == 'landed') {
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

    handleButtonClick = () => {
        if (!this.props.current_user || !this.props.current_user.token) {
            toast.warn('You need to login before setting up alerts');
            return;
        }
        if (!this.state.loading) {
            this.setState(
                {
                    success: false,
                    loading: true,
                },
                () => {
                    this.timer = setTimeout(() => {
                        this.setState({
                            loading: false,
                            success: true,
                        });
                    }, 2000);
                },
            );
        }
    };

    render() {
        const {classes} = this.props;

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
                                    label={this.props.flight_info.flight.iataNumber}
                                    className={classes.chip}
                                />
                                <ListItemText primary={this.props.flight_info.airline.name}/>
                            </ListItem>

                            <ListItem>
                                <ListItemIcon>
                                    <FlightTakeoff nativeColor="blue"/>
                                </ListItemIcon>
                                <ListItemText primary={this.props.flight_info.departure.iataCode}/>
                                <ListItemText
                                    primary={moment(this.props.flight_info.departure.scheduledTime).format('MM/DD/YYYY h:mm a')}/>
                                <Tooltip id="tooltip-origin-terminal" title="Boarding Terminal">
                                    <ListItemText primary={this.props.flight_info.departure.terminal}/>
                                </Tooltip>
                                <Tooltip id="tooltip-origin-gate" title="Boarding Gate">
                                    <ListItemText primary={this.props.flight_info.departure.gate} color="primary"/>
                                </Tooltip>
                            </ListItem>

                            <ListItem>
                                <ListItemIcon>
                                    <FlightLand nativeColor="red"/>
                                </ListItemIcon>
                                <ListItemText primary={this.props.flight_info.arrival.iataCode}/>
                                <ListItemText
                                    primary={moment(this.props.flight_info.arrival.scheduledTime).format('MM/DD/YYYY h:mm a')}/>
                                <Tooltip id="tooltip-arrival-terminal" title="Arrival Terminal">
                                    <ListItemText primary={this.props.flight_info.arrival.terminal}/>
                                </Tooltip>
                                <Tooltip id="tooltip-arrival-gate" title="Arrival Gate">
                                    <ListItemText primary={this.props.flight_info.arrival.gate}/>
                                </Tooltip>
                            </ListItem>
                            {this.renderStepper(this.props.flight_info.status)}
                        </CardContent>
                        <CardActions>
                            <div className={classes.wrapper}>
                                <Button
                                    variant="fab"
                                    color="primary"
                                    className={this.state.success ? classes.buttonSuccess : classes.buttonNew}
                                    onClick={this.handleButtonClick}
                                >
                                    {this.state.success ? <Email /> : <AddAlert />}
                                </Button>
                                {this.state.loading && <CircularProgress size={68} className={classes.fabProgress} />}
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
        this.state = {flightinfo: [], loading: true}
    }

    componentDidMount() {
        if (this.props.match.params.id) {
            $.get('/api/v1/flightstatus', {id: this.props.match.params.id}, (response) => {
                let flightinfo = response.data;
                this.setState({flightinfo: flightinfo});

            });
        } else if (this.props.match.params.src && this.props.match.params.dest) {
            $.get('/api/v1/flightstatus', {
                src: this.props.match.params.src,
                dest: this.props.match.params.dest
            }, (response, status, jqXHR) => {
                if (jqXHR.status == 200) {
                    let flightinfo = response.data;
                    console.log(response.data);
                    this.setState({flightinfo: flightinfo, loading: false});
                } else {
                    //TODO toast
                    alert('Search Failed to Yield Any Result');
                    this.setState({flightinfo: [], loading: false});
                }

            });
        }
    }

    render() {
        const {classes} = this.props;
        if (!this.props.match.params.id &&
            (!this.props.match.params.src && !this.props.match.params.dest)) {
            return (<Redirect to='/'/>);
        }
        console.log('rendering',)
        return (
            <MuiThemeProvider theme={theme}>
                <MenuBar history={this.props.history}/>
                {this.state.loading ?
                    <Grid><Grid item xs={12}><LinearProgress color="secondary" /></Grid></Grid>:
                    <Grid
                    container
                    spacing={24}
                    alignItems='center'
                    direction='row'
                    justify='center'>
                    <Grid key={-1} item xs={12}/>
                    {this.state.flightinfo.map((flight_status, index) =>
                        <Grid key={index} item xl={4} md={6} lg={4} xs={12} s={12}>
                            <FlightStatusCard key={index} index={index}
                                              flight_info={flight_status}
                                              airports={this.props.airports}
                                              classes={classes} current_user={this.props.current_user}/></Grid>)

                    }
                    </Grid>
                }
            </MuiThemeProvider>
        );
    }
}

const mapStateToProps = state => {
    return {airports: state.airports,current_user: state.current_user}
};

const FlightStatus = connect(mapStateToProps)(FlightStatusView)
export default withStyles(styles)(withWidth()(FlightStatus));
