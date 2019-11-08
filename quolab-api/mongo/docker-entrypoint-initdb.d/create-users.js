const users = [
  {
    user: "root",
    pwd: "password",
    roles: [
      {
        role: "userAdminAnyDatabase",
        db: "admin",
      },
    ],
  },
];

for (let i = 0, length = users.length; i < length; ++i) {
  db.getSiblingDB("admin").createUser(users[i]);
}
