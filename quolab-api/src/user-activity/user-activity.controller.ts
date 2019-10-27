import { Controller, Body, Post, UseGuards, Request } from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";

import { PostUserActivityDataService } from "./post-user-activity-data/post-user-activity-data.service";
import { UserActivityDataDto } from "../types/dto/userActivityData.dto";
import { User } from "../types/entities/user.interface";

@Controller("user-activity")
export class UserActivityController {
  constructor(
    private readonly postUserActivityDataService: PostUserActivityDataService,
  ) {}

  @UseGuards(AuthGuard("jwt"))
  @Post()
  postUserActivityData(
    @Request() res: any,
    @Body() userActivityDataDto: Partial<UserActivityDataDto>,
  ) {
    const user: User = res.user;
    return this.postUserActivityDataService.postUserActivityData(
      userActivityDataDto,
      user,
    );
  }
}
