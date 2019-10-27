import { Test, TestingModule } from "@nestjs/testing";
import { PostDataService } from "./post-data.service";

describe("PostDataService", () => {
  let service: PostDataService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PostDataService],
    }).compile();

    service = module.get<PostDataService>(PostDataService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
