import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Lab } from "src/types/entities/lab.interface";

@Injectable()
export class LabService {
  constructor(@InjectModel("lab") private readonly labModel: Model<Lab>) {}

  async findOne(_id: string) {
    return this.labModel.findOne({ _id });
  }

  async findOneByLabCode(labCode: string) {
    return this.labModel.findOne({ labCode });
  }
}
