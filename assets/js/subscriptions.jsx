import React from 'react';
import MenuBar from './menu_bar';
import {MuiThemeProvider, createMuiTheme} from 'material-ui/styles';
import {FlightStatusCard} from './flight_status'
import withWidth from "material-ui/utils/withWidth";
import {withStyles} from "material-ui/styles/index";
import {connect} from "react-redux";
import {Redirect} from 'react-router-dom';
import blue from "material-ui/colors/blue";
import red from "material-ui/colors/red";
import Grid from 'material-ui/Grid';
import Typography from 'material-ui/Typography'
import Paper from 'material-ui/Paper';
import green from "material-ui/colors/green";

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

class SubscriptionsView extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        const {classes} = this.props;

        if (!this.props.current_user || !this.props.current_user.token) {
            return (<Redirect to='/'/>);
        }

        let flightStatuses = this.props.subscriptions.map((s) => s.flight_data);
        let flightid_subscription_map = {}
        this.props.subscriptions.forEach(s => flightid_subscription_map[s.flightid] = s);
        let airline_name_map = {};
        this.props.subscriptions.forEach(s => airline_name_map[''+s.flight_data.carrierFsCode] = s.airline_name);
        return (
            <MuiThemeProvider theme={theme}>
                <MenuBar history={this.props.history}/>
                <Grid
                    container
                    spacing={24}
                    alignItems='center'
                    direction='row'
                    justify='center'>
                    <Grid key={-1} item xs={12}>
                        <Paper className={classes.root} elevation={4}>
                            <Typography variant="headline" color="primary" component="h3">
                                Alert Subscriptions
                            </Typography>
                            <Typography variant="subheading">
                                {this.props.subscriptions.length + ' Active Subscriptions.'}
                            </Typography>
                        </Paper>
                    </Grid>
                    {flightStatuses.map((flight_status, index) =>
                        <Grid key={index} item xl={4} md={6} lg={4} xs={12} s={12}>
                            <FlightStatusCard key={flight_status.flightId} index={index}
                                              flight_info={flight_status}
                                              airports={this.props.airports}
                                              airline_name_map={airline_name_map}
                                              flightid_subscription_map={flightid_subscription_map}
                                              classes={classes} current_user={this.props.current_user}/></Grid>)

                    }
                </Grid>

            </MuiThemeProvider>
        );

    }
}

const mapStateToProps = state => {
    return {airports: state.airports, current_user: state.current_user, subscriptions: state.subscriptions}
};

const Subscriptions = connect(mapStateToProps)(SubscriptionsView)
export default withStyles(styles)(withWidth()(Subscriptions));