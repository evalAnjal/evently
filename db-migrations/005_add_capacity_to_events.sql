-- Migration: Add capacity column to events
-- Run after 004_backfill_created_by_email.sql

ALTER TABLE events
  ADD COLUMN IF NOT EXISTS capacity INTEGER;
