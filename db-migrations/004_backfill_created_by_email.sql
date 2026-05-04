-- Migration: Backfill created_by_email for existing organiser events
-- Run after 003_add_created_by_email_to_events.sql

UPDATE events e
SET created_by_email = o.email
FROM organisers o
WHERE e.organiser_id = o.id
  AND e.created_by_email IS NULL;
