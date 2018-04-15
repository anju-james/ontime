import React from 'react';
import {Route, Switch, HashRouter} from 'react-router-dom';
import OnTimeHomePage from './ontime_homepage';


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
                </Switch>
            </HashRouter>
        </div>
        );
    }
}

export default OntimeSpa;
