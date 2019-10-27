import * as mongoose from "mongoose";

export const MonipiSchema = new mongoose.Schema({
  monipiCode: String,
  labId: String,
  createdAt: { type: Date, default: Date.now },
});
