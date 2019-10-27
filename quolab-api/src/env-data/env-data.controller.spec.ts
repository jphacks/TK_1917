import { Test, TestingModule } from "@nestjs/testing";
import { EnvDataController } from "./env-data.controller";

describe("EnvData Controller", () => {
  let controller: EnvDataController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [EnvDataController],
    }).compile();

    controller = module.get<EnvDataController>(EnvDataController);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });
});
