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
      users: []
    }; 
  constructor(props) {
    super(props);

    this.state = {
      isLoading: true,
      token: '',
      username: '',
      message: '',
      users: []
    };

    
  }

  componentDidMount() {
    fetch('http://54.221.121.199/getAllUsers', this.state.token)
      .then(response => response.json())
      .then(users => this.setState({users}));

    this.setState({users: [{username: "Yeet", email: "a@a.com", fullName: "a a"},
                           {username: "lol", email: "b@b.com", fullName: "b b"},
                           {username: "omg", email: "c@c.com", fullName: "c c"}]
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
      users
    } = this.state;

    if (isLoading) {
      return (<div><p>Loading...</p></div>);
    }

    if (!token) {
      return (
        <div>
        	<h1>Summary</h1>

          <p>Total Users: {this.state.users.length}</p>
          
        </div>
      );
    }
  }
}


export default Summary;