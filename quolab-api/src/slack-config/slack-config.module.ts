import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { SlackConfigController } from "./slack-config.controller";
import { SlackConfigService } from "./slack-config.service";
import { SlackConfigSchema } from "../types/schemas/slackConfig.schema";
import { UserModule } from "../user/user.module";

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: "slack-config",
        schema: SlackConfigSchema,
      },
    ]),
    UserModule,
  ],
  controllers: [SlackConfigController],
  providers: [SlackConfigService],
  exports: [SlackConfigService],
})
export class SlackConfigModule {}
