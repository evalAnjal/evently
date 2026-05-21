-- Migration: Add organiser_id and district columns to events and FK
ALTER TABLE events
  ADD COLUMN organiser_id INT NULL;

ALTER TABLE events
  ADD COLUMN district VARCHAR(100);

ALTER TABLE events
  ADD INDEX idx_events_organiser_id (organiser_id);

ALTER TABLE events
  ADD INDEX idx_events_district (district);

ALTER TABLE events
  ADD CONSTRAINT fk_events_organiser FOREIGN KEY (organiser_id) REFERENCES organisers(id) ON DELETE SET NULL;

-- Ensure users.district index exists
ALTER TABLE users ADD INDEX idx_users_district (district);
