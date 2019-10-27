import { Test, TestingModule } from "@nestjs/testing";
import { VisializationService } from "./visialization.service";

describe("VisializationService", () => {
  let service: VisializationService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [VisializationService],
    }).compile();

    service = module.get<VisializationService>(VisializationService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
