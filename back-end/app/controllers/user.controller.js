// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
const User = require("../models/user.model.js");
const jwt = require("../jwt/jwtFunction.js");
const fs = require("fs");
const bcrypt = require("bcryptjs");
const Crypto = require("simple-crypto-js").default;
let secretKey  = fs.readFileSync('./config/secret.key', 'utf8');
let crypto = new Crypto(secretKey);

// Create and Save a new user
// JSON inputs required: username, email, and password
// outputs JSON: username and message
exports.register = (req, res) => {
  // Check required fields
  if (!req.body.username) {
    return res.status(400).json({
      message: "Username can not be empty."
    });
  }
  if (!req.body.email) {
    return res.status(400).json({
      message: "Email can not be empty."
    });
  }
  if (!req.body.password) {
    return res.status(400).json({
      message: "Password can not be empty."
    });
  }

  // Create a user
  const user = new User({
    username: req.body.username,
    email: req.body.email,
    fullName: req.body.fullName,
    password: req.body.password,
    admin: false
  });

  user.password = bcrypt.hashSync(user.password, 10);

  // Save user in the database
  user.save()
  .then(data => {
    res.json({
      username: data.username,
      message: "User " + data.username + " registered successfully!"
    });
  })
  .catch(err => {
    res.status(500).json({
      message: err.message || "An error occurred while registering the user."
    });
  });
}; // end register

// Login a user
// JSON inputs required: username and password
// outputs JSON: token, username, email, fullName,
// createdAt, updatedAt, and message
exports.login = (req, res) => {
  // Check required fields
  if (!req.body.username) {
    return res.status(400).json({
      message: "Username can not be empty."
    });
  }
  if (!req.body.password) {
    return res.status(400).json({
      message: "Password can not be empty."
    });
  }

  // find one user based on username
  User.findOne({ username: req.body.username })
    .then(user => {
      if (!user) {
        return res.status(500).json({
          message: "Could not find user."
        });
      }

      // check that the passwords match
      if ( !bcrypt.compareSync(req.body.password, user.password) ) {
        return res.json({
          message: "Incorect password."
        });
      }

      // encrypt user ID before putting into payload
      let cipher = crypto.encrypt(user._id);
      let payload = {
        userId: cipher,
      };
      let token = jwt.sign(payload);

      res.json({
        token: token,
        username: user.username,
        email: user.email,
        fullName: user.fullName,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        message: "User " + user.username + " login successfull!"
      });
    })
    .catch(err => {
      if (err.kind === "ObjectId") {
        return res.status(404).json({
          message: "Username is of the wrong kind."
        });
      }
      return res.status(404).json({
        message: "Could not find username " + req.body.username + "."
      });
    });
}; // end login

