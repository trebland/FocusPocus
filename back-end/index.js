// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const path = require("path");
const config = require("config");
const fs = require("fs");
const app = express();
const db = config.get("remote");
const port = 3000;

// parse requests of content-type - application/json
app.use(bodyParser.json());

// Connecting to the database
mongoose.connect(db, {
  useNewUrlParser: true, useUnifiedTopology: true,
  useCreateIndex: true, useFindAndModify: false
})
.then(() => {
  console.log("Successfully connected to MongoDB");
})
.catch(err => {
  console.log(err);
  process.exit();
});

// define a simple route
app.get("/", (req, res) => {
  res.json({message: "Welcome to Focus Pocus."});
});

require("./app/routes/user.routes.js")(app);
require("./app/routes/routine.routes.js")(app);

// listen for requests
app.listen(port, () => {
  console.log("Server is listening on port %d", port);
});
