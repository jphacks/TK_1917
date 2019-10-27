import { Test, TestingModule } from "@nestjs/testing";
import { CreateMonipiService } from "./create-monipi.service";

describe("CreateMonipiService", () => {
  let service: CreateMonipiService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CreateMonipiService],
    }).compile();

    service = module.get<CreateMonipiService>(CreateMonipiService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
