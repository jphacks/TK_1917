import { Schema } from "mongoose";

export const UserSchema = new Schema({
  email: String,
  password: String,
  labId: String,
  createdAt: { type: Date, default: Date.now },
  activity: String,
  name: String,
});
