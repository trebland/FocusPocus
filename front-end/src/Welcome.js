import React, { Component } from 'react';
import 'whatwg-fetch';
import './css/stylesheet.css';
import ReactDOM from 'react-dom'
import {
  Route,
  Link,
  BrowserRouter as Router,
  Switch
} from "react-router-dom";

import AllUsers from "./AllUsers";
import Notfound from "./notfound";
import Summary from "./Summary";
import LogoPage from "./LogoPage";


class Welcome extends React.Component {

  state = {
      isLoading: true,
      token: 0,
      username: '',
      message: ''
    }; 

  constructor(props) {
    super(props);

    this.state = {
      isLoading: true,
      token: 0,
      username: '',
      message: ''
    };
  }

  componentDidMount() {



    this.setState({
      isLoading: false,
    });
  }



  render() {
    const {
      isLoading,
      token,
      username,
      message
    } = this.state;
    if (isLoading) {
      return (<div><p>Loading...</p></div>);
    }

    return (
      <div>
      <Router>
      <div>
          <ul>
            <div class="header">
              <Link class="hotbarFirst" to="/LogoPage">
                <button class="hotbarButton hotbarName">
                  Focus Pocus
                </button>
              </Link>
              <Link to="/Summary"><button class="hotbarButton">Summary</button></Link>
              <Link to="/AllUsers"><button class="hotbarButton">Load All Users</button></Link>
        </div>
          </ul>
          <Switch>
            <Route exact path="/Summary" component={Summary} />
            <Route path="/allUsers" component={AllUsers} />
            <Route path="/LogoPage" component={LogoPage} />

            <Route component={Notfound} />
          </Switch>
        </div>
      </Router>
      </div>  
    );
  }
}

export default Welcome;