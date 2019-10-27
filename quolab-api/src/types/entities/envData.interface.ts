import { Document } from "mongoose";

export interface EnvData extends Document {
  _id: string;
  monipiId: string;
  sensorName: string;
  data: Record<string, any>;
}
