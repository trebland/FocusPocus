// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
const fs   = require('fs');
const jwt   = require('jsonwebtoken');

// use 'utf8' to get string instead of byte array  (512 bit key)
let privateKEY  = fs.readFileSync('./config/private.key', 'utf8');
let publicKEY  = fs.readFileSync('./config/public.key', 'utf8');

module.exports = {
  sign: (payload) => {
    // Token signing options
    let signOptions = {
      issuer: "Focus Pocus",
      expiresIn: "1h",
      algorithm: "RS256"
    };

    return jwt.sign(payload, privateKEY, signOptions);
  },

  verify: (token) => {
    let verifyOptions = {
      issuer: "Focus Pocus",
      expiresIn: "1h",
      algorithm: ["RS256"]
    };
    try {
      return jwt.verify(token, publicKEY, verifyOptions);
    }
    catch (err) {
      return false;
    }
  },

  decode: (token) => {
    return jwt.decode(token, { complete: true });
    //returns null if token is invalid
  }
}
