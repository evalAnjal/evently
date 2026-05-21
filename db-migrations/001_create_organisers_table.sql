-- Migration: Create organisers table
-- Date: 2026-05-03
-- Description: Create a new organisers table to store organisation/entity details separately

CREATE TABLE IF NOT EXISTS organisers (
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
);

-- Add indexes for performance
-- Indexes created previously; skip recreating here to avoid duplicates

ALTER TABLE events
  ADD COLUMN IF NOT EXISTS organiser_id INT NULL;

ALTER TABLE events
  ADD COLUMN district VARCHAR(100);

CREATE INDEX idx_events_organiser_id ON events(organiser_id);
CREATE INDEX idx_events_district ON events(district);

-- Add district to users (for members)
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS district VARCHAR(100);

CREATE INDEX idx_users_district ON users(district);
