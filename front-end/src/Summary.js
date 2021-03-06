import React, { Component } from 'react';
import 'whatwg-fetch';
import './css/stylesheet.css';
import ReactDOM from 'react-dom'
import { Route, Link, BrowserRouter as Router } from 'react-router-dom'

class Summary extends Component {
  state = {
      isLoading: true,
      token: '',
      username: '',
      message: '',
      users: [],
      routines: []
    }; 
  constructor(props) {
    super(props);

    this.state = {
      isLoading: true,
      token: '',
      username: '',
      message: '',
      users: [],
      routines: []
    };

    
  }

  componentDidMount() {
    fetch('http://54.221.121.199/getAllUsers')
      .then(response => response.json())
      .then(users => this.setState({users}));

    this.setState({users: [{username: "SwagKing09", email: "swagking09@email.com", fullName: "Steve King"},
                           {username: "MoreSoupPlz", email: "moresoup@email.com", fullName: "Moore Campbell"},
                           {username: "HeartOfAir", email: "flight@email.com", fullName: "Amelia Earhart"}]
                  })
    this.setState({routines: [{routineName: "Study", pomTimer: "25", breakTimer: "5"},
                           {routineName: "Run", pomTimer: "15", breakTimer: "5"},
                           {routineName: "Read", pomTimer: "30", breakTimer: "5"}]
                  })

    this.setState({
      isLoading: false,
    });
  }

  render() {
    const {
      isLoading,
      token,
      username,
      message,
      users,
      routines
    } = this.state;

    if (isLoading) {
      return (<div><p>Loading...</p></div>);
    }

    if (!token) {
      return (
        <div>
        	<h1>Summary</h1>

          <p>Total Users: {this.state.users.length}</p>
          <p>Total Routines: {this.state.routines.length}</p>
          
        </div>
      );
    }
  }
}


export default Summary;