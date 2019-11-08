import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Request,
  HttpException,
  HttpStatus,
  Put,
} from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";

import { AppService } from "./app.service";
import { UserService } from "./user/user.service";
import { AuthService } from "./auth/auth.service";

import { UserDto } from "./types/dto/user.dto";

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly userService: UserService,
    private readonly authService: AuthService,
  ) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Post("signup")
  async signin(@Body() createUserDto: Partial<UserDto>) {
    if (await this.userService.isExist(createUserDto.email)) {
      throw new HttpException(
        `${createUserDto.email} is aleady exist`,
        HttpStatus.CONFLICT,
      );
    }
    const user = await this.userService.create(createUserDto);
    return this.authService.login(user);
  }

  @UseGuards(AuthGuard("local"))
  @Post("signin")
  async login(@Body() userDto: UserDto) {
    const user = await this.userService.findOne(userDto.email);
    return this.authService.login(user);
  }

  @UseGuards(AuthGuard("jwt"))
  @Get("me")
  async getProfile(@Request() req: any) {
    const user = await this.userService.findOne(req.user.email);

    return user;
  }

  @UseGuards(AuthGuard("jwt"))
  @Put("me")
  async updateProfile(@Body() userDto: Partial<UserDto>, @Request() req: any) {
    return await this.userService.updateUser(req.user.id, userDto);
  }
}
