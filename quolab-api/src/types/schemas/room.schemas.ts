import * as mongoose from "mongoose";

export const RoomSchema = new mongoose.Schema({
  name: String,
  labId: String,
  monipiId: String,
  createdAt: { type: Date, default: Date.now },
});
