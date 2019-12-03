import React, { Component } from 'react';
import 'whatwg-fetch';
import './css/stylesheet.css';
import ReactDOM from 'react-dom'
import { Route, Link, BrowserRouter as Router } from 'react-router-dom'


class AllUsers extends Component {
  state = {
      isLoading: true,
      token: 0,
      username: '',
      message: '',
      users: []
    }; 
  constructor(props) {
    super(props);

    this.state = {
      isLoading: true,
      token: 0,
      username: '',
      message: '',
      users: [],
    };

    
  }

  componentDidMount() {

    fetch('http://54.221.121.199/getAllUsers')
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
  
  row(user, i){
    return (
      <div>{i} - {user}</div>
    )
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
          All Users: 

          {this.state.users.map(user => (<p>username - {user.username}
          Full Name - {user.fullName}
          Email - {user.email}</p>))}
          
        </div>
      );
    }
  }
}


export default AllUsers;