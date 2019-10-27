import { Injectable } from "@nestjs/common";
import { Model } from "mongoose";
import { InjectModel } from "@nestjs/mongoose";

import { Room } from "../../types/entities/room.interface";
import { RoomDto } from "../../types/dto/room.dto";
import { User } from "../../types/entities/user.interface";
@Injectable()
export class CreateRoomService {
  constructor(@InjectModel("room") private readonly roomModel: Model<Room>) {}

  createRoom(roomDto: Partial<RoomDto>, user: User) {
    roomDto.labId = user.labId;
    const createdRoom = new this.roomModel(roomDto);
    return createdRoom.save();
  }
}
