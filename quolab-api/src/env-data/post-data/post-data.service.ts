import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { EnvDataDto } from "../../types/dto/envData.dto";
import { EnvData } from "../../types/entities/envData.interface";

@Injectable()
export class PostDataService {
  constructor(
    @InjectModel("env-data") private readonly envDataModel: Model<EnvData>,
  ) {}

  async postData(envDataDto: Partial<EnvDataDto>) {
    const postedData = new this.envDataModel(envDataDto);
    return await postedData.save();
  }
}
