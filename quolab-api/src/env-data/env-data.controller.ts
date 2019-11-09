import {
  Controller,
  Post,
  Body,
  HttpException,
  HttpStatus,
} from "@nestjs/common";
import axios from "axios";
import { PostDataService } from "./post-data/post-data.service";
import { EnvDataDto } from "../types/dto/envData.dto";
import { SlackConfigService } from "../slack-config/slack-config.service";

export class RequestParam {
  labId: string;
  message: string;
}

@Controller("env-data")
export class EnvDataController {
  constructor(
    private readonly postDataService: PostDataService,
    private readonly slackConfigService: SlackConfigService,
  ) {}

  @Post()
  postData(@Body() envDataDto: Partial<EnvDataDto>) {
    return this.postDataService.postData(envDataDto);
  }

  @Post("alert")
  async alert(@Body() data: RequestParam) {
    const slackConf = await this.slackConfigService.findOneByLabId(data.labId);
    if (!!slackConf || !!slackConf.url) {
      throw new HttpException(
        `your lab config is not good`,
        HttpStatus.BAD_REQUEST,
      );
    }
    axios.post(slackConf.url, {
      text: data.message,
      channel: slackConf.channel,
    });
  }
}
