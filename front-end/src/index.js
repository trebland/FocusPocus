import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import Welcome from './Welcome';
import { Route, Link, BrowserRouter as Router, withRouter} from 'react-router-dom';


const Index = () => (
	        <Router>
	            <div>
	                <Route path="/" exact component={App} />
	                <Route exact path="/Welcome" exact component={Welcome} />
	            </div>
	        </Router> 
);

ReactDOM.render(<Index />, document.getElementById('root'));