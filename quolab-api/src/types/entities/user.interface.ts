import { Document } from "mongoose";

export interface User extends Document {
  _id: string;
  email: string;
  password: string;
  labId: string;
  name: string;
  createdAt: Date;
}
