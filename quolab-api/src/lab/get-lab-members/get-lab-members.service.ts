import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { startOfDay } from "date-fns";
import { Lab } from "../../types/entities/lab.interface";
import { UserService } from "../../user/user.service";
import { UserActivityData } from "../../types/entities/userActivityData.interface";

@Injectable()
export class GetLabMembersService {
  constructor(
    @InjectModel("lab") private readonly labModel: Model<Lab>,
    @InjectModel("user-activity")
    private readonly userActivityModel: Model<UserActivityData>,
    private readonly userService: UserService,
  ) {}

  async get(labId: string) {
    const users: Array<any> = await this.userService.getUsersByLabId(labId);
    const result = await Promise.all(
      users.map(user => {
        return this.userActivityModel.aggregate([
          {
            $match: {
              activityName: "KeyCountAndAppName",
              userId: user._id.toString(),
              createdAt: {
                $gte: startOfDay(new Date()),
              },
            },
          },
          {
            $sort: {
              createdAt: -1,
            },
          },
          {
            $limit: 1,
          },
        ]);
      }),
    );
    const userActivities = result
      .map(item => item[0])
      .filter(item => item != null);

    return users
      .map(user => {
        const activity = userActivities.find(item => item.userId == user._id);
        if (activity && activity.data) {
          user["activity"] = activity.data.appName
            ? activity.data.appName
            : "-";
          return user;
        } else {
          return user;
        }
      })
      .filter((user: any) => user.activity != null);
  }
}
