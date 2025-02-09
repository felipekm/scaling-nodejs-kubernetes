import os from "os";
import cluster from "cluster";

// This prevents excessive worker creation.
const numCPUs = Math.max(2, os.cpus().length / 2);  // At least 2 workers

// This will create a worker for each CPU core.
// const numCPUs = os.cpus().length;

if (cluster.isPrimary) {
  console.log(`🛠 Primary process ${process.pid} is managing workers`);

  // Fork worker processes based on CPU count
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  // Restart workers if they die
  cluster.on("exit", (worker) => {
    console.log(`❌ Worker ${worker.process.pid} died. Restarting...`);
    cluster.fork();
  });
} else {
  // Start worker process (Fastify API)
  import("./worker.js");
}
