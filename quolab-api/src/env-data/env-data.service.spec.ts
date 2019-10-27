import { Test, TestingModule } from "@nestjs/testing";
import { EnvDataService } from "./env-data.service";

describe("EnvDataService", () => {
  let service: EnvDataService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [EnvDataService],
    }).compile();

    service = module.get<EnvDataService>(EnvDataService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
