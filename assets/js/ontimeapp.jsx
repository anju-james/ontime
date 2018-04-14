import React from 'react';
import Grid from 'material-ui/Grid';
import MenuBar from './menu_bar';


function OnTimeApp(props) {
    const {classes, theme} = props;

    return (
        <div>
            <div className=" drive-in-wrap">
                <div className="drive-in-media">
                    <video autoPlay="true" muted="true"  preload="auto" loop="true" className="drive-in-video">
                        <source src="/images/Sky.mp4" type="video/mp4">
                        </source></video>
                </div>
            </div>
            <MenuBar />
        <Grid
            container
            spacing={16}
            alignItems= 'center'
            direction='row'
            justify='center'
        >

        </Grid>
        </div>
    );
}

export default OnTimeApp;
