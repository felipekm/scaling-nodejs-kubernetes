import pg from "pg";
import { config } from "./config.js";

const { Pool } = pg;

const pool = new Pool({
  max: 20,                       // Max connections in the pool
  port: config.DB_PORT,          // PostgreSQL port
  user: config.DB_USER,          // PostgreSQL user
  host: config.DB_HOST,          // PostgreSQL host
  database: config.DB_NAME,      // PostgreSQL database
  password: config.DB_PASS,      // PostgreSQL password
  idleTimeoutMillis: 30000,      // Close idle connections after 30s
  connectionTimeoutMillis: 2000, // Wait max 2s for a connection
});

export const connectDB = async () => {
  try {
    const client = await pool.connect();
    console.log("✅ Connected to PostgreSQL");
    client.release();
  } catch (err) {
    console.error("❌ PostgreSQL Connection Error:", err);
    process.exit(1);
  }
};

export default pool;
