import { Request } from "@nestjs/common";

export interface User {
  id: string;
  email: string;
}

export interface RequestWithUser extends Request {
  user: User;
}
