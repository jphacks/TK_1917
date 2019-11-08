import { Test, TestingModule } from "@nestjs/testing";
import { GetLabMembersService } from "./get-lab-members.service";

describe("GetLabMembersService", () => {
  let service: GetLabMembersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [GetLabMembersService],
    }).compile();

    service = module.get<GetLabMembersService>(GetLabMembersService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
