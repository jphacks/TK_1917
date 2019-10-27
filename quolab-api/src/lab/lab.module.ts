import { Module } from "@nestjs/common";
import { LabController } from "./lab.controller";
import { CreateLabService } from "./create-lab/create-lab.service";
import { MongooseModule } from "@nestjs/mongoose";
import { PlaygroundSchema } from "../types/schemas/playground.schemas";
import { LabSchema } from "../types/schemas/lab.schemas";
import { UserModule } from "../user/user.module";
import { LabService } from "./lab.service";

@Module({
  imports: [
    UserModule,
    MongooseModule.forFeature([
      {
        name: "lab",
        schema: LabSchema,
      },
      {
        name: "playground",
        schema: PlaygroundSchema,
      },
    ]),
  ],
  controllers: [LabController],
  providers: [CreateLabService, LabService],
  exports: [LabService],
})
export class LabModule {}
