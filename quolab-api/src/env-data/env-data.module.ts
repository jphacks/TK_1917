import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";

import { EnvDataController } from "./env-data.controller";
import { PostDataService } from "./post-data/post-data.service";
import { EnvDataSchema } from "../types/schemas/env_data.schemas";
import { EnvDataService } from "./env-data.service";
import { SlackConfigModule } from "../slack-config/slack-config.module";

@Module({
  imports: [
    SlackConfigModule,
    MongooseModule.forFeature([
      {
        name: "env-data",
        schema: EnvDataSchema,
      },
    ]),
  ],
  controllers: [EnvDataController],
  providers: [PostDataService, EnvDataService],
  exports: [EnvDataService],
})
export class EnvDataModule {}
