import {
  Controller,
  Post,
  Body,
  Get,
  UseGuards,
  Request,
  HttpStatus,
  HttpException,
} from "@nestjs/common";
import { CreateMonipiService } from "./create-monipi/create-monipi.service";
import { MonipiDto } from "../types/dto/monipi.dto";
import { LabService } from "../lab/lab.service";
import { AuthGuard } from "@nestjs/passport";
import { MonipiService } from "./monipi.service";
import { UserService } from "../user/user.service";

@Controller("monipi")
export class MonipiController {
  constructor(
    private readonly createMonipiService: CreateMonipiService,
    private readonly labService: LabService,
    private readonly monipiService: MonipiService,
    private readonly userService: UserService,
  ) {}

  @Post()
  async registerMonipi(@Body() monipiDto: Partial<MonipiDto>) {
    const lab = await this.labService.findOneByLabCode(monipiDto.labCode);
    return this.createMonipiService.registerMonipi(monipiDto, lab);
  }

  @UseGuards(AuthGuard("jwt"))
  @Get()
  async getMonipis(@Request() res: any) {
    const user = await this.userService.findOne(res.user.email);
    if (!user.labId) {
      throw new HttpException(`please join is lab`, HttpStatus.BAD_REQUEST);
    }
    const monipis = await this.monipiService.findByLabId(user.labId);
    return monipis;
  }
}
