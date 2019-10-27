import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { LabDto } from "../../types/dto/Lab.dto";
import { Lab } from "../../types/entities/lab.interface";

import { Model } from "mongoose";

@Injectable()
export class CreateLabService {
  constructor(@InjectModel("lab") private readonly labModel: Model<Lab>) {}

  createLab(createLabRequestDto: Partial<LabDto>) {
    const labCode = Math.random()
      .toString(32)
      .substring(2);
    createLabRequestDto.labCode = labCode;
    const createdLab = new this.labModel(createLabRequestDto);
    return createdLab.save();
  }
}
