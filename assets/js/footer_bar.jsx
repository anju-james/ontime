import React from 'react';
import { withStyles } from 'material-ui/styles';
import BottomNavigation, { BottomNavigationAction } from 'material-ui/BottomNavigation';
import Icon from 'material-ui/Icon';
import RestoreIcon from '@material-ui/icons/Restore';
import FavoriteIcon from '@material-ui/icons/Favorite';
import LocationOnIcon from '@material-ui/icons/LocationOn';

const styles = {
    root: {
        width: 500,
    },
};

class FooterBar extends React.Component {
    constructor(props) {
        super(props);


    }

    render() {


        return (
            <div className="footer">
                Made by Anju James Arcy Flores
            </div>
        );
    }
}



export default withStyles(styles)(FooterBar);