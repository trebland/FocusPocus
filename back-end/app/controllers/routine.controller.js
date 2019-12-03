// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
const Routine = require("../models/routine.model.js");
const User = require("../models/user.model.js");
const jwt = require("../jwt/jwtFunction.js");
const fs = require("fs");
const bcrypt = require("bcryptjs");
const Crypto = require("simple-crypto-js").default;
let secretKey  = fs.readFileSync('./config/secret.key', 'utf8');
let crypto = new Crypto(secretKey);

// Create a new routine
// JSON inputs required: token, routineName, and coffeeNap
// outputs JSON: token, routine, and message
// routine will always contain _id, routineName, and coffeeNap
// routine will contain these optional fields if you pass them in:
// pomTimer, breakTimer, pomCount, breakCount, largeBreakCount, and goalHit
exports.create = (req, res) => {
  // check required fields
  if (!req.body.token) {
    return res.status(400).json({
      message: "Token can not be empty."
    });
  }
  if (!req.body.routineName) {
    return res.status(400).json({
      message: "Routine name can not be empty."
    });
  }
  if (req.body.coffeeNap === undefined) {
    return res.status(400).json({
      message: "Coffee Nap can not be empty."
    });
  }

  let token, userId;
  if ( jwt.verify(req.body.token) ) {
    // decode jwt, then decrypt user ID
    token = jwt.decode(req.body.token);
    userId = crypto.decrypt(token.payload.userId);
    if (userId.length == 26) {
      userId = userId.substr(1, userId.length - 2);
    }
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  // create routine
  const routineData = new Routine({
    userId: userId,
    routineName: req.body.routineName,
    coffeeNap: req.body.coffeeNap,
    napTimer: req.body.napTimer,
    pomTimer: req.body.pomTimer,
    breakTimer: req.body.breakTimer,
    pomCount: req.body.pomCount,
    breakCount: req.body.breakCount,
    largeBreakCount: req.body.largeBreakCount,
    goalHit: req.body.goalHit,
  });

  // Save the routine in the database
  routineData.save()
    .then(routine => {

      // encrypt user ID before putting into payload
      let cipher = crypto.encrypt(routine.userId);
      let payload = {
        userId: cipher,
      };
      let token = jwt.sign(payload);

      // remove userId field, otherwise what was the point of
      // encrypting userId before putting into jwt
      routine.userId = undefined;

      res.json({
        token: token,
        routine,
        message: "Routine " + routine.routineName + " created successfully!"
      });
    })
    .catch(err => {
      res.status(500).json({
        message: err.message || "Some error occurred while creating the routine."
      });
    });
}; // end create

// Retrieve and return all the user's routines from the database
// JSON inputs required: token
// outputs JSON: token, array of routines associated to the
// userId, and message
exports.userRoutines = (req, res) => {
  // check required fields
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
    if (userId.length == 26) {
      userId = userId.substr(1, userId.length - 2);
    }
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  // find routines based on userId
  Routine.find({ userId: userId })
    .then(routines => {
      if (!routines[0]) {
        return res.status(404).json({
          message: "No routines for this user exist in the database."
        });
      }

      // encrypt user ID before putting into payload
      let cipher = crypto.encrypt(userId);
      let payload = {
        userId: cipher,
      };
      let token = jwt.sign(payload);

      for (let i = 0; i < routines.length; i++) {
        routines[i].userId = undefined;
      }

      res.json({
        token: token,
        routines,
        message: "Successfully got user routines."
      });
    })
    .catch(err => {
      res.status(500).json({
        message: err.message || "Some error occurred while retrieving the user's routines."
      });
    });
}; // end userRoutines

// Edit a routine
// JSON inputs required: token and _id
// outputs JSON: token, updated routine with all
// fields except userId, and message
// don't need to check coffeeNap b/c no need to edit coffee naps
exports.edit = (req, res) => {
  // Check required fields
  if (!req.body.token) {
    return res.status(400).json({
      message: "Token can not be empty."
    });
  }
  if (!req.body._id) {
    return res.status(400).json({
      message: "_id can not be empty."
    });
  }

  let token, userId;
  if ( jwt.verify(req.body.token) ) {
    // decode jwt, then decrypt user ID
    token = jwt.decode(req.body.token);
    userId = crypto.decrypt(token.payload.userId);
    if (userId.length == 26) {
      userId = userId.substr(1, userId.length - 2);
    }
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  // find routine by id and replace empty variables
  Routine.findById(req.body._id)
    .then(routine => {
      if (!routine) {
        return res.status(404).json({
          message: "Routine not found with id " + req.body._id
        });
      }
      if (!req.body.routineName) {
        req.body.routineName = routine.routineName;
      }
      if (!req.body.pomTimer) {
        req.body.pomTimer = routine.pomTimer;
      }
      if (!req.body.breakTimer) {
        req.body.breakTimer = routine.breakTimer;
      }
      if (!req.body.pomCount) {
        req.body.pomCount = routine.pomCount;
      }
      if (!req.body.breakCount) {
        req.body.breakCount = routine.breakCount;
      }
      if (!req.body.largeBreakCount) {
        req.body.largeBreakCount = routine.largeBreakCount;
      }
      if (req.body.goalHit === undefined) {
        req.body.goalHit = routine.goalHit;
      }

      // Find user by _id and update it
      Routine.findByIdAndUpdate(
        req.body._id,
        {
          routineName: req.body.routineName,
          pomTimer: req.body.pomTimer,
          breakTimer: req.body.breakTimer,
          pomCount: req.body.pomCount,
          breakCount: req.body.breakCount,
          largeBreakCount: req.body.largeBreakCount,
          goalHit: req.body.goalHit
        },
        { new: true }
      )
        .then(routine => {
          if (!routine) {
            return res.status(404).json({
              message: "Routine not found with id " + req.body._id
            });
          }

          // encrypt user ID before putting into payload
          let cipher = crypto.encrypt(userId);
          let payload = {
            userId: cipher,
          };
          let token = jwt.sign(payload);

          routine.userId = undefined;

          res.json({
            token: token,
            routine,
            message: "Routine " + routine.routineName + " successfully updated!"
          });
        })
        .catch(err => {
          if (err.kind === "ObjectId") {
            return res.status(404).json({
              message: "Routine not found with id " + req.body._id
            });
          }
          return res.status(500).json({
            message: "Error updating routine with id " + req.body._id
          });
        });
    })
    .catch(err => {
      if (err.kind === "ObjectId") {
        return res.status(404).json({
          message: "Routine not found with id " + req.body._id
        });
      }
      return res.status(500).json({
        message: "Error updating routine with id " + req.body._id
      });
    });
}; // end edit

// Delete a routine
// JSON inputs required: token and _id
// outputs JSON: token, routineName, and message
exports.delete = (req, res) => {
  // Check required fields
  if (!req.body.token) {
    return res.status(400).json({
      message: "Token can not be empty."
    });
  }
  if (!req.body._id) {
    return res.status(400).json({
      message: "_id can not be empty."
    });
  }

  let token, userId;
  if ( jwt.verify(req.body.token) ) {
    // decode jwt, then decrypt user ID
    token = jwt.decode(req.body.token);
    userId = crypto.decrypt(token.payload.userId);
    if (userId.length == 26) {
      userId = userId.substr(1, userId.length - 2);
    }
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  Routine.findByIdAndDelete(req.body._id)
    .then(routine => {
      if (!routine) {
        return res.status(404).json({
          message: "Routine ID incorrect or does not exist."
        });
      }

      // encrypt user ID before putting into payload
      let cipher = crypto.encrypt(userId);
      let payload = {
        userId: cipher,
      };
      let token = jwt.sign(payload);

      res.json({
        token: token,
        routineName: routine.routineName,
        message: "Routine " + routine.routineName + " deleted successfully!"
      });
    })
    .catch(err => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).json({
          message: "Routine " + req.body.routineName + " not found."
        });
      }
      return res.status(500).json({
        message: "Could not find routine " + req.body.routineName + "."
      });
    });
}; // end delete

