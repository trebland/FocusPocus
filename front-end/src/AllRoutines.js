import React, { Component } from 'react';
import 'whatwg-fetch';
import './css/stylesheet.css';
import ReactDOM from 'react-dom'
import { Route, Link, BrowserRouter as Router } from 'react-router-dom'


class AllRoutines extends Component {
  state = {
      isLoading: true,
      token: 0,
      username: '',
      message: '',
      users: [],
      routines: []
    }; 
  constructor(props) {
    super(props);

    this.state = {
      isLoading: true,
      token: 0,
      username: '',
      message: '',
      routines: [],
    };   
  }

  componentDidMount() {
    /*
    fetch('http://54.221.121.199/getAllRoutines')
      .then(response => response.json())
      .then(users => this.setState({users}));
    */
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
      routines
    } = this.state;

    if (isLoading) {
      return (<div><p>Loading...</p></div>);
    }

    if (!token) {
      return (
        <div>
        	<h1>Load All Routines</h1>
          
          <div class="container">
            <div>Routine:</div><div>Pomodora Timer:</div><div>Break Timer:</div>
            {this.state.routines.map(routine => (<><div>{routine.routineName}</div><div>{routine.pomTimer}</div><div>{routine.breakTimer}</div></>))}
          </div>
        </div>
      );
    }
  }
}


export default AllRoutines;