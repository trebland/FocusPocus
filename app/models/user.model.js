// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
const mongoose = require("mongoose");
uniqueValidator = require('mongoose-unique-validator');

const UserSchema = mongoose.Schema(
  {
    username: {
      type: String,
      required: true,
      unique: true
    },
    email: {
      type: String,
      required: true,
      unique: true
    },
    fullName: String,
    password: {
      type: String,
      required: true
    },
    admin: Boolean
  },
  {
    timestamps: true
  }
);

UserSchema.plugin(uniqueValidator);
module.exports = mongoose.model("User", UserSchema);
