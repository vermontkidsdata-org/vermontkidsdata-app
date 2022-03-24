import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import '@aws-amplify/ui-react/styles.css';
import {  Route, Routes } from "react-router-dom";
import { Authenticator, useAuthenticator } from '@aws-amplify/ui-react';
import Layout from "./pages/Layout";
import FileUpload from "./pages/FileUpload";
import Home from "./pages/Home";
import HighChart from "./pages/HighChart";
import MaterialTable from "./pages/MaterialTable";

//Vermont Kids Data

class AuthComponent extends Component  {
    render() {
        return <Authenticator>
            {({ signOut, user }) => (
                <div className="App">
                    <p>
                        Hey {user.username}, welcome to my channel, with auth!
                    </p>
                    <button onClick={signOut}>Sign out</button>
                </div>
            )}
        </Authenticator>;
    }
}
const AppRoutes = () => (
    <Routes >
        <Route path="/" element={<Layout/>} />
        <Route index element={<Home/>}/>
        <Route path="upload" element={<FileUpload/>}/>
        <Route path="chart" element={<HighChart/>}/>
        <Route path="table" element={<MaterialTable/>}/>
        <Route path="login" element={<AuthComponent/>}/>
    </Routes>
);

function App() {

  //const { user } = useAuthenticator((context) => [context.user]);
  //const { route } = useAuthenticator(context => [context.route]);
  //console.log(user);
  //console.log(route);

  return (

    <div className="App">
        <AppRoutes />
    </div>
  );
}

export default App;

/*

<BrowserRouter>
            <Routes>
                <Route path="/" element={<Layout/>}>
                    <Route index element={<Home/>}/>
                    <Route path="upload" element={<FileUpload/>}/>
                    <Route path="chart" element={<HighChart/>}/>
                </Route>
            </Routes>
        </BrowserRouter>

{ user &&
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<Layout/>}>
                    <Route index element={<Home/>}/>
                    <Route path="upload" element={<FileUpload/>}/>
                    <Route path="chart" element={<HighChart/>}/>
                </Route>
            </Routes>
        </BrowserRouter>
        }
<Authenticator>
            {({ signOut, user }) => (
                <div className="App">
                    <p>
                        Hey {user.username}, welcome to my channel, with auth!
                    </p>
                    <button onClick={signOut}>Sign out</button>
                </div>
            )}
        </Authenticator>
 */
