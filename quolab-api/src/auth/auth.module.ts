// auth module
import { UserModule } from "../user/user.module";
import { Module } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { PassportModule } from "@nestjs/passport";
import { LocalStrategy } from "./local.strategy";
import { JwtModule } from "@nestjs/jwt";
import { JwtStrategy } from "./jwt.strategy";
import { ConfigModule } from "../config/config.module";
import { ConfigService } from "../config/config.service";

function JwtRegister() {
  const config = new ConfigService();

  return JwtModule.register({
    secret: config.get("SECRET_KEY"),
    signOptions: { expiresIn: "7d" },
  });
}

@Module({
  imports: [
    ConfigModule,
    UserModule,
    JwtRegister(),
    PassportModule.register({ defaultStrategy: "jwt" }),
  ],
  providers: [AuthService, LocalStrategy, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
