import {
  Controller,
  UseGuards,
  Request,
  Post,
  Body,
  Get,
} from "@nestjs/common";
import { SlackConfigService } from "./slack-config.service";
import { AuthGuard } from "@nestjs/passport";
import { SlackConfigDto } from "../types/dto/slackConfig.dto";
import { UserService } from "../user/user.service";

@Controller("slack-config")
export class SlackConfigController {
  constructor(
    private readonly slackConfigService: SlackConfigService,
    private readonly userService: UserService,
  ) {}

  @UseGuards(AuthGuard("jwt"))
  @Post()
  async registerSlackConfig(
    @Body() slackConfigDto: Partial<SlackConfigDto>,
    @Request() req: any,
  ) {
    const user = await this.userService.findOne(req.user.email);

    return await this.slackConfigService.update(slackConfigDto, user.labId);
  }

  @Get()
  async getUrls() {
    return await this.slackConfigService.get();
  }
}
