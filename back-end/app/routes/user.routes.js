// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
module.exports = app => {
  const users = require("../controllers/user.controller.js");

  // Register a new user
  app.post("/registerUser", users.register);

  // Login user
  app.post("/loginUser", users.login);

  // Edit user
  app.put("/editUser", users.edit);

  // Delete user account
  app.delete("/deleteUser", users.delete);

  // Retrieve all users: ADMIN USE ONLY
  app.get("/getAllUsers", users.getAll);
};
