import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { UserActivityController } from "./user-activity.controller";
import { PostUserActivityDataService } from "./post-user-activity-data/post-user-activity-data.service";
import { UserActivitySchema } from "../types/schemas/userActibity.schemas";
import { UserActivityService } from "./user-activity.service";

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: "user-activity",
        schema: UserActivitySchema,
      },
    ]),
  ],
  controllers: [UserActivityController],
  providers: [PostUserActivityDataService, UserActivityService],
  exports: [UserActivityService],
})
export class UserActivityModule {}
