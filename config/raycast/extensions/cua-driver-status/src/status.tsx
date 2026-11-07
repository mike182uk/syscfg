import { Color, Icon, MenuBarExtra } from "@raycast/api";
import { execFileSync } from "node:child_process";

const ACTIVE_WITHIN_SECONDS = 15;

interface Session {
  client_kind: string;
  idle_seconds: number;
  owner_short_id: string;
  recording_active: boolean;
  session: string | null;
}

interface SessionList {
  sessions: Session[];
}

function readSessions(): Session[] {
  try {
    const output = execFileSync("cua-driver", ["sessions", "--json"], {
      encoding: "utf8",
      timeout: 5000,
      env: { ...process.env, PATH: `/opt/homebrew/bin:/usr/local/bin:${process.env.PATH ?? ""}` },
    });

    const list: SessionList = JSON.parse(output);

    return list.sessions;
  } catch {
    return [];
  }
}

export default function Command() {
  const active = readSessions().filter((s) => s.idle_seconds <= ACTIVE_WITHIN_SECONDS);

  if (active.length === 0) {
    return null;
  }

  return (
    <MenuBarExtra icon={{ source: Icon.CircleFilled, tintColor: Color.Purple }} tooltip="cua-driver is in use">
      <MenuBarExtra.Section title="cua-driver sessions">
        {active.map((s) => (
          <MenuBarExtra.Item
            key={s.owner_short_id + (s.session ?? "")}
            icon={s.recording_active ? Icon.Video : Icon.Mouse}
            title={s.session ?? s.client_kind}
            subtitle={`idle ${s.idle_seconds}s`}
          />
        ))}
      </MenuBarExtra.Section>
    </MenuBarExtra>
  );
}
