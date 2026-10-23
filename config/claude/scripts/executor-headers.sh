#!/usr/bin/env sh

printf '{"Authorization":"Bearer %s"}\n' "$("$HOME/.local/bin/syscfg-env" .env EXECUTOR_TOKEN_CC)"
