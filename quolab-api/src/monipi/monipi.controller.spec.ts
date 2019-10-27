import { Test, TestingModule } from "@nestjs/testing";
import { MonipiController } from "./monipi.controller";

describe("Monipi Controller", () => {
  let controller: MonipiController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [MonipiController],
    }).compile();

    controller = module.get<MonipiController>(MonipiController);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });
});
