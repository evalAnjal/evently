-- Migration: Backfill created_by_email for existing organiser events
-- Run after 003_add_created_by_email_to_events.sql

UPDATE events e
JOIN organisers o ON e.organiser_id = o.id
SET e.created_by_email = o.email
WHERE e.created_by_email IS NULL;
