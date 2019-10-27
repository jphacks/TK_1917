import { Test, TestingModule } from "@nestjs/testing";
import { PostUserActivityDataService } from "./post-user-activity-data.service";

describe("PostUserActivityDataService", () => {
  let service: PostUserActivityDataService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PostUserActivityDataService],
    }).compile();

    service = module.get<PostUserActivityDataService>(
      PostUserActivityDataService,
    );
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
