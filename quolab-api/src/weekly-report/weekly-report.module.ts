import { Module } from "@nestjs/common";
import { UserModule } from "../user/user.module";
import { UserActivityModule } from "../user-activity/user-activity.module";
import { WeeklyReportService } from "./weekly-report.service";
import { EnvDataModule } from "../env-data/env-data.module";
import { LabModule } from "../lab/lab.module";
import { MonipiModule } from "../monipi/monipi.module";
import { WeeklyReportController } from "./weekly-report.controller";

@Module({
  imports: [
    UserModule,
    UserActivityModule,
    EnvDataModule,
    LabModule,
    MonipiModule,
  ],
  controllers: [WeeklyReportController],
  providers: [WeeklyReportService],
})
export class WeeklyReportModule {}
