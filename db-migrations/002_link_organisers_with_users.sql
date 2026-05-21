-- Migration: Link organisers records with users records
-- Run after 001_create_organisers_table.sql

ALTER TABLE organisers
  ADD COLUMN user_id INT UNIQUE;

ALTER TABLE organisers
  ADD CONSTRAINT fk_organisers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

CREATE INDEX idx_organisers_user_id ON organisers(user_id);
