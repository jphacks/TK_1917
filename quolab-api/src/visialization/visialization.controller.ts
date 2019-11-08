import { Controller, Get, Request, UseGuards } from "@nestjs/common";
import { VisializationService } from "./visialization.service";
import { User } from "src/types/entities/user.interface";
import { AuthGuard } from "@nestjs/passport";
import { LabService } from "../lab/lab.service";
import { RoomService } from "../room/room.service";
import { UserService } from "../user/user.service";
import { addHours } from "date-fns";

@Controller("visialization")
export class VisializationController {
  constructor(
    private readonly userService: UserService,
    private readonly visializationService: VisializationService,
    private readonly labService: LabService,
    private readonly roomService: RoomService,
  ) {}

  @UseGuards(AuthGuard("jwt"))
  @Get("browsing")
  async browsing(@Request() res: any) {
    const user: User = res.user;
    return this.visializationService.getVisiBrowsingData(user.id);
  }
  j;
  @UseGuards(AuthGuard("jwt"))
  @Get("key")
  async key(@Request() res: any) {
    const user: User = res.user;
    return this.visializationService.getVisiKeyData(user.id);
  }

  @UseGuards(AuthGuard("jwt"))
  @Get("software")
  async software(@Request() res: any) {
    const user: User = res.user;
    return this.visializationService.getVisiUseSoftwareData(user.id);
  }

  @UseGuards(AuthGuard("jwt"))
  @Get("envdata")
  async envdata(@Request() res: any) {
    const user = await this.userService.findOne(res.user.email);
    const room = await this.roomService.findByLabId(user.labId);
    const sensors: {
      sensorName: string;
      data: any;
      createdAt: Date;
    }[] = (await this.visializationService.getVisiEnvData(
      room[0].monipiId,
    )).map((s: any) => ({
      sensorName: s.sensorName,
      data: s.data,
      createdAt: addHours(s.createdAt, 9),
    }));
    const names: string[] = this.unique(sensors.map(s => s.sensorName));
    return names.map(name => sensors.filter(s => s.sensorName === name));
  }

  private unique(l) {
    return l.filter((x, i, self) => self.indexOf(x) === i);
  }
}
