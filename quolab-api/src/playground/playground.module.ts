import { Module } from "@nestjs/common";
import { PlaygroundService } from "./playground.service";
import { MongooseModule } from "@nestjs/mongoose";
import { PlaygroundSchema } from "../types/schemas/playground.schemas";
import { PlaygroundController } from "./playground.controller";

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: "playground",
        schema: PlaygroundSchema,
      },
    ]),
  ],
  controllers: [PlaygroundController],
  providers: [PlaygroundService],
})
export class PlaygroundModule {}