// Edit user
// JSON inputs required: token
// outputs JSON: token, username, email, fuullName, and message
exports.edit = (req, res) => {
  // Check required fields
  if (!req.body.token) {
    return res.status(400).json({
      message: "Token can not be empty."
    });
  }

  let token, userId;
  if ( jwt.verify(req.body.token) ) {
    // decode jwt, then decrypt user ID
    token = jwt.decode(req.body.token);
    userId = crypto.decrypt(token.payload.userId);
    // for some reason, decrypt has double quotes which need
    // to be removed from both front and back of the string
    userId = userId.substr(1, userId.length - 2);
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  // Find user by id and replace empty variables
  User.findById(userId)
    .then(user => {
      if (!user) {
        return res.status(404).json({
          message: "User not found with provided ID"
        });
      }
      if (!req.body.email) {
        req.body.email = user.email;
      }
      if (!req.body.fullName) {
        req.body.fullName = user.fullName;
      }
      // need to if else here because if password exists,
      // that means it needs to be replaced, so the password
      // must first be hashed before storing in the database
      if (!req.body.password) {
        req.body.password = user.password;
      }
      else {
        req.body.password = bcrypt.hashSync(req.body.password, 10);
      }

      // Find user by _id and update it
      User.findByIdAndUpdate(
        user._id,
        {
          email: req.body.email,
          fullName: req.body.fullName,
          password: req.body.password
        },
        { new: true }
      )
        .then(user => {
          if (!user) {
            return res.status(404).json({
              message: "User not found with provided ID"
            });
          }

          // encrypt user ID before putting into payload
          let cipher = crypto.encrypt(user._id);
          let payload = {
            userId: cipher,
          };
          let token = jwt.sign(payload);

          res.json({
            token: token,
            username: user.username,
            email: user.email,
            fullName: user.fullName,
            message: "User " + user.username + " successfully updated!"
          });
        })
        .catch(err => {
          if (err.kind === "ObjectId") {
            return res.status(404).json({
              message: "User not found with id provided ID"
            });
          }
          return res.status(500).json({
            message: "Error updating user with id provided ID"
          });
        });
    })
    .catch(err => {
      if (err.kind === "ObjectId") {
        return res.status(404).json({
          message: "User not found with provided ID"
        });
      }
      return res.status(500).json({
        message: "Error updating user with provided ID"
      });
    });
}; // end edit

// Delete a user
// JSON inputs required: token, username, and password
// outputs JSON: username and message
exports.delete = (req, res) => {
  // Check required fields
  if (!req.body.token) {
    return res.status(400).json({
      message: "Token can not be empty."
    });
  }
  if (!req.body.username) {
    return res.status(400).json({
      message: "Username can not be empty."
    });
  }
  if (!req.body.password) {
    return res.status(400).json({
      message: "Password can not be empty."
    });
  }

  let token, userId;
  if ( jwt.verify(req.body.token) ) {
    // decode jwt, then decrypt user ID
    token = jwt.decode(req.body.token);
    userId = crypto.decrypt(token.payload.userId);
    userId = userId.substr(1, userId.length - 2);
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  // check that userId matches
  User.findById(userId)
  .then(user => {
    if (!user) {
      return res.status(404).json({
        message: "User not found with provided ID"
      });
    }

    // check that the passwords match
    if ( !bcrypt.compareSync(req.body.password, user.password) ) {
      return res.json({
        message: "Incorect password."
      });
    }

    // check username and password matches before deleting
    User.findOneAndDelete({
      _id: userId,
      username: req.body.username
    })
      .then(user => {
        if (!user) {
          return res.status(404).json({
            message: "Username is incorrect."
          });
        }
        res.json({
          username: user.username,
          message: "User " + user.username + " deleted successfully!"
        });
      })
      .catch(err => {
        if (err.kind === "ObjectId" || err.name === "NotFound") {
          return res.status(404).json({
            message: "User " + req.body.username + " not found."
          });
        }
        return res.status(500).json({
          message: "Could not find user " + req.body.username + "."
        });
      });
  })
  .catch(err => {
    if (err.kind === "ObjectId") {
      return res.status(404).json({
        message: "User not found with provided ID"
      });
    }
    return res.status(500).json({
      message: "Error finding user with provided ID"
    });
  });
}; // end delete

// Retrieve and return all users from the database
// JSON inputs required: token from admin account
// outputs JSON: users array with all fields
exports.getAll = (req, res) => {
  // Check required fields
  if (!req.body.token) {
    return res.status(400).json({
      message: "Token can not be empty."
    });
  }

  let token, userId;
  if ( jwt.verify(req.body.token) ) {
    // decode jwt, then decrypt user ID
    token = jwt.decode(req.body.token);
    userId = crypto.decrypt(token.payload.userId);
    // for some reason, decrypt has double quotes which need
    // to be removed from both front and back of the string
    userId = userId.substr(1, userId.length - 2);
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  User.findOne({ _id: userId, admin: true })
    .then(user => {
      if (!user) {
        return res.json({
          message: "This user does not exist or does not have admin access."
        });
      }

      User.find()
        .then(users => {
          if (!users[0]) {
            return res.json({
              message: "No users exist in the database."
            });
          }
          res.json({ users });
        })
        .catch(err => {
          res.status(500).json({
            message: err.message || "Some error occurred while retrieving Users."
          });
        });
   })
    .catch(err => {
      if (err.kind === "ObjectId") {
        return res.status(404).json({
          message: "User not found with provided ID"
        });
      }
      res.status(500).json({
        message: err.message || "Some error occurred while retrieving User."
      });
    });
}; // end getAll
