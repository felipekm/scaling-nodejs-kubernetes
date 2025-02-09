import Fastify from "fastify";
import pool from "./database.js";
import { connectDB } from "./database.js";
import { redisClient } from "./cache.js";

const fastify = Fastify({ logger: true });

// Connect to PostgreSQL & Redis when the worker starts
await connectDB();
await redisClient.connect();

fastify.get("/", async (request, reply) => {
  return { message: "Hello, Fastify!" };
});

// API Route: Fetch Data from PostgreSQL (with Redis caching)
fastify.get("/data/:id", async (request, reply) => {
  const { id } = request.params;

  try {
    // 1️⃣ Check Redis cache first
    const cachedData = await redisClient.get(id);
    if (cachedData) {
      console.log(`🔵 Cache hit for ID: ${id}`);
      return reply.send(JSON.parse(cachedData));
    }

    // 2️⃣ Query PostgreSQL if not cached
    console.log(`🟡 Cache miss for ID: ${id}. Fetching from database...`);
    const result = await pool.query("SELECT * FROM my_table WHERE id = $1", [id]);

    if (result.rows.length === 0) {
      return reply.status(404).send({ error: "Data not found" });
    }

    const data = result.rows[0];

    // 3️⃣ Store result in Redis (cache for 60 seconds)
    await redisClient.set(id, JSON.stringify(data), { EX: 60 });

    return reply.send(data);
  } catch (error) {
    console.error("❌ Error:", error);
    return reply.status(500).send({ error: "Internal Server Error" });
  }
});

// Start Fastify only when not in test mode
if (process.env.NODE_ENV !== "test") {
  fastify.listen({ port: 3000, host: "0.0.0.0" }, (err) => {
    if (err) {
      console.error("❌ Worker failed to start:", err);
      process.exit(1);
    }
    console.log(`✅ Worker process running on port 3000`);
  });
};

export default fastify;
