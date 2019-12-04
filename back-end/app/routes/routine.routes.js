// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
module.exports = app => {
  const routines = require("../controllers/routine.controller.js");

  // Create a new routine
  app.post("/createRoutine", routines.create);

  // Get all the user's routines
  app.post("/userRoutines", routines.userRoutines);

  // Edit a routine
  app.put("/editRoutine", routines.edit);

  // Edit coffee nap
  app.put("/editNap", routines.editNap);

  // Delete a routine
  app.delete("/deleteRoutine", routines.delete);

  // Delete all routines for a specific user
  app.delete("/deleteAllUserRoutines", routines.deleteAll);

  // Retrieve all routines: ADMIN USE ONLY
  app.get("/getAllRoutines", routines.getAll);
};
