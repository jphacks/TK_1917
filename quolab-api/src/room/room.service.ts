import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model } from "mongoose";
import { Room } from "../types/entities/room.interface";

@Injectable()
export class RoomService {
  constructor(@InjectModel("room") private readonly roomModel: Model<Room>) {}

  async findByLabId(labId: string) {
    return this.roomModel.find({ labId });
  }

  async findByRoomId(roomId: string) {
    return this.roomModel.findById(roomId);
  }

  async updateRoomMonipi(roomData: Room, monipiId: string) {
    roomData.monipiId = monipiId;
    const updatedRoom = await roomData.save();
    return updatedRoom;
  }
}
