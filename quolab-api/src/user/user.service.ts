import { Injectable } from "@nestjs/common";
import { Model } from "mongoose";
import { User } from "../types/entities/user.interface";
import { UserDto } from "../types/dto/user.dto";
import { hashSync } from "bcrypt";
import { InjectModel } from "@nestjs/mongoose";

@Injectable()
export class UserService {
  constructor(@InjectModel("user") private readonly userModel: Model<User>) {}

  async isExist(email: string) {
    return this.userModel.exists({ email });
  }

  async findOne(email: string) {
    return this.userModel.findOne({ email });
  }

  async create(createUserDto: Partial<UserDto>) {
    const user = new this.userModel({
      ...createUserDto,
      password: hashSync(createUserDto.password, 15),
    });
    return user.save();
  }

  async joinLab(email: string, labId: string) {
    const user = await this.findOne(email);
    user.labId = labId;
    user.save();
    return user;
  }
  async leaveLab(email: string) {
    const user = await this.findOne(email);
    user.labId = null;
    await user.save();
    return user;
  }
}
