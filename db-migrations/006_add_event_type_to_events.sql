-- Migration: Add event_type column to events
ALTER TABLE events
  ADD COLUMN event_type VARCHAR(255);

UPDATE events
SET event_type = 'General'
WHERE event_type IS NULL;
