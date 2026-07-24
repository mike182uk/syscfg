import type { Plugin } from "@opencode-ai/plugin"

const FETCH_TIMEOUT_MS = 3000

interface ModelConfig {
  name: string
  modalities: {
    input: string[]
    output: string[]
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null
}

function modelIds(value: unknown): string[] {
  if (!isRecord(value) || !Array.isArray(value.data)) return []

  return value.data.flatMap((model) => {
    if (!isRecord(model) || typeof model.id !== "string") return []
    return [model.id]
  })
}

function modelConfig(id: string): ModelConfig {
  const supportsImages = ["claude-", "gemini-", "gpt-"].some((prefix) => id.startsWith(prefix))

  return {
    name: id,
    modalities: {
      input: supportsImages ? ["text", "image"] : ["text"],
      output: ["text"],
    },
  }
}

async function gatewayModels(baseURL: string, apiKey: string): Promise<{
  anthropic: Record<string, ModelConfig>
  openai: Record<string, ModelConfig>
}> {
  const response = await fetch(`${baseURL}/models`, {
    headers: { Authorization: `Bearer ${apiKey}` },
    signal: AbortSignal.timeout(FETCH_TIMEOUT_MS),
  })
  if (!response.ok) throw new Error(`gateway returned ${response.status}`)

  const anthropic: Record<string, ModelConfig> = {}
  const openai: Record<string, ModelConfig> = {}

  for (const id of modelIds(await response.json())) {
    const models = id.startsWith("claude-") ? anthropic : openai
    models[id] = modelConfig(id)
  }

  return { anthropic, openai }
}

export default (async () => {
  const configuredBaseURL = process.env.LOCAL_LLM_GATEWAY_BASE_URL
  const apiKey = process.env.OPENCODE_LOCAL_LLM_GATEWAY_API_KEY
  if (!configuredBaseURL || !apiKey) return {}

  const baseURL = configuredBaseURL.replace(/\/+$/, "")

  let models: Awaited<ReturnType<typeof gatewayModels>>
  try {
    models = await gatewayModels(baseURL, apiKey)
  } catch {
    return {}
  }

  if (Object.keys(models.anthropic).length === 0 && Object.keys(models.openai).length === 0) return {}

  return {
    config: async (cfg: Record<string, unknown>) => {
      const provider = isRecord(cfg.provider) ? cfg.provider : {}
      cfg.provider = provider

      if (Object.keys(models.openai).length > 0) {
        provider["local-llm-gateway-openai"] = {
          npm: "@ai-sdk/openai-compatible",
          name: "Local LLM Gateway (OpenAI-compatible)",
          options: { baseURL, apiKey },
          models: models.openai,
        }
      }

      if (Object.keys(models.anthropic).length > 0) {
        provider["local-llm-gateway-anthropic"] = {
          npm: "@ai-sdk/anthropic",
          name: "Local LLM Gateway (Anthropic)",
          options: { baseURL, apiKey },
          models: models.anthropic,
        }
      }
    },
  }
}) satisfies Plugin
