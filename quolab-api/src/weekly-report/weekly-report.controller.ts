import { Controller, Get, UseGuards, Request, Param } from "@nestjs/common";
import { UserService } from "../user/user.service";
import { AuthGuard } from "@nestjs/passport";
import { RequestWithUser } from "../types/";
import { WeeklyReportService } from "./weekly-report.service";
import { UserActivityService } from "../user-activity/user-activity.service";

@UseGuards(AuthGuard("jwt"))
@Controller("weekly-report")
export class WeeklyReportController {
  constructor(
    private readonly userService: UserService,
    private readonly userActivityService: UserActivityService,
    private readonly weeklyReportService: WeeklyReportService,
  ) {}

  @Get()
  async index(@Request() req: RequestWithUser) {
    const user = await this.userService.findOne(req.user.email);
    return this.userActivityService.fetchWeeklyCategories(user._id.toString());
  }

  @Get("/:category")
  async categoryDetail(
    @Request() req: RequestWithUser,
    @Param("category") category: string,
  ) {
    const user = await this.userService.findOne(req.user.email);
    return this.userActivityService.detailCategory(
      user._id.toString(),
      category,
    );
  }
}
