import { Test, TestingModule } from "@nestjs/testing";
import { WeeklyReportService } from "./weekly-report.service";

describe("WeeklyReportService", () => {
  let service: WeeklyReportService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [WeeklyReportService],
    }).compile();

    service = module.get<WeeklyReportService>(WeeklyReportService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });
});
