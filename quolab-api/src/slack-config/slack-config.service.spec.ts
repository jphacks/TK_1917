import { Test, TestingModule } from "@nestjs/testing";
import { SlackConfigService } from "./slack-config.service";

describe("SlackConfigService", () => {
  let service: SlackConfigService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [SlackConfigService],
    }).compile();

    service = module.get<SlackConfigService>(SlackConfigService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
