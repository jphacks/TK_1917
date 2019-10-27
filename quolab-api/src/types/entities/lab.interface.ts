import { Document } from "mongoose";

export interface Lab extends Document {
  _id: string;
  name: string;
  labCode: string;
  createdAt: Date;
}
