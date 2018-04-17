import React from 'react';
import Grid from 'material-ui/Grid';
import MenuBar from './menu_bar';
import FlightSearch from './flight_search';
import FooterBar from './footer_bar';
import Hidden from 'material-ui/Hidden'
import withWidth from 'material-ui/utils/withWidth'
import { ToastContainer, toast } from 'react-toastify';


function OnTimeHomePage(props) {
    const {classes, theme} = props;

    return (
        <div>
            <Hidden mdDown>
            <div className=" drive-in-wrap">
                <div className="drive-in-media">
                    <video autoPlay="true" muted="true" preload="auto" loop="true" className="drive-in-video">
                        <source src="/images/Sky.mp4" type="video/mp4">
                        </source>
                    </video>
                </div>
            </div>
            </Hidden>
            <MenuBar transparent={props.width == 'lg' || props.width =='xl' ? true : false} history={props.history}/>
            <Grid
                container
                spacing={16}
                alignItems='center'
                direction='row'
                justify='center'
            >
                <Grid item xs={12}/>
                <Grid item xs={12}/>
                <Grid item xs={12}/>
                <Grid item xl={6} md={5} lg={5} xs={12} s={12}>
                    <FlightSearch history={props.history}/>
                </Grid>
            </Grid>

        </div>
    );
}

export default withWidth()(OnTimeHomePage);
