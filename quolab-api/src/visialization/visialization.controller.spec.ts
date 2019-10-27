import { Test, TestingModule } from "@nestjs/testing";
import { VisializationController } from "./visialization.controller";

describe("Visialization Controller", () => {
  let controller: VisializationController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [VisializationController],
    }).compile();

    controller = module.get<VisializationController>(VisializationController);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });
});
