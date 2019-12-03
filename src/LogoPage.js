import React from 'react';

class LogoPage extends React.Component {
  render() {
    return (
      <div>
       <img src={ require('./images/favicon.png')} alt="FP" class="MainTitle"/>
      </div>
    );
  }
}

export default LogoPage;
