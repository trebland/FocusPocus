import React, { Component } from 'react';
import './css/stylesheet.css';
import ReactDOM from 'react-dom';
import { Route, Link, BrowserRouter as Router, withRouter} from 'react-router-dom';

class App extends React.Component {

  state = {
      isLoading: true,
      token: '',
      username: '',
      password: '',
      email: '',
      fullName: '',
      message: ''
    }; 

  constructor(props) {
    super(props);
    this.state = {
      isLoading: true,
      token: '',
      username: '',
      password: '',
      email: '',
      fullName: '',
      message: ''
    }; 
  }

  componentDidMount() {
      this.setState({
        isLoading: false,
      });
  }

  handleChange = event => {
    const value = event.target.value;
    this.setState({
      input: value
    });
  };

  Login = event => {
    const {username, password} = this.state;

    fetch('http://54.221.121.199/loginUser')
      .then(response => response.json())
      .then(token => this.setState({token}));

    if (!(username==="user" && password==="123")){
      alert("fail");
      return;
    }

    alert("you're logged in");
    this.props.history.push("Welcome");
  }

  handleUsername = event => {
    const value = event.target.value;
    this.setState({
      username: value
    });
  };

  handlePassword = event => {
    const value = event.target.value;
    this.setState({
      password: value
    });
  };

  render() {
    const {
      isLoading,
      token,
      userID,
      password,
      email,
      fullName,
      message
    } = this.state;

    if (isLoading) {
      return (<div><p>Loading...</p></div>);
    }

    return (
      <div class="loginBox">
        <form onSubmit={this.Login}>
        	<h1>Sign In</h1>
          <br/>
          
          <div>Username: {this.state.username}</div>
          <div>Password: {this.state.password}</div>

          <div>
            <input
              type="username"
              value={this.state.username}
              onChange={this.handleUsername}
              placeholder="username"
            />
            <br />
            <input
              type="password"
              value={this.state.password}
              onChange={this.handlePassword}
              placeholder="password"
            />
            <br />
            <button type='submit' class="loginButton"><span>Sign In</span></button>
          </div>
        </form>
      </div>
    );
  }
}

export default App;