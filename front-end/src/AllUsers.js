import React, { Component } from 'react';
import 'whatwg-fetch';
import './css/stylesheet.css';
import ReactDOM from 'react-dom'
import { Route, Link, BrowserRouter as Router } from 'react-router-dom'


class AllUsers extends Component {
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
      users: [],
    };   
  }


  componentDidMount() {

    /*
    fetch('http://54.221.121.199/loginUser/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username: 'Admin', password: '3p4SS100'}),
    }).then(response => response.json())
      .then(data => this.setState({
        token: data,
    })
    )
    */
    this.setState({users: [{username: "jeff", email: "jello@hy.com", fullName: ""},
                           {username: "Bill", email: "Bill@email.com", fullName: "Bill Boy"},
                           {username: "slothboy", email: "slothboy@email.com", fullName: "True Sloth Boy"}]
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
        	<h1>Load All Users</h1>
          
          <div class="container">
            <div>Username:</div><div>Full Name:</div><div>Email:</div>
            {this.state.users.map(user => (<><div>{user.username}</div><div>{user.fullName}</div><div>{user.email}</div></>))}
          </div>
        </div>
      );
    }
  }
}


export default AllUsers;