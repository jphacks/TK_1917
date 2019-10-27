import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  UseGuards,
  Request,
  HttpStatus,
  HttpException,
} from "@nestjs/common";
import { CreateRoomService } from "./create-room/create-room.service";
import { UserService } from "../user/user.service";
import { RoomDto } from "../types/dto/room.dto";
import { AuthGuard } from "@nestjs/passport";
import { RoomService } from "./room.service";

@Controller("room")
export class RoomController {
  constructor(
    private readonly createRoomService: CreateRoomService,
    private readonly userService: UserService,
    private readonly roomService: RoomService,
  ) {}

  @UseGuards(AuthGuard("jwt"))
  @Post()
  async createRoom(@Request() res: any, @Body() roomDto: Partial<RoomDto>) {
    const user = await this.userService.findOne(res.user.email);
    if (!user.labId) {
      throw new HttpException(`please join is lab`, HttpStatus.BAD_REQUEST);
    }
    return this.createRoomService.createRoom(roomDto, user);
  }

  @UseGuards(AuthGuard("jwt"))
  @Get()
  async getLabRoom(@Request() res: any) {
    const user = await this.userService.findOne(res.user.email);
    if (!user.labId) {
      throw new HttpException(`please join is lab`, HttpStatus.BAD_REQUEST);
    }

    return this.roomService.findByLabId(user.labId);
  }

  @UseGuards(AuthGuard("jwt"))
  @Put()
  async updateRoomMonipi(@Body() roomDto: Partial<RoomDto>) {
    const roomData = await this.roomService.findByRoomId(roomDto._id);
    if (!roomData) {
      throw new HttpException(`not exist`, HttpStatus.BAD_REQUEST);
    }
    return this.roomService.updateRoomMonipi(roomData, roomDto.monipiId);
  }
}