// Delete all routines for a specific user
// JSON inputs required: token
// outputs JSON: deletedCount and message
exports.deleteAll = (req, res) => {
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
    if (userId.length == 26) {
      userId = userId.substr(1, userId.length - 2);
    }
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  Routine.deleteMany({ userId: userId })
    .then(routine => {
      if (!routine) {
        return res.status(404).json({
          message: "Routine ID incorrect or does not exist."
        });
      }

      res.json({
        deletedCount: routine.deletedCount,
        message: "All routines deleted successfully!"
      });
    })
    .catch(err => {
      if (err.kind === "ObjectId" || err.name === "NotFound") {
        return res.status(404).json({
          message: "Routines not found."
        });
      }
      return res.status(500).json({
        message: "Could not find routines."
      });
    });
}; // end deleteAll

// Retrieve and return all routines from the database
// JSON inputs required: token from admin account
// outputs JSON: routines array with all fields
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
    if (userId.length == 26) {
      userId = userId.substr(1, userId.length - 2);
    }
  }
  else {
    return res.status(401).json({
      message: "Token could not be verified."
    });
  }

  User.findOne({ _id: userId, admin: true })
    .then(user => {
      if (!user) {
        return res.status(404).json({
          message: "User does not exist or does not have admin access."
        });
      }

      Routine.find()
        .then(routines => {
          if (!routines[0]) {
            return res.status(404).json({
              message: "No routines exist in the database."
            });
          }
          res.json({ routines });
        })
        .catch(err => {
          res.status(500).json({
            message: err.message || "Some error occurred while retrieving routines."
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
        message: err.message || "Some error occurred while retrieving Users."
      });
    });
}; // end getAll
