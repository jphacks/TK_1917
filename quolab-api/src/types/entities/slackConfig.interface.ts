import { Document } from "mongoose";

export interface SlackConfig extends Document {
  _id: string;
  labId: string;
  url: string;
  channel: string;
  createdAt: Date;
}
