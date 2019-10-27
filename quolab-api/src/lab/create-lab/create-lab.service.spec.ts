import { Test, TestingModule } from "@nestjs/testing";
import { CreateLabService } from "./create-lab.service";

describe("CreateLabService", () => {
  let service: CreateLabService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CreateLabService],
    }).compile();

    service = module.get<CreateLabService>(CreateLabService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
