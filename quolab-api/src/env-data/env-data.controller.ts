import { Controller, Post, Body } from "@nestjs/common";
import { PostDataService } from "./post-data/post-data.service";
import { EnvDataDto } from "../types/dto/envData.dto";

@Controller("env-data")
export class EnvDataController {
  constructor(private readonly postDataService: PostDataService) {}

  @Post()
  postData(@Body() envDataDto: Partial<EnvDataDto>) {
    return this.postDataService.postData(envDataDto);
  }
}
