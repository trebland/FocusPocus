import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import {
  Route,
  NavLink,
  Link,
  BrowserRouter as Router,
  Switch
} from "react-router-dom";
import App from "./App";
import Contact from "./contact";
import AllUsers from "./AllUsers";
import Notfound from "./notfound";
import './css/stylesheet.css';

const routing = (
  <Router>
  	<div>
	      <ul>
	      	<div class="header">
	      		<Link class="hotbarFirst" to="/">
		      		<button class="hotbarButton hotbarName">
			      		Focus Pocus
		      		</button>
		      	</Link>
		      	<Link to="/"><button class="hotbarButton">Home</button></Link>
			    </div>
	      </ul>
	      <Switch>
	        <Route exact path="/" component={App} />
	        


	        <Route component={Notfound} />
	      </Switch>
      </div>
  </Router>
);

ReactDOM.render(routing, document.getElementById("root"));
