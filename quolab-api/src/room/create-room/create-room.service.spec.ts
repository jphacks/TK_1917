import { Test, TestingModule } from "@nestjs/testing";
import { CreateRoomService } from "./create-room.service";

describe("CreateRoomService", () => {
  let service: CreateRoomService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CreateRoomService],
    }).compile();

    service = module.get<CreateRoomService>(CreateRoomService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
