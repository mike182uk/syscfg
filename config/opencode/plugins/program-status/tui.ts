import { Plugin } from "@opencode/plugin/tui";

// OpenCode reports working and blocked with the Program Status Protocol
// (OSC 7501), but reports idle rather than done when a turn ends, so terminals
// that support the protocol show nothing to come back to. This adds done and
// error.
//
// https://www.superlogical.com/rex/docs/build/program-status
//
// The report goes to the root record because terminals may treat it
// differently, for example Rex only plays its sound for that record. OpenCode
// writes idle to it just after the turn ends, so the report is delayed to land
// after that. OpenCode leaves the record alone until its own state changes, such
// as the next turn starting.
//
// Remove this plugin once OpenCode reports done and error itself:
// https://github.com/anomalyco/opencode/issues/60411
//
// Working and blocked were added in: https://github.com/anomalyco/opencode/pull/55172
// which left done and error for that follow-up.

const delay = 500;

export default Plugin.define({
  id: "program-status",
  setup(context) {
    let pending: ReturnType<typeof setTimeout> | undefined;

    function shownRoot() {
      const route = context.ui.router.current();

      return route.type === "session" ? context.data.session.root(route.sessionID) : undefined;
    }

    function finished(state: "done" | "error") {
      return ({ data }: { data: { sessionID: string; error?: { message: string } } }) => {
        if (data.sessionID !== shownRoot()) return;

        // setProgramStatus throws on control characters or an over-long message
        const message = (data.error?.message ?? context.data.session.get(data.sessionID)?.title)
          ?.replace(/[\u0000-\u001f\u007f-\u009f]+/g, " ")
          .trim()
          .slice(0, 200);

        clearTimeout(pending);

        pending = setTimeout(() => {
          // A rejected report must not break the TUI
          try {
            context.renderer.setProgramStatus({ state, app: "opencode", ...(message && { message }) });
          } catch {}
        }, delay);
      };
    }

    function cancel({ data }: { data: { sessionID: string } }) {
      if (data.sessionID === shownRoot()) clearTimeout(pending);
    }

    const stops = [
      context.data.on("session.execution.succeeded", finished("done")),
      context.data.on("session.execution.failed", finished("error")),
      context.data.on("session.execution.started", cancel),
      context.data.on("session.execution.interrupted", cancel),
    ];

    return () => {
      clearTimeout(pending);

      for (const stop of stops) stop();
    };
  },
});
