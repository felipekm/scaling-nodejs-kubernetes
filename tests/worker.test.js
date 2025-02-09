import app from "../src/worker.js";
import { describe, it, expect, beforeAll, afterAll } from "@jest/globals";

beforeAll(async () => {
  await app.ready();
});

afterAll(async () => {
  await app.close();
});

describe("Fastify API Tests", () => {
  it("should return a 200 status for the root endpoint", async () => {
    const response = await app.inject({
      method: "GET",
      url: "/",
    });

    expect(response.statusCode).toBe(200);
    expect(response.json()).toHaveProperty("message", "Hello, Fastify!");
  });

  it("should return a 404 for an unknown endpoint", async () => {
    const response = await app.inject({
      method: "GET",
      url: "/unknown",
    });

    expect(response.statusCode).toBe(404);
  });
});
