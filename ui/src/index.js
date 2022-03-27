import React from 'react';
import ReactDOM from 'react-dom';
import { Authenticator, useAuthenticator } from '@aws-amplify/ui-react';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import Amplify from 'aws-amplify';
// import config from './aws-exports';
import { Link, BrowserRouter as Router } from 'react-router-dom';
// Amplify.configure(config);

ReactDOM.render(

    <Router>
          <App />
    </Router>
  ,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();

/*
<React.StrictMode>
      <Authenticator.Provider>
          <App />
      </Authenticator.Provider>
  </React.StrictMode>
 */
