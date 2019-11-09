import { Module, Global, DynamicModule } from "@nestjs/common";
import { ConfigModule } from "../config/config.module";
import { ConfigService } from "../config/config.service";
import { MongooseModule } from "@nestjs/mongoose";

function DatabaseMongooseModule(): DynamicModule {
  const config = new ConfigService();
  return MongooseModule.forRoot(config.get("MONGODB_URI"), {
    useUnifiedTopology: true,
    useNewUrlParser: true,
  });
}

@Global()
@Module({
  imports: [ConfigModule, DatabaseMongooseModule()],
})
export class DatabaseModule {}
