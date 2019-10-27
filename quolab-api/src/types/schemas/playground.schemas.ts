import * as mongoose from "mongoose";

export const PlaygroundSchema = new mongoose.Schema({
  name: String,
  createdAt: { type: Date, default: Date.now },
});
