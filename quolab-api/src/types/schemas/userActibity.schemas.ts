import { Schema } from "mongoose";

export const UserActivitySchema = new Schema({
  userId: String,
  activityName: String,
  data: Object,
  createdAt: { type: Date, default: Date.now },
  category: String,
});
