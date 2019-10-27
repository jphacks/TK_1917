import * as mongoose from "mongoose";

export const EnvDataSchema = new mongoose.Schema({
  monipiId: String,
  sensorName: String,
  data: Object,
  createdAt: { type: Date, default: Date.now },
});
