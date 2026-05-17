-- Migration: Link organisers records with users records
-- Run after 001_create_organisers_table.sql

ALTER TABLE organisers
  ADD COLUMN IF NOT EXISTS user_id INT UNIQUE REFERENCES users(id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_organisers_user_id ON organisers(user_id);
