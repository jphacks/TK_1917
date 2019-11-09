import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";

import { SlackConfig } from "../types/entities/slackConfig.interface";
import { SlackConfigDto } from "../types/dto/slackConfig.dto";

@Injectable()
export class SlackConfigService {
  constructor(
    @InjectModel("slack-config")
    private readonly slackConfigModel: Model<SlackConfig>,
  ) {}

  async findOneByLabId(id: string) {
    return this.slackConfigModel.findOne({ labId: id });
  }
  async update(slackConfigDto: Partial<SlackConfigDto>, labId: string) {
    const slackConfig = await this.findOneByLabId(labId);
    if (!slackConfig) {
      // register
      slackConfigDto.labId = labId;
      return await new this.slackConfigModel(slackConfigDto).save();
    }

    slackConfig.url = slackConfigDto.url;
    slackConfig.channel = slackConfigDto.channel;
    return await slackConfig.save();
  }

  async get() {
    const query = {
      $and: [
        { url: { $exists: true } }, //nameフィールドがn0bisuke以外
        { channel: { $exists: true } }, //nameフィールドがotukutun以外
      ],
    };
    return this.slackConfigModel.find(query, {}, {}, null);
  }
}
