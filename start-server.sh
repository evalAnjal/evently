#!/usr/bin/env bash
set -euo pipefail

# start-server.sh
# Responsibilities:
# - Ensure a local MySQL container is running (demo-mysql)
# - Run idempotent MySQL migrations (db-migrations/run_mysql_idempotent_migrations.sh)
# - Ensure MySQL connector is available in the local Maven repo
# - Free port 8080 and start Jetty with DB env vars

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

DB_IMAGE="${DB_IMAGE:-mysql:8.0}"
DB_CONTAINER="${DB_CONTAINER:-demo-mysql}"
DB_NAME="${DB_NAME:-eventdb}"
DB_USER="${DB_USER:-demo}"
DB_PASS="${DB_PASS:-demo}"
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-password}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
CONNECTOR_VERSION="${CONNECTOR_VERSION:-8.0.32}"

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

ensure_docker() {
	if ! command -v docker >/dev/null 2>&1; then
		echo "docker is not installed or not in PATH. Please install docker and re-run."
		return 1
	fi
	return 0
}

ensure_mysql_container() {
	ensure_docker || return 1

	# If container exists and is running, nothing to do
	if docker ps --format '{{.Names}}' | grep -qw "$DB_CONTAINER"; then
		echo "Found running MySQL container: $DB_CONTAINER"
		return 0
	fi

	# If container exists but stopped, start it
	if docker ps -a --format '{{.Names}}' | grep -qw "$DB_CONTAINER"; then
		echo "Starting existing container $DB_CONTAINER..."
		docker start "$DB_CONTAINER"
		return 0
	fi

	echo "Creating and starting MySQL container $DB_CONTAINER (image: $DB_IMAGE)..."
	docker run -d --name "$DB_CONTAINER" -p ${MYSQL_PORT}:3306 \
		-e MYSQL_DATABASE="$DB_NAME" \
		-e MYSQL_USER="$DB_USER" \
		-e MYSQL_PASSWORD="$DB_PASS" \
		-e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
		--health-cmd='mysqladmin ping -h localhost -p${MYSQL_ROOT_PASSWORD}' --health-interval=5s --health-timeout=2s --health-retries=12 \
		"$DB_IMAGE" >/dev/null

	echo "Waiting for MySQL to become available..."
	for i in {1..60}; do
		if docker exec "$DB_CONTAINER" mysql -u"$DB_USER" -p"$DB_PASS" -e 'SELECT 1' "$DB_NAME" >/dev/null 2>&1; then
			echo "MySQL is ready"
			return 0
		fi
		sleep 1
	done
	echo "Timed out waiting for MySQL to start"
	return 1
}

run_migrations() {
	if [ -x "db-migrations/run_mysql_idempotent_migrations.sh" ] || [ -f "db-migrations/run_mysql_idempotent_migrations.sh" ]; then
		echo "Running idempotent migrations inside $DB_CONTAINER..."
		docker exec -i "$DB_CONTAINER" bash -s < db-migrations/run_mysql_idempotent_migrations.sh || true
	else
		echo "No idempotent migration runner found at db-migrations/run_mysql_idempotent_migrations.sh. Skipping."
	fi
}

run_seeds() {
	if [ -f "db-migrations/seed_users.sh" ]; then
		echo "Running idempotent seeds inside $DB_CONTAINER..."
		docker exec -i "$DB_CONTAINER" bash -s < db-migrations/seed_users.sh || true
	else
		echo "No seed script found at db-migrations/seed_users.sh. Skipping."
	fi
}

ensure_mysql_connector() {
	local group_path="$HOME/.m2/repository/com/mysql/mysql-connector-j/$CONNECTOR_VERSION"
	local jar="$group_path/mysql-connector-j-$CONNECTOR_VERSION.jar"
	if [ -f "$jar" ]; then
		echo "MySQL connector already present in local maven repo: $jar"
		return 0
	fi

	echo "Attempting to download mysql-connector-j:$CONNECTOR_VERSION..."
	tmpfile="/tmp/mysql-connector-j-$CONNECTOR_VERSION.jar"
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL -o "$tmpfile" "https://repo1.maven.org/maven2/mysql/mysql-connector-j/$CONNECTOR_VERSION/mysql-connector-j-$CONNECTOR_VERSION.jar" || true
	fi
	if [ ! -f "$tmpfile" ]; then
		echo "Failed to download connector to $tmpfile; check network or provide jar at $tmpfile"
		return 1
	fi

	echo "Installing connector into local maven repo..."
	./mvnw install:install-file -Dfile="$tmpfile" -DgroupId=com.mysql -DartifactId=mysql-connector-j -Dversion="$CONNECTOR_VERSION" -Dpackaging=jar -DgeneratePom=true
}

start_jetty() {
	export DB_URL="${DB_URL:-jdbc:mysql://localhost:3306/$DB_NAME?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC}"
	export DB_USER="${DB_USER:-$DB_USER}"
	export DB_PASS="${DB_PASS:-$DB_PASS}"

	free_port_8080
	echo "Starting Jetty (this will block)"
	./mvnw -DskipTests org.eclipse.jetty.ee10:jetty-ee10-maven-plugin:12.0.15:run
}

# Main flow
ensure_mysql_container || echo "Warning: MySQL container not available; you can still start the server if you have external DB."
run_migrations || echo "Migration run returned non-zero (continuing)"
run_seeds || echo "Seeding returned non-zero (continuing)"
ensure_mysql_connector || echo "Connector install failed or skipped; ensure connector is available in local maven repo."
start_jetty

