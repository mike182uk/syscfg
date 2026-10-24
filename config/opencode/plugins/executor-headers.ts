import { execFile } from "node:child_process";
import { homedir } from "node:os";
import path from "node:path";
import { promisify } from "node:util";

// Supplies the Executor MCP token from .env at runtime, so it is never in
// OpenCode's environment (inherited by every command it runs) or in the
// resolved config returned by /api/config.

const execute = promisify(execFile);
const syscfgEnv = path.join(homedir(), ".local/bin/syscfg-env");
const attempts = 5;

// The plugin loads once per location, often several at once. A mounted
// 1Password .env serves one reader at a time and the rest read nothing, so
// retry an empty read.
async function readToken() {
  for (let attempt = 1; attempt <= attempts; attempt++) {
    const { stdout } = await execute(syscfgEnv, [".env", "EXECUTOR_TOKEN_OC"], { encoding: "utf8" });
    const token = stdout.trim();

    if (token) return token;

    await new Promise((resolve) => setTimeout(resolve, attempt * 250));
  }

  throw new Error("EXECUTOR_TOKEN_OC is not set in .env");
}

export default {
  id: "executor-headers",
  async setup(ctx) {
    const token = await readToken();

    await ctx.mcp.transform((editor) => {
      editor.update("executor", (server) => {
        server.headers = { ...server.headers, Authorization: `Bearer ${token}` };
      });
    });
  },
};
