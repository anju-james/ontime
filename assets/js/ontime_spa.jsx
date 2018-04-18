import React from 'react';
import {Route, Switch, HashRouter, Redirect} from 'react-router-dom';
import OnTimeHomePage from './ontime_homepage';
import FlightStatus from './flight_status';


class OntimeSpa extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return(
        <div>
            <HashRouter>
                <Switch>
                    <Route exact path='/' component={OnTimeHomePage}/>
                    <Route exact path='/flightinfobyid/:id' component={FlightStatus}/>
                    <Route path='/flightinfobyloc/:src/:dest/:traveldate' component={FlightStatus}/>
                    <Redirect from="*" to="/"/>
                </Switch>
            </HashRouter>
        </div>
        );
    }
}

export default OntimeSpa;
