import { Test, TestingModule } from "@nestjs/testing";
import { MonipiService } from "./monipi.service";

describe("MonipiService", () => {
  let service: MonipiService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MonipiService],
    }).compile();

    service = module.get<MonipiService>(MonipiService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
