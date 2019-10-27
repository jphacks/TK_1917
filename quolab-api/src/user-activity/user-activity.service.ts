import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { UserActivityData } from "src/types/entities/userActivityData.interface";
import { subHours } from "date-fns";

@Injectable()
export class UserActivityService {
  constructor(
    @InjectModel("user-activity")
    private readonly userActivityModel: Model<UserActivityData>,
  ) {}

  async fetchBrowsingData(
    userId: string,
    startTime = subHours(new Date(), 6),
    endTime = new Date(),
  ) {
    return this.userActivityModel.aggregate([
      {
        $match: {
          activityName: "browsing",
          "data.url": { $ne: undefined },
          userId: userId,
          createdAt: {
            $gte: startTime,
            $lt: endTime,
          },
        },
      },
    ]);
  }

  async fetchNappData(
    userId: string,
    startTime = subHours(new Date(), 6),
    endTime = new Date(),
  ) {
    return this.userActivityModel.aggregate([
      {
        $match: {
          activityName: "KeyCountAndAppName",
          userId: userId,
          createdAt: {
            $gte: startTime,
            $lt: endTime,
          },
        },
      },
    ]);
  }
}
