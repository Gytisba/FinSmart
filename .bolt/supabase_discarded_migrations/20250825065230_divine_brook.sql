/*
  # Fix courses RLS policy

  1. Security Changes
    - Drop the existing policy that references the users table
    - Create a new policy that allows anon users to view published courses
    - Create a separate policy for authenticated users to manage their own courses

  The issue was that the original policy tried to access auth.users table
  which anon role doesn't have permission to read.
*/

-- Drop the existing problematic policy
DROP POLICY IF EXISTS "Authors can manage their courses" ON courses;

-- Create a simple policy for viewing published courses (anon + authenticated)
CREATE POLICY "Anyone can view published courses"
  ON courses
  FOR SELECT
  TO public
  USING (status = 'published'::content_status);

-- Create a policy for authenticated users to manage their own courses
CREATE POLICY "Authors can manage their own courses"
  ON courses
  FOR ALL
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

-- Create a policy for admins/authors to manage all courses (if needed)
-- This uses a safer approach by checking user metadata directly
CREATE POLICY "Admins can manage all courses"
  ON courses
  FOR ALL
  TO authenticated
  USING (
    (auth.jwt() ->> 'role') = 'admin' OR 
    (auth.jwt() ->> 'role') = 'author'
  )
  WITH CHECK (
    (auth.jwt() ->> 'role') = 'admin' OR 
    (auth.jwt() ->> 'role') = 'author'
  );