import { Document } from "mongoose";

export interface Room extends Document {
  _id: string;
  name: string;
  labId: string;
  createdAt: Date;
  monipiId: string;
}
