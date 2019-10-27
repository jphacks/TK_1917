import { Module } from "@nestjs/common";
import { VisializationService } from "./visialization.service";
import { UserModule } from "../user/user.module";
import { UserActivityModule } from "../user-activity/user-activity.module";
import { VisializationController } from "./visialization.controller";
import { EnvDataModule } from "../env-data/env-data.module";
import { LabModule } from "../lab/lab.module";
import { RoomModule } from "../room/room.module";

@Module({
  imports: [
    UserModule,
    UserActivityModule,
    EnvDataModule,
    LabModule,
    RoomModule,
  ],
  controllers: [VisializationController],
  providers: [VisializationService],
})
export class VisializationModule {}
