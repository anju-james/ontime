import React from 'react';
import {withStyles} from 'material-ui/styles';
import classnames from 'classnames';
import Card, {CardHeader, CardContent, CardActions} from 'material-ui/Card';
import Collapse from 'material-ui/transitions/Collapse';
import Flight from '@material-ui/icons/Flight';
import FilterList from '@material-ui/icons/FilterList';
import Avatar from 'material-ui/Avatar';
import {FormControl, FormHelperText} from 'material-ui/Form';
import Input, {InputLabel} from 'material-ui/Input'
import Chip from 'material-ui/Chip';
import Button from 'material-ui/Button';
import blue from "material-ui/colors/blue";
import {MuiThemeProvider, createMuiTheme} from 'material-ui/styles';
import ActionSettings from '@material-ui/icons/Settings';
import TextField from 'material-ui/TextField';
import Paper from 'material-ui/Paper';
import { MenuItem } from 'material-ui/Menu';
import Downshift from 'downshift';
import {update_adv_search_form, update_airports, update_login_form} from "./actions";
import store, {empty_adv_search_form} from './store';
import {connect} from "react-redux";
import keycode from 'keycode';
import {toast} from 'react-toastify';



const theme = createMuiTheme({
    palette: {
        primary: blue,
    }
});


const styles = theme => ({
    card: {
        maxWidth: 500,
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
    formControl: {
        margin: theme.spacing.unit,
    },
    rightIcon: {
        marginLeft: theme.spacing.unit,
    },
    iconSmall: {
        fontSize: 20,
    },
    container: {
        flexGrow: 1,
        position: 'relative',
    },
    paper: {
        position: 'absolute',
        zIndex: 1,
        marginTop: theme.spacing.unit,
        left: 0,
        right: 0,
    },
    inputRoot: {
        flexWrap: 'wrap',
    },
    chip: {
        margin: `${theme.spacing.unit / 2}px ${theme.spacing.unit / 4}px`,
    },

});

function renderInput(inputProps) {
    const { InputProps, classes, ref, ...other } = inputProps;

    return (
        <TextField
            InputProps={{
                inputRef: ref,
                classes: {
                    root: classes.inputRoot,
                },
                ...InputProps,
            }}
            {...other}
        />
    );
}

function renderSuggestion({ suggestion, index, itemProps, highlightedIndex, selectedItem }) {

    const isHighlighted = highlightedIndex === index;
    const isSelected = (selectedItem || '').indexOf(suggestion.iata) > -1;

    return (
        <MenuItem
            {...itemProps}
            key={suggestion.iata}
            selected={isHighlighted}
            component="div"
            style={{
                fontWeight: isSelected ? 500 : 400,
            }}
        >
            {suggestion.name}
        </MenuItem>
    );
}

function getSuggestions(inputValue, suggestions) {
    let count = 0;

    return suggestions.filter(suggestion => {
        const keep =
            (!inputValue || suggestion.city.toLowerCase().indexOf(inputValue.toLowerCase()) !== -1
                || suggestion.name.toLowerCase().indexOf(inputValue.toLowerCase()) !== -1
                || suggestion.iata.toLowerCase().indexOf(inputValue.toLowerCase()) !== -1
                && count < 5);

        if (keep) {
            count += 1;
        }

        return keep;
    });
}


class DownshiftMultiple extends React.Component {
    constructor(props) {
        super(props);
        let storeValue = this.props.adv_search_form[this.props.name];
        let initialValue = storeValue && storeValue.trim().length > 0 ? [storeValue] : [];
        this.state = {
            inputValue: '',
            selectedItem: initialValue,
        };
    }


    handleKeyDown = event => {
        const { inputValue, selectedItem } = this.state;
        if (selectedItem.length && !inputValue.length && keycode(event) === 'backspace') {
            let data = {};
            data[this.props.name] = "";
            store.dispatch(update_adv_search_form(data));
            this.setState({
                selectedItem: selectedItem.slice(0, selectedItem.length - 1),
            });
        } else if (keycode(event) === 'tab' && selectedItem.length == 0) {
            let result = getSuggestions(inputValue, this.props.airports);
            if (result && result.length > 0) {
                let item = result[0].iata;
                let data = {};
                data[this.props.name] = item;
                store.dispatch(update_adv_search_form(data));
                this.setState({inputValue: '',selectedItem: [item]});
            } else {
                let data = {};
                data[this.props.name] = '';
                store.dispatch(update_adv_search_form(data));
                this.setState({inputValue: ''});
            }

        }
    };

    handleInputChange = event => {
        this.setState({ inputValue: event.target.value });
    };

    handleChange = item => {
        let { selectedItem } = this.state;
        selectedItem = [item];
        let data = {};
        data[this.props.name] = item;
        store.dispatch(update_adv_search_form(data));
        this.setState({
            inputValue: '',
            selectedItem,
        });
    };

    handleDelete = item => () => {
        const selectedItem = [...this.state.selectedItem];
        selectedItem.splice(selectedItem.indexOf(item), 1);
        let data = {};
        data[this.props.name] = "";
        store.dispatch(update_adv_search_form(data));
        this.setState({ selectedItem });
    };

    render() {
        const { classes } = this.props;
        const { inputValue, selectedItem } = this.state;

        return (
            <Downshift inputValue={inputValue} onChange={this.handleChange} selectedItem={selectedItem}>
                {({
                      getInputProps,
                      getItemProps,
                      isOpen,
                      inputValue: inputValue2,
                      selectedItem: selectedItem2,
                      highlightedIndex,
                  }) => (
                    <div className={classes.container}>
                        {renderInput({
                            fullWidth: true,
                            classes,
                            InputProps: getInputProps({
                                startAdornment: selectedItem.map(item => (
                                    <Chip
                                        key={item}
                                        tabIndex={-1}
                                        label={item}
                                        className={classes.chip}
                                        onDelete={this.handleDelete(item)}
                                    />
                                )),
                                onChange: this.handleInputChange,
                                onKeyDown: this.handleKeyDown,
                                placeholder: selectedItem.length == 0 ? this.props.placeholder: '',
                                id: this.props.name,
                                name: this.props.name
                            }),
                        })}
                        {isOpen ? (
                            <Paper className={classes.paper} square>
                                {getSuggestions(inputValue2, this.props.airports).map((suggestion, index) =>
                                    renderSuggestion({
                                        suggestion,
                                        index,
                                        itemProps: getItemProps({ item: suggestion.iata }),
                                        highlightedIndex,
                                        selectedItem: selectedItem2,
                                    }),
                                )}
                            </Paper>
                        ) : null}
                    </div>
                )}
            </Downshift>
        );
    }
}

class FlightSearchView extends React.Component {
    constructor(props) {
        super(props);
        let flightnumber = this.props.adv_search_form.flightnumber;
        let openExpanded = (flightnumber && flightnumber.trim().length > 0) ? true : false;
        this.state = {expanded: openExpanded};
        this.handleAdvanceSearch = this.handleAdvanceSearch.bind(this);
        this.handleChange = this.handleChange.bind(this);
    }

    componentDidMount() {
        $.get('/api/v1/airports', (response) => {
            let airports = response.data;
            store.dispatch(update_airports(airports));
        });
    }

    handleExpandClick = () => {
        this.setState({expanded: !this.state.expanded});
    };

    handleChange(event) {
        let tgt = $(event.target);
        let data = {};
        data[tgt.attr('name')] = tgt.val();
        store.dispatch(update_adv_search_form(data));
    };

    handleAdvanceSearch() {
        let origin = this.props.adv_search_form.origin;
        let destination = this.props.adv_search_form.destination;
        let traveldate = this.props.adv_search_form.traveldate;
        let flightno = this.props.adv_search_form.flightnumber;
        if (origin && destination && traveldate && flightno.trim().length == 0) {            
            this.props.history.push('/flightinfobyloc/'+origin+'/'+destination+ '/'+traveldate);
        } else if (origin && destination && traveldate && flightno.trim().length > 0) {        
            this.props.history.push('/flightinfobylocfiltered/'+origin+'/'+destination+ '/'+traveldate+ '/' +flightno);
        } else {
            toast.error('Origin/Destination airports & travel date are needed to search');
        }

    }

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
                            <div>
                                <FormControl fullWidth={true} className={classes.formControl}
                                             aria-describedby="name-error-text">
                                    <DownshiftMultiple classes={classes} airports={this.props.airports} 
                                    adv_search_form={this.props.adv_search_form} name="origin" placeholder="Origin"/>
                                </FormControl>
                                <FormControl fullWidth={true} className={classes.formControl}
                                             aria-describedby="name-error-text">
                                    <DownshiftMultiple classes={classes} airports={this.props.airports} 
                                    adv_search_form={this.props.adv_search_form} name="destination" placeholder="Destination"/>
                                </FormControl>
                                <FormControl className={classes.formControl}>
                                    <TextField
                                        id="traveldate"
                                        name="traveldate"
                                        label="Flight Date"
                                        type="date"
                                        defaultValue={this.props.adv_search_form.traveldate}
                                        className={classes.textField}
                                        onChange={this.handleChange}
                                        InputLabelProps={{
                                            shrink: true,
                                        }}
                                    />
                                    </FormControl>
                                <FormControl className={classes.formControl}>
                                    <Button variant="raised" color="primary" onClick={this.handleAdvanceSearch} className={classes.formControl}>
                                        Search
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

                                Additional Filters
                                <FilterList className={classnames(classes.rightIcon, classes.iconSmall)}/>
                            </Button>
                        </CardActions>
                        <Collapse in={this.state.expanded} timeout="auto" unmountOnExit>
                            <CardContent>
                                <div>
                                    <FormControl className={classes.formControl}
                                                 aria-describedby="name-error-text">
                                        <InputLabel htmlFor="flightnumber">Filter By Flight Number</InputLabel>
                                        <Input id="flightnumber" name="flightnumber" value={this.props.adv_search_form.flightnumber} onChange={this.handleChange}/>
                                    </FormControl>
                                </div>
                            </CardContent>

                        </Collapse>
                    </Card>
                </div>
            </MuiThemeProvider>
        );
    }
}

const mapStateToProps = state => {
    return {airports: state.airports, adv_search_form: state.adv_search_form}
};

const FlightSearch = connect(mapStateToProps)(FlightSearchView);
export default withStyles(styles)(FlightSearch);

