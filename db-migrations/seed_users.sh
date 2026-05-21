#!/usr/bin/env bash
set -euo pipefail

# idempotent seeding of essential users
# Inserts/updates SUPER_ADMIN and a sample member

DB_NAME="${DB_NAME:-eventdb}"
DB_USER="${DB_USER:-demo}"
DB_PASS="${DB_PASS:-demo}"

# Pre-generated bcrypt hashes (deterministic for now)
# superadmin password: admin123
SUPERADMIN_HASH='$2a$12$1QJrVxa2lyYvC8dxfn0VcuSX10Ns5y3a7TS1DkbDBlwlz1RQmCA1q'
# member password: aakanksha
MEMBER_HASH='$2a$12$20Dc5dqLJ11CHxyi8x4hzey12uZHl3K5Uxl7ko3ApCZOTpvcufmIW'

echo "Seeding users into $DB_NAME (idempotent)"

mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "\
INSERT INTO users (username,email,password,role) VALUES \
  ('superadmin','superadmin@example.com','${SUPERADMIN_HASH}','SUPER_ADMIN') \
ON DUPLICATE KEY UPDATE username=VALUES(username), password=VALUES(password), role=VALUES(role);\
"

mysql -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "\
INSERT INTO users (username,email,password,role) VALUES \
  ('aakanksha','sedhaiaakanksha@gmail.com','${MEMBER_HASH}','MEMBER') \
ON DUPLICATE KEY UPDATE username=VALUES(username), password=VALUES(password), role=VALUES(role);\
"

echo "Seeding complete."
