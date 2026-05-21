#!/usr/bin/env bash
set -euo pipefail

DB_SCHEMA=eventdb
MYSQL_CLI="mysql -udemo -pdemo ${DB_SCHEMA}"

echo "Ensuring organisers table exists..."
${MYSQL_CLI} -e "CREATE TABLE IF NOT EXISTS organisers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  district VARCHAR(100) NOT NULL,
  address TEXT,
  verified TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);"

ensure_index() {
  local table="$1"; local index="$2"; local cols="$3"
  local exists=$(${MYSQL_CLI} -N -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA='${DB_SCHEMA}' AND TABLE_NAME='${table}' AND INDEX_NAME='${index}';")
  if [ "${exists}" -eq 0 ]; then
    echo "Creating index ${index} on ${table}(${cols})"
    ${MYSQL_CLI} -e "CREATE INDEX ${index} ON ${table}(${cols});"
  else
    echo "Index ${index} already exists on ${table}"
  fi
}

ensure_column() {
  local table="$1"; local column="$2"; local definition="$3"
  local exists=$(${MYSQL_CLI} -N -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='${DB_SCHEMA}' AND TABLE_NAME='${table}' AND COLUMN_NAME='${column}';")
  if [ "${exists}" -eq 0 ]; then
    echo "Adding column ${column} to ${table}"
    ${MYSQL_CLI} -e "ALTER TABLE ${table} ADD COLUMN ${definition};"
  else
    echo "Column ${column} already exists on ${table}"
  fi
}

ensure_fk() {
  local table="$1"; local fkname="$2"; local col="$3"; local reftable="$4"; local refcol="$5"; local ondelete="$6"
  local exists=$(${MYSQL_CLI} -N -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA='${DB_SCHEMA}' AND TABLE_NAME='${table}' AND CONSTRAINT_NAME='${fkname}' AND CONSTRAINT_TYPE='FOREIGN KEY';")
  if [ "${exists}" -eq 0 ]; then
    echo "Adding FK ${fkname} on ${table}(${col}) -> ${reftable}(${refcol})"
    ${MYSQL_CLI} -e "ALTER TABLE ${table} ADD CONSTRAINT ${fkname} FOREIGN KEY (${col}) REFERENCES ${reftable}(${refcol}) ON DELETE ${ondelete};"
  else
    echo "Foreign key ${fkname} already exists on ${table}"
  fi
}

echo "Ensuring organisers indexes and user_id..."
ensure_column organisers user_id "INT UNIQUE"
ensure_index organisers idx_organisers_email email
ensure_index organisers idx_organisers_district district
ensure_index organisers idx_organisers_verified verified
ensure_index organisers idx_organisers_user_id user_id
ensure_fk organisers fk_organisers_user user_id users id CASCADE

echo "Ensuring events columns and indexes..."
ensure_column events organiser_id "INT NULL"
ensure_column events district "VARCHAR(100)"
ensure_column events created_by_email "VARCHAR(150)"
ensure_column events capacity "INT"
ensure_column events event_type "VARCHAR(255)"

ensure_index events idx_events_organiser_id organiser_id
ensure_index events idx_events_district district
ensure_index events idx_events_created_by_email created_by_email

ensure_fk events fk_events_organiser organiser_id organisers id "SET NULL"

echo "Backfilling created_by_email where possible..."
${MYSQL_CLI} -e "UPDATE events e JOIN organisers o ON e.organiser_id = o.id SET e.created_by_email = o.email WHERE e.created_by_email IS NULL;"

echo "Migrations applied (idempotent runner finished)."
