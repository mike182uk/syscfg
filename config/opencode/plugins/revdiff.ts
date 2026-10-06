import { execFile } from "node:child_process";
import { homedir } from "node:os";
import path from "node:path";
import { promisify } from "node:util";

const execute = promisify(execFile);
const scriptPath = path.join(homedir(), ".config/opencode/tools/launch-revdiff.sh");
const exitCodeAnnotations = 10;

interface RevdiffInput {
  ref?: string;
  staged?: boolean;
  only?: string[];
}

function isRevdiffInput(input: unknown): input is RevdiffInput {
  if (!input || typeof input !== "object") return false;
  const value = input as Record<string, unknown>;
  return (
    (value.ref === undefined || typeof value.ref === "string") &&
    (value.staged === undefined || typeof value.staged === "boolean") &&
    (value.only === undefined ||
      (Array.isArray(value.only) && value.only.every((item) => typeof item === "string")))
  );
}

export default {
  id: "revdiff",
  async setup(ctx) {
    await ctx.tool.transform((editor) => {
      editor.add({
        name: "revdiff",
        description:
          "Launch revdiff in a terminal overlay to review git diffs and capture annotations. Opens an interactive diff viewer in a split pane and returns any annotations the user wrote.",
        input: {
          type: "object",
          properties: {
            ref: { type: "string", description: "Git ref to diff against. Omit to diff the working tree." },
            staged: { type: "boolean", description: "Diff staged changes instead of the working tree." },
            only: { type: "array", items: { type: "string" }, description: "Limit the diff to these file paths." },
          },
          additionalProperties: false,
        },
        async execute(input, context) {
          if (!isRevdiffInput(input)) throw new Error("Invalid revdiff arguments");
          const args = [
            ...(input.ref ? [input.ref] : []),
            ...(input.staged ? ["--staged"] : []),
            ...(input.only?.map((file) => `--only=${file}`) ?? []),
          ];

          try {
            const result = await execute("bash", [scriptPath, ...args], {
              cwd: ctx.location.directory,
              signal: context.signal,
              encoding: "utf8",
            });
            return { content: result.stdout.trim() || "(no annotations)" };
          } catch (error) {
            const failure = error as Error & { code?: number; stderr?: string; stdout?: string };
            if (failure.code === exitCodeAnnotations) {
              return { content: failure.stdout?.trim() || "(no annotations)" };
            }
            throw new Error(failure.stderr?.trim() || failure.message);
          }
        },
      });
    });
  },
};
