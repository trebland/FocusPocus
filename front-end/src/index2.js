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
import Welcome from "./Welcome"
import AllUsers from "./allUsers";
import Notfound from "./notfound";
import './css/stylesheet.css';

const routing = () => (
  <Router>
  	<div>
	      <ul>
	      	<div class="header">
	      		<Link class="hotbarFirst" to="/">
		      		<button class="hotbarButton hotbarName">
			      		Focus Pocus
		      		</button>
		      	</Link>
		      	<Link to="/Welcome"><button class="hotbarButton">Home</button></Link>
			    <Link to="/AllUsers"><button class="hotbarButton">Load All Users</button></Link>
			</div>
	      </ul>
	      <Switch>
	        <Route exact path="/Welcome" component={Welcome} />
	        <Route path="/allUsers" component={AllUsers} />

	        <Route component={Notfound} />
	      </Switch>
      </div>
  </Router>
);

ReactDOM.render(<routing />, document.getElementById("root"));
