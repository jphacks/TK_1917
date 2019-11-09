import { Test, TestingModule } from "@nestjs/testing";
import { WeeklyReportController } from "./weekly-report.controller";

describe("WeeklyReport Controller", () => {
  let controller: WeeklyReportController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [WeeklyReportController],
    }).compile();

    controller = module.get<WeeklyReportController>(WeeklyReportController);
  });

  it("should be defined", () => {
    expect(controller).toBeDefined();
  });
});
