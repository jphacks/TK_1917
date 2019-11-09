import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { MonipiController } from "./monipi.controller";
import { CreateMonipiService } from "./create-monipi/create-monipi.service";
import { MonipiService } from "./monipi.service";

import { MonipiSchema } from "../types/schemas/monipi.schemas";
import { LabModule } from "../lab/lab.module";
import { UserModule } from "../user/user.module";

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: "monipi",
        schema: MonipiSchema,
      },
    ]),
    LabModule,
    UserModule,
  ],
  controllers: [MonipiController],
  providers: [CreateMonipiService, MonipiService],
  exports: [MonipiService],
})
export class MonipiModule {}
