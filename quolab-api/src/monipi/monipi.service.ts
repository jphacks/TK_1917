import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Monipi } from "../types/entities/monipi.interface";

@Injectable()
export class MonipiService {
  constructor(
    @InjectModel("monipi") private readonly monipiModel: Model<Monipi>,
  ) {}

  async findByLabId(labId: string) {
    return this.monipiModel.find({ labId });
  }
}
