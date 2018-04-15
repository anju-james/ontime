import React from 'react';
import {withStyles} from 'material-ui/styles';
import classnames from 'classnames';
import Card, {CardHeader, CardMedia, CardContent, CardActions} from 'material-ui/Card';
import Collapse from 'material-ui/transitions/Collapse';
import Flight from '@material-ui/icons/Flight';
import Avatar from 'material-ui/Avatar';
import {FormControl, FormHelperText} from 'material-ui/Form';
import Input, {InputLabel, InputAdornment} from 'material-ui/Input';
import Button from 'material-ui/Button';
import blue from "material-ui/colors/blue";
import {MuiThemeProvider, createMuiTheme} from 'material-ui/styles';
import ActionSettings from '@material-ui/icons/Settings';
import TextField from 'material-ui/TextField';



const theme = createMuiTheme({
    palette: {
        primary: blue,
    }
});


const styles = theme => ({
    card: {
        maxWidth: 400,
    },
    media: {
        height: 194,
    },
    actions: {
        display: 'flex',
    },
    expand: {
        transform: 'rotate(0deg)',
        transition: theme.transitions.create('transform', {
            duration: theme.transitions.duration.shortest,
        }),
        marginLeft: 'auto',
    },
    expandOpen: {
        transform: 'rotate(360deg)',
    },
    avatar: {
        margin: 10,
        backgroundColor: blue[500],
    },
    container: {
        display: 'flex',
        flexWrap: 'wrap',
    },
    formControl: {
        margin: theme.spacing.unit,
    },
    rightIcon: {
        marginLeft: theme.spacing.unit,
    },
    iconSmall: {
        fontSize: 20,
    },

});

class FlightSearch extends React.Component {
    state = {expanded: false};

    handleExpandClick = () => {
        this.setState({expanded: !this.state.expanded});
    };

    render() {
        const {classes} = this.props;

        return (
            <MuiThemeProvider theme={theme}>
                <div>
                    <Card className={classes.card}>
                        <CardHeader
                            avatar={
                                <Avatar aria-label="Recipe" className={classes.avatar}>
                                    <Flight/>
                                </Avatar>
                            }

                            title="Search Your Flight"
                            subheader="Use Advanced Search For More Options"
                        />

                        <CardContent>
                            <div >
                                <FormControl className={classes.formControl}
                                             aria-describedby="name-error-text" >
                                    <InputLabel htmlFor="flightnumber">Enter Flight Number</InputLabel>
                                    <Input id="flightnumber" name="flightnumber" value="" onChange={this.handleChange}/>
                                </FormControl>
                                <FormControl className={classes.formControl}>
                                    <Button size="medium" color="primary" variant="raised">
                                        Go
                                    </Button>
                                </FormControl>
                            </div>
                        </CardContent>
                        <CardActions className={classes.actions} disableActionSpacing>

                            <Button
                                className={classnames(classes.expand, {
                                    [classes.expandOpen]: this.state.expanded,
                                })}
                                onClick={this.handleExpandClick}
                                aria-expanded={this.state.expanded}
                                aria-label="Show more"
                            >

                                Advanced Search
                                <ActionSettings className={classnames(classes.rightIcon, classes.iconSmall)} />
                            </Button>
                        </CardActions>
                        <Collapse in={this.state.expanded} timeout="auto" unmountOnExit>

                            <CardContent>
                                <div>
                                <FormControl className={classes.formControl}
                                             aria-describedby="name-error-text">
                                    <InputLabel htmlFor="departure">Departure</InputLabel>
                                    <Input id="departure" name="departure" value="" onChange={this.handleChange}/>
                                </FormControl>
                                <FormControl className={classes.formControl}
                                             aria-describedby="name-error-text">
                                    <InputLabel htmlFor="arrival">Arrival</InputLabel>
                                    <Input id="arrival" name="arrival" value="" onChange={this.handleChange}/>
                                </FormControl>
                                <Button variant="raised" color="primary" className={classes.formControl}>
                                    Search
                                </Button>
                                </div>
                            </CardContent>

                        </Collapse>
                    </Card>
                </div>
            </MuiThemeProvider>
        );
    }
}


export default withStyles(styles)(FlightSearch);

