// written by: Phillip Tat from GROUP 21(Trevor Bland, Zach Arehart, Rob Lee, and Phillip Tat)
// date written: 11/23/19
// course: COP 4331(Rick Leinecker)
// purpose: Large Project: Focus Pocus(api)
const mongoose = require("mongoose");

const RoutineSchema = mongoose.Schema(
  {
    userId: {
      type: String,
      required: true
    },
    routineName: {
      type: String,
      required: true
    },
    coffeeNap: {
      type: Boolean,
      required: true
    },
    napTimer: Number,
    pomTimer: Number,
    breakTimer: Number,
    pomCount: Number,
    breakCount: Number,
    largeBreakCount: Number,
    goalHit: Boolean
  },
  {
    timestamps: true
  }
);

module.exports = mongoose.model("Routine", RoutineSchema);
