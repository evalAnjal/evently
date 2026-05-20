-- Migration: Create organisers table
-- Date: 2026-05-03
-- Description: Create a new organisers table to store organisation/entity details separately

CREATE TABLE IF NOT EXISTS organisers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(50),
  district VARCHAR(100) NOT NULL,
  address TEXT,
  verified BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS idx_organisers_email ON organisers(email);
CREATE INDEX IF NOT EXISTS idx_organisers_district ON organisers(district);
CREATE INDEX IF NOT EXISTS idx_organisers_verified ON organisers(verified);

-- Add foreign key to events table to link events to organiser
ALTER TABLE events
  ADD COLUMN IF NOT EXISTS organiser_id INT REFERENCES organisers(id) ON DELETE SET NULL;

-- Add district to events
ALTER TABLE events
  ADD COLUMN IF NOT EXISTS district VARCHAR(100);

CREATE INDEX IF NOT EXISTS idx_events_organiser_id ON events(organiser_id);
CREATE INDEX IF NOT EXISTS idx_events_district ON events(district);

-- Add district to users (for members)
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS district VARCHAR(100);

CREATE INDEX IF NOT EXISTS idx_users_district ON users(district);
