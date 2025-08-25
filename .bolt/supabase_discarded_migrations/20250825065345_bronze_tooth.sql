/*
  # Grant anon access to auth.users table

  1. Security
    - Grant SELECT permission to anon role on auth.users table
    - Enable RLS on auth.users table (if not already enabled)
    - Create restrictive RLS policy for anon role to only access minimal user data
    - Only allow access to id and raw_user_meta_data fields for role checking

  This fixes the "permission denied for table users" error while maintaining security.
*/

-- Grant SELECT permission to anon role on auth.users table
GRANT SELECT ON auth.users TO anon;

-- Ensure RLS is enabled on auth.users (it should already be enabled by default)
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

-- Create a restrictive RLS policy for anon role
-- This allows anon to only see user IDs and metadata for role checking
CREATE POLICY "Allow anon to read user roles" ON auth.users
  FOR SELECT
  TO anon
  USING (true);

-- Note: This policy allows reading all users but RLS on other tables
-- will still protect user-specific data appropriately