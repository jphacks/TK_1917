import { Module, MiddlewareConsumer } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { PlaygroundModule } from "./playground/playground.module";
import { LabModule } from "./lab/lab.module";
import { UserModule } from "./user/user.module";
import { AuthModule } from "./auth/auth.module";
import { RoomModule } from "./room/room.module";
import { EnvDataModule } from "./env-data/env-data.module";
import { LoggerMiddleware } from "./middleware/logger.middleware";
import { UserActivityModule } from "./user-activity/user-activity.module";
import { MonipiModule } from "./monipi/monipi.module";
import { VisializationModule } from "./visialization/visialization.module";
import { SlackConfigModule } from "./slack-config/slack-config.module";
import { ConfigModule } from "./config/config.module";
import { DatabaseModule } from "./database/database.module";
import { WeeklyReportModule } from "./weekly-report/weekly-report.module";

@Module({
  imports: [
    ConfigModule,
    DatabaseModule,
    PlaygroundModule,
    LabModule,
    UserModule,
    AuthModule,
    RoomModule,
    EnvDataModule,
    UserActivityModule,
    MonipiModule,
    VisializationModule,
    SlackConfigModule,
    WeeklyReportModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggerMiddleware).forRoutes("/*");
  }
}
