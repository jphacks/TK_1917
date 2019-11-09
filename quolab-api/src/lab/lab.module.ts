import { Module } from "@nestjs/common";
import { LabController } from "./lab.controller";
import { CreateLabService } from "./create-lab/create-lab.service";
import { MongooseModule } from "@nestjs/mongoose";
import { PlaygroundSchema } from "../types/schemas/playground.schemas";
import { LabSchema } from "../types/schemas/lab.schemas";
import { UserModule } from "../user/user.module";
import { LabService } from "./lab.service";
import { GetLabMembersService } from "./get-lab-members/get-lab-members.service";
import { UserActivitySchema } from "../types/schemas/userActibity.schemas";

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
      {
        name: "user-activity",
        schema: UserActivitySchema,
      },
    ]),
  ],
  controllers: [LabController],
  providers: [CreateLabService, LabService, GetLabMembersService],
  exports: [LabService],
})
export class LabModule {}
