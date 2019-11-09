export class UserDto {
  readonly _id: string;
  readonly email: string;
  readonly password: string;
  labId: string;
  name: string;

  readonly createdAt?: Date;
}
