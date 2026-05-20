#!/usr/bin/env bash
set -euo pipefail

# Ensure port 8080 is free before starting Jetty.
free_port_8080() {
	local pids=()

	if command -v lsof >/dev/null 2>&1; then
		mapfile -t pids < <(lsof -t -iTCP:8080 -sTCP:LISTEN 2>/dev/null || true)
	elif command -v fuser >/dev/null 2>&1; then
		mapfile -t pids < <(fuser -n tcp 8080 2>/dev/null | tr ' ' '\n' | sed '/^$/d' || true)
	elif command -v ss >/dev/null 2>&1; then
		mapfile -t pids < <(ss -ltnp 2>/dev/null | sed -n 's/.*pid=\([0-9]\+\).*:8080.*/\1/p' | sort -u || true)
	fi

	if ((${#pids[@]} > 0)); then
		echo "Port 8080 is in use by PID(s): ${pids[*]}. Stopping..."
		kill -TERM "${pids[@]}" 2>/dev/null || true
		sleep 1

		local remaining=()
		for pid in "${pids[@]}"; do
			if kill -0 "$pid" 2>/dev/null; then
				remaining+=("$pid")
			fi
		done

		if ((${#remaining[@]} > 0)); then
			echo "Force-killing remaining PID(s): ${remaining[*]}"
			kill -KILL "${remaining[@]}" 2>/dev/null || true
		fi
	fi
}

# Start the Jakarta Servlet app on embedded Jetty (port 8080).
cd "$(dirname "$0")"
free_port_8080
./mvnw -DskipTests org.eclipse.jetty.ee10:jetty-ee10-maven-plugin:12.0.15:run
