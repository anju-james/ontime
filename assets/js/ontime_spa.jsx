import React from 'react';
import {Route, Switch, HashRouter} from 'react-router-dom';
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
                    <Route exact path='/flightinfobyloc/:src/:dest' component={FlightStatus}/>

                </Switch>
            </HashRouter>
        </div>
        );
    }
}

export default OntimeSpa;
