import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { MonipiDto } from "../../types/dto/monipi.dto";
import { Monipi } from "../../types/entities/monipi.interface";
import { Lab } from "../../types/entities/lab.interface";

@Injectable()
export class CreateMonipiService {
  constructor(
    @InjectModel("monipi") private readonly monipiModel: Model<Monipi>,
  ) {}

  async registerMonipi(monipiDto: Partial<MonipiDto>, lab: Lab) {
    const monipiCode = Math.random()
      .toString(32)
      .substring(2);
    monipiDto.monipiCode = monipiCode;
    monipiDto.labId = lab._id;
    const createdMonipi = new this.monipiModel(monipiDto);
    return createdMonipi.save();
  }
}
