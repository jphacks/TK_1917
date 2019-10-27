import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";

import { UserActivityData } from "../../types/entities/userActivityData.interface";
import { UserActivityDataDto } from "../../types/dto/userActivityData.dto";
import { User } from "../../types/entities/user.interface";

@Injectable()
export class PostUserActivityDataService {
  constructor(
    @InjectModel("user-activity")
    private readonly userActivityDataModel: Model<UserActivityData>,
  ) {}

  async postUserActivityData(
    userActivityData: Partial<UserActivityDataDto>,
    user: User,
  ) {
    userActivityData.userId = user.id;
    const createdUserActivityData = new this.userActivityDataModel(
      userActivityData,
    );
    return await createdUserActivityData.save();
  }
}
