import { existsSync } from "node:fs"
import type { Config, Plugin } from "@opencode-ai/plugin"

// exe-dev-llm
//
// On an exe.dev VM, registers the exe.dev LLM gateway as a single opencode
// provider ("exe-dev-llm") whose models are fetched from the gateway at
// startup so the list stays fresh.
//
// The gateway (https://llm.int.exe.xyz) fronts several upstream providers
// (OpenAI via a connected ChatGPT subscription or key, Anthropic, Fireworks,
// xAI, ...). Those upstreams do NOT share one wire protocol:
//
//   - openai/*     -> OpenAI Responses API       -> @ai-sdk/openai
//   - anthropic/*  -> Anthropic Messages API     -> @ai-sdk/anthropic
//   - everything   -> OpenAI chat-completions    -> @ai-sdk/openai-compatible
//     else (fireworks/*, xai/*, ...)
//
// opencode supports a per-model provider override (model.provider.npm), so we
// keep every model under one provider block and set each model's SDK by its
// id prefix, with an openai-compatible default for the block.
//
// Two gateway quirks the mapping accounts for:
//
//   1. Prefixed ids are what route on the wire. The /v1/models list returns
//      every model twice - once prefixed ("fireworks/gpt-oss-20b") and once
//      bare ("gpt-oss-20b") - but calling a bare fireworks id 400s; the
//      prefixed id is required. So we key the picker entry off the bare id
//      (clean label) but send the prefixed id on the wire via `model.id`, and
//      skip the bare-alias list entries.
//
//   2. The OpenAI (ChatGPT-subscription) path routes through Codex, which
//      rejects requests unless `store` is false. opencode merges a model's
//      `options` into the request providerOptions, so we set store:false on
//      openai/* models. Note this path only accepts the current Codex models
//      (gpt-5.5, gpt-5.4, gpt-5.4-mini, gpt-5.6-*); other advertised openai/*
//      ids error at call time. This is a verbatim dump, so those entries are
//      left in rather than hardcoding an allowlist.
//
// Display names: the gateway supplies a `displayName` for some models (mostly
// fireworks, e.g. "GLM 5.2"); where it doesn't (openai/*, xai/*) we prettify
// the id (e.g. "gpt-5.4-mini" -> "GPT 5.4 Mini").
//
// Off exe.dev (no /exe.dev marker) the plugin does nothing, so the provider
// never appears on other machines and startup is never delayed. The model
// fetch uses a short timeout so startup never hangs if the gateway is slow.

const GATEWAY = "https://llm.int.exe.xyz/v1"
const FETCH_TIMEOUT_MS = 3000

const PROVIDER_ID = "exe-dev-llm"
const PROVIDER_NAME = "exe.dev LLM"

// SDK package used for a model whose id prefix isn't in NPM_BY_PREFIX. Most
// upstreams (fireworks, xai, ...) speak plain OpenAI chat-completions.
const FALLBACK_NPM = "@ai-sdk/openai-compatible"

// Per-prefix SDK override. A prefix absent here uses FALLBACK_NPM.
const NPM_BY_PREFIX: Record<string, string> = {
  openai: "@ai-sdk/openai",
  anthropic: "@ai-sdk/anthropic",
}

interface ModelList {
  data?: Array<{ id: string; displayName?: string }>
}

// Acronyms to upper-case wholesale when prettifying an id.
const ACRONYMS: Record<string, string> = { gpt: "GPT", oss: "OSS" }

// Derive a display name from a bare model id, e.g. "gpt-5.4-mini" -> "GPT 5.4
// Mini". Used only when the gateway gives no displayName of its own.
function prettify(bareId: string): string {
  return bareId
    .split("-")
    .map((part) => {
      const low = part.toLowerCase()

      if (ACRONYMS[low]) {
        return ACRONYMS[low]
      }

      // OpenAI reasoning models (o1/o3/o4) read better lower-cased.
      if (/^o\d+$/.test(low)) {
        return low
      }

      return part.charAt(0).toUpperCase() + part.slice(1)
    })
    .join(" ")
}

// A single opencode provider entry and its per-model config, as accepted by
// Config["provider"].
type ProviderBlock = NonNullable<Config["provider"]>[string]
type ModelBlock = NonNullable<ProviderBlock["models"]>[string]

function modelBlock(
  prefixedId: string,
  prefix: string,
  bareId: string,
  displayName: string | undefined,
): ModelBlock {
  const npm = NPM_BY_PREFIX[prefix] ?? FALLBACK_NPM

  const block: ModelBlock = {
    // `id` is the upstream id sent on the wire; the gateway routes by the
    // prefixed form, so keep the prefix here even though the map key is bare.
    id: prefixedId,
    // Prefer the gateway's own display name; otherwise prettify the id.
    name: displayName || prettify(bareId),
    // Per-model SDK, so one provider block can serve mixed wire protocols.
    provider: { npm },
  }

  // The ChatGPT-backed OpenAI (Codex) path rejects requests unless store is
  // false. opencode merges model.options into the request providerOptions.
  if (prefix === "openai") {
    block.options = { store: false }
  }

  return block
}

async function models(): Promise<Record<string, ModelBlock>> {
  const res = await fetch(`${GATEWAY}/models`, {
    signal: AbortSignal.timeout(FETCH_TIMEOUT_MS),
  })

  if (!res.ok) {
    throw new Error(`gateway returned ${res.status}`)
  }

  const body = (await res.json()) as ModelList
  const result: Record<string, ModelBlock> = {}

  for (const model of body.data ?? []) {
    // Only the provider-prefixed ids route reliably; the bare aliases the
    // gateway also lists are duplicates, so skip them.
    const slash = model.id.indexOf("/")

    if (slash <= 0) {
      continue
    }

    const prefix = model.id.slice(0, slash)
    const bareId = model.id.slice(slash + 1)

    result[bareId] = modelBlock(model.id, prefix, bareId, model.displayName)
  }

  return result
}

export default (async () => {
  // Cheap synchronous check: only exe.dev VMs have the /exe.dev marker. This
  // avoids any network call (and startup delay) on other machines.
  if (!existsSync("/exe.dev")) {
    return {}
  }

  let modelBlocks: Record<string, ModelBlock>

  try {
    modelBlocks = await models()
  } catch {
    // Gateway unreachable or slow; skip registering rather than block startup.
    return {}
  }

  if (Object.keys(modelBlocks).length === 0) {
    return {}
  }

  return {
    config: async (cfg: Config) => {
      const provider = (cfg.provider ??= {})
      provider[PROVIDER_ID] = {
        // Default SDK for models without a per-model override.
        npm: FALLBACK_NPM,
        name: PROVIDER_NAME,
        // The gateway authenticates the VM at the edge, so no real key is
        // needed; the SDKs still require a non-empty apiKey to be set.
        options: { baseURL: GATEWAY, apiKey: "implicit" },
        models: modelBlocks,
      }
    },
  }
}) satisfies Plugin
