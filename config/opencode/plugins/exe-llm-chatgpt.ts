import { existsSync } from "node:fs"
import type { Plugin } from "@opencode-ai/plugin"

// exe-llm-chatgpt
//
// On an exe.dev VM, registers the exe.dev LLM gateway as a provider for the
// OpenAI models backed by a connected ChatGPT subscription. The model list is
// fetched at startup so it stays fresh.
//
// Off exe.dev (no /exe.dev marker) the plugin does nothing, so the provider
// never appears on other machines and startup is never delayed. The model
// fetch uses a short timeout so startup never hangs if the gateway is slow.

const GATEWAY = "https://llm.int.exe.xyz/v1"
const FETCH_TIMEOUT_MS = 3000

interface ModelList {
  data?: Array<{ id: string }>
}

async function openaiModels(): Promise<Record<string, { name: string }>> {
  const res = await fetch(`${GATEWAY}/models`, {
    signal: AbortSignal.timeout(FETCH_TIMEOUT_MS),
  })
  if (!res.ok) throw new Error(`gateway returned ${res.status}`)

  const body = (await res.json()) as ModelList
  const models: Record<string, { name: string }> = {}

  for (const model of body.data ?? []) {
    // Register the OpenAI (ChatGPT-subscription) models under their bare id.
    // These are served via the OpenAI Responses API, so the provider uses the
    // native @ai-sdk/openai package (not openai-compatible, which is chat-only).
    if (!model.id.startsWith("openai/")) continue
    const id = model.id.slice("openai/".length)
    models[id] = { name: id }
  }

  return models
}

export default (async () => {
  // Cheap synchronous check: only exe.dev VMs have the /exe.dev marker. This
  // avoids any network call (and startup delay) on other machines.
  if (!existsSync("/exe.dev")) return {}

  let models: Record<string, { name: string }>
  try {
    models = await openaiModels()
  } catch {
    // Gateway unreachable or slow; skip registering rather than block startup.
    return {}
  }

  if (Object.keys(models).length === 0) return {}

  return {
    config: (cfg: Record<string, unknown>) => {
      const provider = (cfg.provider ??= {}) as Record<string, unknown>
      provider["exe-llm-chatgpt"] = {
        npm: "@ai-sdk/openai",
        name: "exe.dev LLM (ChatGPT)",
        // The gateway authenticates the VM at the edge, so no real key is
        // needed; the SDK still requires a non-empty apiKey to be set.
        options: { baseURL: GATEWAY, apiKey: "implicit" },
        models,
      }
    },
  }
}) satisfies Plugin
