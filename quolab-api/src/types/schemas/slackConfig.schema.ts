import * as mongoose from "mongoose";

export const SlackConfigSchema = new mongoose.Schema({
  labId: String,
  url: String,
  channel: String,
  createdAt: { type: Date, default: Date.now },
});
