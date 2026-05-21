-- Migration: Add created_by_email to events
-- Run after 001/002 migrations

ALTER TABLE events
  ADD COLUMN created_by_email VARCHAR(150);

CREATE INDEX idx_events_created_by_email ON events(created_by_email);

-- Optional MySQL-friendly backfill (JOIN syntax):
-- UPDATE events e
-- JOIN organisers o ON e.organiser_id = o.id
-- SET e.created_by_email = o.email
-- WHERE e.created_by_email IS NULL;
