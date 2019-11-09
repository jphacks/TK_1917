import { Document } from "mongoose";

export interface UserActivityData extends Document {
  _id: string;
  userId: string;
  activityName: string;
  data: Record<string, any>;
  createdAt: Date;
  category: "survey" | "writing" | "implementation" | "break";
}
