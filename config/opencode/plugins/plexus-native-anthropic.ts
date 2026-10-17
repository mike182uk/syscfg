import type { Plugin } from "@opencode/plugin";

// @mcowger/opencode-plexus@1.13.1 selects the AI SDK Anthropic adapter, whose
// OpenCode 2.0.26 bridge omits prompt-cache markers. Use the native adapter to
// restore caching. Remove this workaround when the Plexus plugin selects it itself.
export default {
  id: "plexus-native-anthropic",
  async setup(ctx) {
    await ctx.model.transform((editor) => {
      for (const model of editor.list("plexus")) {
        if (model.package !== "aisdk:@ai-sdk/anthropic") continue;
        editor.update("plexus", model.id.toString(), (draft) => {
          draft.package = "@opencode/ai/providers/anthropic";
        });
      }
    });
  },
} satisfies Plugin.Plugin;
