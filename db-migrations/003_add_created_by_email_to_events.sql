-- Migration: Add created_by_email to events
-- Run after 001/002 migrations

ALTER TABLE events
  ADD COLUMN IF NOT EXISTS created_by_email VARCHAR(150);

CREATE INDEX IF NOT EXISTS idx_events_created_by_email ON events(created_by_email);

-- Optional backfill if you already have organiser-linked rows and want creator email populated:
-- UPDATE events e
-- SET created_by_email = o.email
-- FROM organisers o
-- WHERE e.organiser_id = o.id AND e.created_by_email IS NULL;
