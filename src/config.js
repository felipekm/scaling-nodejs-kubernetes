export const config = {
  DB_HOST: process.env.DB_HOST || "localhost",
  DB_USER: process.env.DB_USER || "postgres",
  DB_PASS: process.env.DB_PASS || "password",
  DB_NAME: process.env.DB_NAME || "node_scaling",
  DB_PORT: process.env.DB_PORT || 5432,
  REDIS_HOST: process.env.REDIS_HOST || "localhost",
  REDIS_PORT: process.env.REDIS_PORT || 6379,
};
