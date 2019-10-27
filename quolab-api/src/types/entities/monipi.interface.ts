import { Document } from "mongoose";

export interface Monipi extends Document {
  _id: string;
  monipiCode: string;
  labId: string;
  createdAt: Date;
}
