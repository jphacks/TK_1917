import { Test, TestingModule } from "@nestjs/testing";
import { LabController } from "./lab.controller";

describe("Lab Controller", () => {
  let controller: LabController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [LabController],
    }).compile();

    controller = module.get<LabController>(LabController);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });
});
