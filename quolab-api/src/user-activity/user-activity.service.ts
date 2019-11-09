import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { UserActivityData } from "../types/entities/userActivityData.interface";
import { subHours, startOfWeek } from "date-fns";
export interface Category {
  survey: number;
  writing: number;
  implementation: number;
  break: number;
}

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
  ): Promise<UserActivityData[]> {
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
  ): Promise<UserActivityData[]> {
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

  async fetchWeeklyCategories(userId: string) {
    const startTime = startOfWeek(new Date());
    const endTime = new Date();

    const items: UserActivityData[] = await this.userActivityModel.aggregate([
      {
        $match: {
          userId: userId,
          category: { $ne: undefined },
          createdAt: {
            $gte: startTime,
            $lt: endTime,
          },
        },
      },
    ]);
    const categories = [
      "survey",
      "writing",
      "implementation",
      "break",
    ] as const;
    const categoryCount = categories.map(
      category => items.filter(item => item.category === category).length,
    );
    const total = categoryCount.reduce((a, b) => a + b);
    const data = categoryCount.map(c => (c * 100) / (total !== 0 ? total : 1));

    const chartData = { labels: categories, datasets: [{ data }] };
    const comments = {
      labels: categories,
      comments: [
        this.surveyComment(data[0]),
        this.writing(data[1]),
        this.implementation(data[2]),
        this.break(data[3]),
      ],
    };
    return { chartData, comments };
  }

  async detailCategory(userId: string, category: string) {
    const startTime = startOfWeek(new Date());
    const endTime = new Date();

    return this.userActivityModel.aggregate([
      {
        $match: {
          userId,
          category,
          createdAt: {
            $gte: startTime,
            $lt: endTime,
          },
        },
      },
    ]);
  }
  private surveyComment(score: number) {
    if (score > 70) {
      return "天才？";
    } else if (score > 50) {
      return "すご過ぎ";
    } else if (score > 30) {
      return "やるね";
    } else {
      return "今週は調べごと以外頑張れて偉い！";
    }
  }

  private writing(score: number) {
    if (score > 70) {
      return "天才？";
    } else if (score > 50) {
      return "すご過ぎ";
    } else if (score > 30) {
      return "やるね";
    } else {
      return "今週はかきごと以外頑張れて偉い！";
    }
  }

  private implementation(score: number) {
    if (score > 70) {
      return "天才？";
    } else if (score > 50) {
      return "すご過ぎ";
    } else if (score > 30) {
      return "やるね";
    } else {
      return "今週は実装以外頑張れて偉い！";
    }
  }

  private break(score: number) {
    if (score > 50) {
      return "たくさん休めて偉い！";
    } else {
      return "頑張ってて偉い！";
    }
  }
}
