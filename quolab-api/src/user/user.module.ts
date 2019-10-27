import { Module } from "@nestjs/common";
import { UserService } from "./user.service";
import { MongooseModule } from "@nestjs/mongoose";
import { UserSchema } from "../types/schemas/user.schema";

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: "user",
        schema: UserSchema,
      },
    ]),
  ],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
